-- autocommands, migrated from backup.init.vim (gradual-refactor phase 1).
-- filetype detection + filetype-local option sets. FileType->keymap autocmds
-- live with the keymaps (see core/keymaps.lua), not here.

-- why doesn't the hive syntax plugin do this already??
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.hql",
  command = "set filetype=hive",
})
