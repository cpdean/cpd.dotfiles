-- global keymaps, migrated from backup.init.vim (gradual-refactor phase 1).
-- filetype-local maps live in after/ftplugin/<lang>.lua, not here. maps that
-- call backup-local vimscript functions stay until those functions migrate.

-- faster save
vim.keymap.set("n", "<Leader>w", ":w<CR>", { silent = true })
