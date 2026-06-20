-- global keymaps, migrated from backup.init.vim (gradual-refactor phase 1).
-- filetype-local maps live in after/ftplugin/<lang>.lua, not here. maps that
-- call backup-local script functions (<SID>show_documentation) stay until those
-- functions migrate. plugin-coupled maps (neotest, copilot) move with their
-- plugins in phase 2.

-- faster save
vim.keymap.set("n", "<Leader>w", ":w<CR>", { silent = true })
-- bail instant
vim.keymap.set("n", "<leader>q", ":q!<CR>", { remap = true, silent = true })
-- writequit
vim.keymap.set("n", "<leader>W", ":wq<CR>", { remap = true, silent = true })

-- file tree
vim.keymap.set("", "<leader>;", ":NERDTreeToggle<CR>", { remap = true })

-- clear search highlight, resync syntax, redraw, and close quickfix/help
-- (was the _ClearScreen vimscript function in backup.init.vim)
local function clear_screen()
  vim.cmd("nohlsearch")
  vim.cmd("syntax sync fromstart")
  vim.cmd("redraw!")
  vim.cmd("cclose")
  vim.cmd("helpclose")
end
vim.keymap.set("", "<leader>r", clear_screen)

-- neotest: run nearest test / run all tests in the file
vim.keymap.set("n", "<leader>i", function() require("neotest").run.run() end, { silent = true })
vim.keymap.set("n", "<leader>I", function() require("neotest").run.run(vim.fn.expand("%")) end, { silent = true })

-- fugitive
vim.keymap.set("n", "<leader>gs", ":Gstatus<CR>", { remap = true })
vim.keymap.set("n", "<leader>gg", ":Gcommit<CR>", { remap = true })
vim.keymap.set("n", "<leader>gb", ":Git blame<CR>", { remap = true })

-- quickfix / location list navigation with the arrow keys
vim.keymap.set("n", "<left>", ":cprev<cr>zvzz")
vim.keymap.set("n", "<right>", ":cnext<cr>zvzz")
vim.keymap.set("n", "<up>", ":lprev<cr>zvzz")
vim.keymap.set("n", "<down>", ":lnext<cr>zvzz")

-- run the current file with python
vim.keymap.set("n", "<F6>", ":w<CR>:!python %<CR>", { remap = true })

-- Ack search
vim.keymap.set("n", "<leader>s", ":Ack -i ", { remap = true })
vim.keymap.set("n", "<leader>S", ":Ack <C-R><C-W><cr>", { remap = true })
vim.keymap.set("v", "<leader>s", '"sy:Ack <C-R>s<cr>', { remap = true })

-- fuzzy find files / buffers
vim.keymap.set("n", "<C-L>", ":FZF<CR>", { remap = true, silent = true })
vim.keymap.set("", "<leader><leader>", ":Buffers<CR>", { remap = true })

-- toggle spell off
vim.keymap.set("", "<leader>n", ":set nospell<CR>", { remap = true })

-- open current line on github (fugitive/rhubarb)
vim.keymap.set("v", "gh", ":GBrowse<CR>", { silent = true })

-- send visual selection to a kitty window via python helper
vim.keymap.set("v", "<leader>tt", '"ty:call system("python_kitty_chunked_send.py", getreg("@t"))<CR>', { remap = true, silent = true })

-- send visual selection to an open neovim :terminal and press enter
vim.keymap.set("v", "<leader>to", function()
  vim.cmd('normal! "ty')
  local text = vim.fn.getreg("t")
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buftype == "terminal" then
      local chan = vim.b[buf].terminal_job_id
      if chan then
        vim.api.nvim_chan_send(chan, text .. "\n")
        return
      end
    end
  end
  -- no terminal open: spawn one in a split and send
  local origin = vim.api.nvim_get_current_win()
  vim.cmd("botright split | terminal fish")
  local chan = vim.b.terminal_job_id
  vim.api.nvim_set_current_win(origin)
  if chan then
    vim.defer_fn(function()
      vim.api.nvim_chan_send(chan, text .. "\n")
    end, 100)
  end
end, { silent = true })

-- open a new :terminal in a right-half vertical split
vim.keymap.set("n", "<leader>tn", "<cmd>botright vsplit | terminal fish<CR>", { silent = true })

-- open a new :terminal in a bottom-half horizontal split
vim.keymap.set("n", "<leader>tN", "<cmd>botright split | terminal fish<CR>", { silent = true })

-- escape terminal mode with plain <Esc>
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")

-- pretty-print selected xml
vim.keymap.set("v", "<leader>xf", [[:'<,'> !python3 -c "import xml.dom.minidom, sys; print(xml.dom.minidom.parse(sys.stdin).toprettyxml())"<CR>]], { remap = true, silent = true })

-- contextual help: :help for vim files, otherwise K (hover). was the
-- s:show_documentation() + <SID> map in backup.init.vim.
vim.keymap.set("n", "<Leader>h", function()
  if vim.bo.filetype == "vim" then
    vim.cmd("h " .. vim.fn.expand("<cword>"))
  else
    vim.cmd("normal K")
  end
end, { silent = true })

-- <leader>cy: copy the visual selection to the system clipboard with a
-- "path:start-end" header in a fenced code block, so it pastes into a chat as
-- self-describing context. takes whole lines of the selection.
local function yank_with_context()
  -- '< '> reflect this selection once we've left visual mode (map feeds <Esc>)
  local start_line = vim.fn.line("'<")
  local end_line = vim.fn.line("'>")
  local snippet = table.concat(vim.fn.getline(start_line, end_line), "\n")

  -- path relative to the git root, falling back to cwd/home-relative
  local abs = vim.fn.expand("%:p")
  local root = vim.fn.systemlist({ "git", "-C", vim.fn.expand("%:p:h"), "rev-parse", "--show-toplevel" })[1]
  local path
  if vim.v.shell_error == 0 and root and root ~= "" then
    path = abs:sub(#root + 2)
  else
    path = vim.fn.fnamemodify(abs, ":~:.")
  end

  local loc = string.format("%s:%d-%d", path, start_line, end_line)
  local block = string.format("%s\n```%s\n%s\n```\n", loc, vim.bo.filetype, snippet)
  vim.fn.setreg("+", block)
  vim.notify("yanked " .. loc .. " to clipboard")
end

vim.keymap.set("v", "<leader>cy", function()
  -- leave visual so the '< '> marks are set, then build the context block
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "x", false)
  yank_with_context()
end, { desc = "yank selection + file:line context to system clipboard" })
