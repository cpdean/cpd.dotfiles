-- minuet-ai.nvim — copilot-style ghost text from the local LM Studio server.
-- same endpoint as config/opencode/opencode.json and config/crush/crush.json,
-- different job: this one is fill-in-the-middle completion only. no tools, no
-- agent, no sidebar. you type, it suggests the middle, you hit <A-y>.
--
-- this replaced avante.nvim and gen.nvim, both since removed. why FIM and not
-- an agent: avante sent ~45kb of request body and 27 tool schemas for a
-- one-line edit, which a small local model can't steer through — it reached for
-- write_to_file and clobbered a function. FIM sends the code around your cursor
-- and nothing else, so a 4b-7b model does fine.
--
-- IMPORTANT: LM Studio's /v1/completions silently ignores the `suffix` field.
-- verified by sending the same prompt with no suffix, with "return s", and with
-- a deliberately absurd suffix — all three replies were byte-identical. so
-- minuet's stock openai_fim_compatible template (prompt + suffix fields) would
-- degrade to plain prefix continuation and ramble past the cursor. instead we
-- assemble the qwen fim markers into `prompt` ourselves and set
-- `template.suffix = false` so no suffix field is sent at all.
--
-- usage:
--   type in insert mode        -> ghost text appears
--   <A-y>                      -> accept whole suggestion
--   <A-l> / <A-h>              -> cycle next / prev
--   <A-Y>                      -> accept one line
--   <A-e>                      -> dismiss
--   <leader>mm                 -> switch model (picker)
--   <leader>mt                 -> toggle auto-suggest on/off

-- qwen fim markers. qwen2.5-coder and qwen3.5 both use this scheme.
local FIM_PREFIX = "<|fim_prefix|>"
local FIM_SUFFIX = "<|fim_suffix|>"
local FIM_MIDDLE = "<|fim_middle|>"

-- one shared stop list, used verbatim by every preset below.
--
-- IMPORTANT: it has to be shared. `change_preset` merges with
-- vim.tbl_deep_extend('force', ...), which merges lists index-by-index rather
-- than replacing them — so a preset with a shorter stop list would leave the
-- previous preset's trailing entries behind. identical lists sidestep it.
--
-- `<|cursor|>` is in here because qwen2.5-coder-7b was observed leaking that
-- token mid-completion on a rust snippet. `\n\n` caps runaway generation when
-- there's no suffix to signal an end — qwen3.5-4b will otherwise invent a call
-- site and fake output comments until it hits max_tokens.
local STOP = {
  FIM_PREFIX,
  FIM_SUFFIX,
  FIM_MIDDLE,
  "<|cursor|>",
  "<|endoftext|>",
  "<|file_sep|>",
  "<|repo_name|>",
  "\n\n",
}

-- build the whole fim prompt as one string. minuet hands us the text on either
-- side of the cursor; we wrap it in the markers and send it as `prompt`.
local function fim_prompt(before, after, _)
  return FIM_PREFIX .. before .. FIM_SUFFIX .. after .. FIM_MIDDLE
end

return {
  "milanglacier/minuet-ai.nvim",
  event = "InsertEnter",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { "<leader>mm", "<cmd>Minuet change_preset<cr>", desc = "minuet: switch model" },
    { "<leader>mt", "<cmd>Minuet virtualtext toggle<cr>", desc = "minuet: toggle ghost text" },
  },
  opts = {
    provider = "openai_fim_compatible",

    -- one request per keystroke-batch. a local model has no spare capacity to
    -- generate three candidates in parallel.
    n_completions = 1,

    -- characters of surrounding code sent, split 3:1 before/after the cursor.
    -- start small and raise it once you know how fast your box actually is.
    context_window = 1024,
    context_ratio = 0.75,

    -- default is 3 seconds, which is too tight. a warm request is ~325ms, but a
    -- cold one pays for LM Studio loading the model off disk first — measured at
    -- 3.66s for coder7b and 11.23s for a 1.5b that had been unloaded. streaming
    -- is off, so a timeout means no suggestion at all rather than a partial one.
    request_timeout = 10,

    debounce = 400,
    throttle = 1000,
    notify = "warn",

    virtualtext = {
      auto_trigger_ft = { "*" },
      keymap = {
        accept = "<A-y>",
        accept_line = "<A-Y>",
        next = "<A-l>",
        prev = "<A-h>",
        dismiss = "<A-e>",
      },
      -- nvim-cmp is already bound to <Tab>/<CR> (see plugins/editing.lua), so
      -- keep ghost text out of the way while its menu is open.
      show_on_completion_menu = false,
    },

    provider_options = {
      openai_fim_compatible = {
        name = "LMStudio",
        end_point = "http://127.0.0.1:1234/v1/completions",
        -- LM Studio does no auth, but minuet always sends an Authorization
        -- header built from an env var name. TERM is always set, so it acts as
        -- a harmless placeholder.
        api_key = "TERM",
        model = "qwen2.5-coder-1.5b-instruct",
        -- streaming off, but only as a mild preference: measured at temperature
        -- 0 it makes no difference to either the text (byte-identical output) or
        -- the latency (325ms vs 328ms median over 6 runs each). off means the
        -- suggestion appears complete rather than growing in place. the one cost
        -- is that a request outrunning request_timeout yields nothing instead of
        -- a partial, which is why the timeout below is 10s not the stock 3s.
        stream = false,
        template = {
          prompt = fim_prompt,
          -- false, not nil — see the note at the top. minuet turns this into no
          -- `suffix` key at all rather than sending an ignored one.
          suffix = false,
        },
        optional = {
          -- a ceiling, not a target — the model stops when it stops, and a
          -- higher cap costs nothing on short completions (a 4-token suggestion
          -- took 0.14s at cap 56 and 0.11s at cap 256). 56 was too low and
          -- silently clipped real work: a retry-with-backoff body needed 61
          -- tokens, so both the 1.5b and qwen3.5-4b came back mid-expression
          -- with finish=length. 128 clears every case measured with headroom.
          --
          -- NB this is not what stops runaway generation — the `\n\n` entry in
          -- STOP is. every model hit finish=stop on the no-suffix probe at cap
          -- 128, so nothing here is load-bearing for safety.
          max_tokens = 128,
          top_p = 0.9,
          -- IMPORTANT: temperature 0, not omitted. leave it out and LM Studio
          -- applies its own default, which made the same cursor position
          -- suggest `session.add(user)` three times, then `session.add(users)`
          -- with a duplicated commit, then a version with a print appended —
          -- five runs, four different answers. code completion wants the
          -- likeliest continuation, and identical context should give identical
          -- ghost text. this also makes the thing debuggable: without it,
          -- comparing two configs is comparing two samples.
          temperature = 0,
          stop = STOP,
        },
      },
    },

    -- swap between the local models with <leader>mm (:Minuet change_preset).
    -- every preset sets the same keys so 'force' merging fully overrides.
    --
    -- a switch costs a cold load for any model LM Studio doesn't currently have
    -- resident — roughly 2s for the small ones, 4s for the 7b. how many stay
    -- resident is an LM Studio setting, not a fixed limit: with it turned up,
    -- the 1.5b and 3b sat loaded together through a whole benchmark run. if you
    -- see repeated cold loads, that setting is capped at one.
    presets = {
      -- scored over a 22-case suite spanning python, rust, lua, bash, fish, sql,
      -- js and go — graded on bracket balance, suffix duplication, token-cap
      -- truncation and a required-substring check per case:
      --   coder1_5b  17/22 clean   0.42s median   failures all cosmetic
      --   coder3b    16/22 clean   0.60s median   two failures wouldn't run
      -- the 3b dropped the `Op::` qualifier off rust match arms and ignored a
      -- `local ok, mod =` prefix so pcall never got called. the 1.5b's five
      -- misses were all re-emitting text that already sat below the cursor.
      -- the 7b and qwen4b were measured on an earlier, smaller probe set: 0.97s
      -- and 1.07s median, both slower than either small model.
      --
      -- warmup time in a cold LM Studio measures load state, not model speed —
      -- ignore it when comparing.

      -- the default: fastest measured and the best score on the big suite. a 1.5b
      -- beating a 3b was not the expected result, but it held up over 22 cases in
      -- nine languages, and its failure mode is the harmless one.
      coder1_5b = {
        provider_options = {
          openai_fim_compatible = {
            model = "qwen2.5-coder-1.5b-instruct",
            stream = false,
            optional = { max_tokens = 128, top_p = 0.9, temperature = 0, stop = STOP },
          },
        },
        context_window = 1024,
        request_timeout = 10,
      },

      -- a step up in size that did not buy accuracy. still a good model and
      -- worth switching to on code the 1.5b visibly fumbles — it wrote a better
      -- dataclass and docstring than the 1.5b did.
      coder3b = {
        provider_options = {
          openai_fim_compatible = {
            model = "qwen2.5-coder-3b-instruct",
            stream = false,
            optional = { max_tokens = 128, top_p = 0.9, temperature = 0, stop = STOP },
          },
        },
        context_window = 1024,
        request_timeout = 10,
      },

      -- bigger and slower with nothing to show for it: it was the one model
      -- that flubbed the rust probe, opening the loop and never closing it.
      -- kept around in case it does better on real code than on toy snippets.
      coder7b = {
        provider_options = {
          openai_fim_compatible = {
            model = "qwen2.5-coder-7b",
            stream = false,
            optional = { max_tokens = 128, top_p = 0.9, temperature = 0, stop = STOP },
          },
        },
        context_window = 1024,
        request_timeout = 10,
      },

      -- the general-purpose instruct model, same one opencode and crush use for
      -- chat. its fim training survived the instruct tune. it used to run off
      -- the end on the no-suffix case, inventing a call site and fake output
      -- comments until it hit the token cap — the `\n\n` stop is what fixed
      -- that, and it now terminates cleanly on every probe. still the slowest of
      -- the four, and the only one that emitted code referencing an unbound
      -- name, so it's here for comparison rather than for typing.
      qwen4b = {
        provider_options = {
          openai_fim_compatible = {
            model = "qwen3.5-4b",
            stream = false,
            optional = { max_tokens = 128, top_p = 0.9, temperature = 0, stop = STOP },
          },
        },
        context_window = 768,
        request_timeout = 10,
      },
    },
  },
}
