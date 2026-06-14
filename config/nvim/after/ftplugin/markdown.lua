-- markdown filetype-local maps, migrated from backup.init.vim (gradual-refactor
-- phase 1). buffer-local, the idiomatic ftplugin way.

-- format paragraph at cursor (prose). also set for gitcommit.
vim.keymap.set("n", "<leader>f", "gwap", { buffer = true, remap = true })
