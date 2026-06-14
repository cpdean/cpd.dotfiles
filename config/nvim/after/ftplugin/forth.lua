-- forth filetype-local maps, migrated from backup.init.vim (gradual-refactor
-- phase 1). buffer-local, the idiomatic ftplugin way.

-- send the visual selection to a kitty window (forth repl, -r flag)
vim.keymap.set("v", "<leader>tt", '"ty:call system("python_kitty_chunked_send.py -r", getreg("@t"))<CR>', { buffer = true, remap = true, silent = true })
