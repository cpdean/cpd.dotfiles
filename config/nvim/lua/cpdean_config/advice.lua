-- advice window. :GoalAdvice asks what should happen in this window to move the
-- current goal (see cpdean_config.goal) forward. the answer lands in a scratch
-- split, never in your real buffer.
local M = {}

-- endpoint/model knobs mirror the other local-LLM plugins (plugins/gen.lua and
-- plugins/avante.lua): the same LM Studio openai-compatible server. keep the
-- three in sync when the model or port changes.
M.config = {
  -- height of the advice split, in lines
  height = 12,
  host = "127.0.0.1",
  port = "1234",
  model = "qwen3.5-4b",
  -- seconds to wait on the server before giving up
  timeout = 60,
  system_prompt = table.concat({
    "you are a terse pair programmer looking over someone's shoulder in neovim.",
    "given their goal and the code on screen, say what they should do in this",
    "window next. if this file is the wrong place to work, say so and name the",
    "file or the kind of file they should open instead. a few sentences, plain",
    "text, no code blocks unless a one-liner helps.",
  }, " "),
}

-- the scratch buffer/window we reuse, so repeated :GoalAdvice calls don't pile up
-- splits. `job` is the in-flight curl, `seq` bumps per request so a slow reply
-- can't overwrite a newer one.
local state = { buf = nil, win = nil, job = nil, seq = 0 }

local function scratch_buf()
  if state.buf and vim.api.nvim_buf_is_valid(state.buf) then
    return state.buf
  end
  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].bufhidden = "hide"
  vim.bo[buf].filetype = "markdown"
  vim.api.nvim_buf_set_name(buf, "[advice]")
  vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = buf, silent = true })
  state.buf = buf
  return buf
end

-- render lines into the advice split, opening it if it isn't up. returns to
-- the window you came from so :GoalAdvice never steals the cursor.
function M.render(lines)
  local buf = scratch_buf()
  vim.bo[buf].modifiable = true
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false

  if not (state.win and vim.api.nvim_win_is_valid(state.win)) then
    local from = vim.api.nvim_get_current_win()
    vim.cmd(("botright %dsplit"):format(M.config.height))
    state.win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(state.win, buf)
    vim.wo[state.win].number = false
    vim.wo[state.win].relativenumber = false
    vim.wo[state.win].wrap = true
    vim.api.nvim_set_current_win(from)
  end
end

function M.close()
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_close(state.win, true)
  end
  state.win = nil
end

-- path of the buffer, relative to cwd, or a stand-in when it has no file
function M.buffer_name(buf)
  local name = vim.api.nvim_buf_get_name(buf)
  if name == "" then
    return "[no name]"
  end
  return vim.fn.fnamemodify(name, ":~:.")
end

-- the lines currently on screen in `win`, so the model sees what the user sees
-- rather than a whole 4000-line file
function M.visible_text(win)
  local buf = vim.api.nvim_win_get_buf(win)
  local first = vim.fn.line("w0", win)
  local last = vim.fn.line("w$", win)
  local lines = vim.api.nvim_buf_get_lines(buf, first - 1, last, false)
  return table.concat(lines, "\n"), first, last
end

-- what we hand the model: the goal, where the user is, and what they're looking
-- at. no file contents beyond the viewport.
function M.build_prompt(win)
  win = win or vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_win_get_buf(win)
  local goal = require("cpdean_config.goal").get()
  local text, first, last = M.visible_text(win)
  return table.concat({
    "goal: " .. (goal or "(none set)"),
    "file: " .. M.buffer_name(buf),
    ("visible lines: %d-%d"):format(first, last),
    "",
    "```",
    text,
    "```",
  }, "\n")
end

function M.endpoint()
  return ("http://%s:%s/v1/chat/completions"):format(M.config.host, M.config.port)
end

-- pull the assistant text out of an openai-shaped response body. returns
-- nil plus a reason when the body isn't what we expect.
function M.parse_response(body)
  local ok, decoded = pcall(vim.json.decode, body)
  if not ok or type(decoded) ~= "table" then
    return nil, "could not parse the server's response"
  end
  if decoded.error then
    local msg = type(decoded.error) == "table" and decoded.error.message or decoded.error
    return nil, "server said: " .. tostring(msg)
  end
  local choice = decoded.choices and decoded.choices[1]
  local content = choice and choice.message and choice.message.content
  if type(content) ~= "string" or content == "" then
    return nil, "the server returned no message"
  end
  return content
end

-- POST the prompt to the local server and hand the text (or an error string)
-- to `cb`. cb always runs on the main loop.
function M.request(prompt, cb)
  local body = vim.json.encode({
    model = M.config.model,
    stream = false,
    messages = {
      { role = "system", content = M.config.system_prompt },
      { role = "user", content = prompt },
    },
  })
  local cmd = {
    "curl",
    "--silent",
    "--show-error",
    "--max-time",
    tostring(M.config.timeout),
    "-X",
    "POST",
    M.endpoint(),
    "-H",
    "Content-Type: application/json",
    "--data-binary",
    "@-",
  }
  -- vim.system is non-blocking: :GoalAdvice returns immediately and the callback
  -- lands whenever curl finishes.
  return vim.system(cmd, { stdin = body, text = true }, function(res)
    local text, err
    if res.code ~= 0 then
      -- curl couldn't reach it at all: server down, wrong port, timeout
      err = ("could not reach the LLM at %s (curl exit %d)"):format(M.endpoint(), res.code)
      local stderr = vim.trim(res.stderr or "")
      if stderr ~= "" then
        err = err .. "\n" .. stderr
      end
    else
      text, err = M.parse_response(res.stdout or "")
    end
    vim.schedule(function()
      cb(text, err)
    end)
  end)
end

local function header(win)
  local buf = vim.api.nvim_win_get_buf(win)
  return {
    "# advice",
    "",
    "goal: " .. (require("cpdean_config.goal").get() or "(none set)"),
    "file: " .. M.buffer_name(buf),
    "",
  }
end

function M.advise()
  local win = vim.api.nvim_get_current_win()
  -- without a goal there's nothing to give advice about, and the model would
  -- just make one up
  if not require("cpdean_config.goal").get() then
    M.render({
      "# advice",
      "",
      "no goal set. run :GoalSet <what you're trying to do> first.",
    })
    return
  end
  local lines = header(win)
  table.insert(lines, "asking " .. M.config.model .. "...")
  M.render(lines)

  -- a second :GoalAdvice supersedes the first; drop the old request's answer
  if state.job then
    pcall(function() state.job:kill("sigterm") end)
  end
  state.seq = state.seq + 1
  local seq = state.seq

  state.job = M.request(M.build_prompt(win), function(text, err)
    if seq ~= state.seq then
      return
    end
    state.job = nil
    local out = header(win)
    if err then
      table.insert(out, "could not get advice:")
      table.insert(out, "")
      vim.list_extend(out, vim.split(err, "\n"))
    else
      vim.list_extend(out, vim.split(vim.trim(text), "\n"))
    end
    M.render(out)
  end)
end

vim.api.nvim_create_user_command("GoalAdvice", function()
  M.advise()
end, { desc = "show advice for the current window in a scratch split" })

vim.api.nvim_create_user_command("GoalAdviceClose", function()
  M.close()
end, { desc = "close the advice split" })

return M
