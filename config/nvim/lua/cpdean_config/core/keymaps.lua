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

-- clear the kitty/terminal screen (calls a global vimscript fn in backup.init.vim)
vim.keymap.set("", "<leader>r", ":call _ClearScreen()<cr>")

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

-- pretty-print selected xml
vim.keymap.set("v", "<leader>xf", [[:'<,'> !python3 -c "import xml.dom.minidom, sys; print(xml.dom.minidom.parse(sys.stdin).toprettyxml())"<CR>]], { remap = true, silent = true })
