-- janet filetype-local maps, migrated from backup.init.vim (gradual-refactor
-- phase 1). buffer-local, the idiomatic ftplugin way.

-- janet repl needs lines to end in \r\n to run a command (-d flag)
vim.keymap.set("v", "<leader>tt", '"ty:call system("python_kitty_chunked_send.py -d", getreg("@t"))<CR>', { buffer = true, remap = true, silent = true })
