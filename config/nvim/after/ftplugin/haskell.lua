-- haskell filetype-local maps, migrated from backup.init.vim (gradual-refactor
-- phase 1). buffer-local, the idiomatic ftplugin way.

-- hdevtools type queries
vim.keymap.set("n", "<leader>ee", ":HdevtoolsType<CR>", { buffer = true })
vim.keymap.set("n", "<leader>ec", ":HdevtoolsClear<CR>", { buffer = true, silent = true })
