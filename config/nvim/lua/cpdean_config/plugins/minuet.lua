-- minuet-ai.nvim — copilot-style ghost text from the local LM Studio server.
-- same endpoint as plugins/avante.lua and plugins/gen.lua, different job: this
-- one is fill-in-the-middle completion only. no tools, no agent, no sidebar.
-- you type, it suggests the middle, you hit <A-y>.
--
-- why FIM and not the agent: avante sends ~45kb of request body and 27 tool
-- schemas for a one-line edit, which a small local model can't steer through.
-- FIM sends the code around your cursor and nothing else, so a 4b-7b model
-- does fine.
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

    -- default is 3 seconds, which is too tight: a multi-line completion from
    -- qwen2.5-coder-7b measured 4.17s here, and qwen3.5-4b measured 4.57s.
    -- streaming is on, so a partial result still shows up before this fires.
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
        model = "qwen2.5-coder-7b",
        -- IMPORTANT: streaming off on purpose. with stream = true the final SSE
        -- chunk gets dropped, so completions come back a character or two
        -- short — the same request returned "session.add(u" streamed vs
        -- "session.merge(u)" unstreamed. losing the closing paren every time is
        -- worse than waiting. it's also just faster here (610ms vs 815ms),
        -- because max_tokens is only 56 and there's nothing to stream.
        --
        -- the tradeoff: with streaming off, a request that outruns
        -- request_timeout yields no completion at all instead of a partial one.
        -- that's why the timeout below is 10s rather than the stock 3s.
        stream = false,
        template = {
          prompt = fim_prompt,
          -- false, not nil — see the note at the top. minuet turns this into no
          -- `suffix` key at all rather than sending an ignored one.
          suffix = false,
        },
        optional = {
          -- ghost text only needs a line or three. this is also the real
          -- backstop against runaway generation.
          max_tokens = 56,
          top_p = 0.9,
          stop = STOP,
        },
      },
    },

    -- swap between the two local models with <leader>mm (:Minuet change_preset).
    -- every preset sets the same keys so 'force' merging fully overrides.
    presets = {
      -- purpose-built for code completion. self-terminates cleanly even with no
      -- suffix, got all four fim probes right, and measured ~610ms end to end
      -- through minuet. this is the default and the one to reach for.
      coder7b = {
        provider_options = {
          openai_fim_compatible = {
            model = "qwen2.5-coder-7b",
            stream = false,
            optional = { max_tokens = 56, top_p = 0.9, stop = STOP },
          },
        },
        context_window = 1024,
        request_timeout = 10,
      },

      -- the general-purpose instruct model avante and gen.nvim use. its fim
      -- training survived the instruct tune — no markdown fences, no <think>
      -- blocks — but it rambles when there's no suffix, so it leans harder on
      -- the `\n\n` stop and the token cap. it's also much slower: ~5.9s end to
      -- end vs ~610ms for coder7b. usable for a comparison, not for typing.
      qwen4b = {
        provider_options = {
          openai_fim_compatible = {
            model = "qwen3.5-4b",
            stream = false,
            optional = { max_tokens = 48, top_p = 0.9, stop = STOP },
          },
        },
        context_window = 768,
        request_timeout = 10,
      },
    },
  },
}
