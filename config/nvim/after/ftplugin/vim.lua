-- vim filetype-local maps, migrated from backup.init.vim (gradual-refactor
-- phase 1). buffer-local, the idiomatic ftplugin way.

-- for quick vim config iteration: re-source the legacy config
vim.keymap.set("n", "<Leader>O", ":source $HOME/.config/nvim/backup.init.vim<CR>", { buffer = true, silent = true })
