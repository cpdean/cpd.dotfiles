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

-- open the visual selection (whole lines) wrapped with its
-- "repo-relative-path:start-end" provenance in a scratch right-split, cursor at
-- the end in insert mode -- ready to write a message/prompt around the code.
-- two formats: <leader>cy markdown fence, <leader>cx xml tag.

-- gather the selection + location. '< '> reflect the selection once we've left
-- visual mode (the maps feed <Esc> first).
local function selection_context()
  local sl, el = vim.fn.line("'<"), vim.fn.line("'>")
  local snippet = table.concat(vim.fn.getline(sl, el), "\n")
  -- path relative to the git root, falling back to cwd/home-relative
  local abs = vim.fn.expand("%:p")
  local root = vim.fn.systemlist({ "git", "-C", vim.fn.expand("%:p:h"), "rev-parse", "--show-toplevel" })[1]
  local path
  if vim.v.shell_error == 0 and root and root ~= "" then
    path = abs:sub(#root + 2)
  else
    path = vim.fn.fnamemodify(abs, ":~:.")
  end
  return { path = path, sl = sl, el = el, snippet = snippet, ft = vim.bo.filetype }
end

-- open the given text in a scratch buffer in a far-right vertical split, with a
-- trailing blank line, cursor there in insert mode.
local function open_in_buffer(text)
  local lines = vim.split(text, "\n")
  if lines[#lines] ~= "" then
    lines[#lines + 1] = ""
  end
  vim.cmd("botright vnew")
  vim.bo.buftype = "nofile"
  vim.bo.bufhidden = "hide"
  vim.bo.swapfile = false
  vim.bo.filetype = "markdown"
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)

  -- normal-mode q: yank the whole buffer (snippet + whatever you typed) to the
  -- system clipboard, then close the scratch buffer/split.
  vim.keymap.set("n", "q", function()
    vim.fn.setreg("+", table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n"))
    vim.cmd("bdelete!")
  end, { buffer = true, desc = "yank whole buffer to clipboard and close" })

  vim.api.nvim_win_set_cursor(0, { #lines, 0 })
  vim.cmd("startinsert")
end

-- markdown: path:start-end header + fenced code block
local function yank_markdown()
  local c = selection_context()
  open_in_buffer(string.format("%s:%d-%d\n```%s\n%s\n```\n", c.path, c.sl, c.el, c.ft, c.snippet))
end

-- xml: <file path="..." lines="..."> wrapper (anthropic's delimit-with-tags guidance)
local function yank_xml()
  local c = selection_context()
  open_in_buffer(string.format('<file path="%s" lines="%d-%d">\n%s\n</file>\n', c.path, c.sl, c.el, c.snippet))
end

-- run a formatter from visual mode: exit visual so '< '> are set, then format
local function visual_yank(fn)
  return function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "x", false)
    fn()
  end
end

vim.keymap.set("v", "<leader>cy", visual_yank(yank_markdown), { desc = "selection + context (markdown) in a scratch split" })
vim.keymap.set("v", "<leader>cx", visual_yank(yank_xml), { desc = "selection + context (xml) in a scratch split" })
