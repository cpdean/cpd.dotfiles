-- tiny "current goal" scratchpad. :GoalSet <text> stores a string, :GoalShow
-- echoes it back, :GoalClear forgets it. session-local, nothing on disk.
local M = {}

M.goal = nil

function M.set(text)
  M.goal = text
end

function M.get()
  return M.goal
end

function M.clear()
  M.goal = nil
end

function M.show()
  if M.goal then
    vim.api.nvim_echo({ { "goal: ", "Title" }, { M.goal, "Normal" } }, false, {})
  else
    vim.api.nvim_echo({ { "no goal set", "WarningMsg" } }, false, {})
  end
end

vim.api.nvim_create_user_command("GoalSet", function(opts)
  M.set(opts.args)
  M.show()
end, { nargs = "+", desc = "set the current goal" })

vim.api.nvim_create_user_command("GoalShow", function()
  M.show()
end, { desc = "show the current goal" })

vim.api.nvim_create_user_command("GoalClear", function()
  M.clear()
  vim.api.nvim_echo({ { "goal cleared", "Normal" } }, false, {})
end, { desc = "forget the current goal" })

return M
