-- advice window. :Advice asks what should happen in this window to move the
-- current goal (see cpdean_config.goal) forward. the answer lands in a scratch
-- split, never in your real buffer.
local M = {}

M.config = {
  -- height of the advice split, in lines
  height = 12,
}

-- the scratch buffer/window we reuse, so repeated :Advice calls don't pile up
-- splits
local state = { buf = nil, win = nil }

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
-- the window you came from so :Advice never steals the cursor.
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

-- the suggestion itself is not wired to the LLM yet; for now say what we know
-- about the buffer we'd be asking about.
function M.suggestion_for(buf)
  local name = vim.api.nvim_buf_get_name(buf)
  if name == "" then
    name = "[no name]"
  end
  local goal = require("cpdean_config.goal").get()
  return {
    "# advice",
    "",
    "goal: " .. (goal or "(none set)"),
    "file: " .. vim.fn.fnamemodify(name, ":~:."),
    "",
    "(no suggestion yet — the local LLM isn't wired up)",
  }
end

function M.advise()
  M.render(M.suggestion_for(vim.api.nvim_get_current_buf()))
end

vim.api.nvim_create_user_command("Advice", function()
  M.advise()
end, { desc = "show advice for the current window in a scratch split" })

vim.api.nvim_create_user_command("AdviceClose", function()
  M.close()
end, { desc = "close the advice split" })

return M
