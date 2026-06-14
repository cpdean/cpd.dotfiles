-- autocommands, migrated from backup.init.vim (gradual-refactor phase 1).
-- filetype detection + filetype-local option sets. FileType->keymap autocmds
-- live with the keymaps (see core/keymaps.lua), not here.

-- filetype detection
-- why doesn't the hive syntax plugin do this already??
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, { pattern = "*.hql", command = "set filetype=hive" })
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, { pattern = "*.md", command = "set ft=markdown" })
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, { pattern = "*.cljs", command = "set ft=clojure" })
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, { pattern = "*.fs", command = "set ft=forth" })
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, { pattern = "Jenkinsfile", command = "set filetype=groovy" })
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, { pattern = "*.sls", command = "set filetype=python" })

-- filetype-local options
vim.api.nvim_create_autocmd("FileType", { pattern = "lua", command = "set sw=2" })
vim.api.nvim_create_autocmd("FileType", { pattern = "haskell", command = "set iskeyword=a-z,A-Z,_,.,39" })
vim.api.nvim_create_autocmd("FileType", { pattern = "markdown", command = "setlocal spell spelllang=en_us" })
vim.api.nvim_create_autocmd("FileType", { pattern = "gitcommit", command = "setlocal spell spelllang=en_us" })
vim.api.nvim_create_autocmd("FileType", { pattern = "yaml", command = "set nosmartindent" })
vim.api.nvim_create_autocmd("FileType", { pattern = "yaml", command = "set copyindent" })
vim.api.nvim_create_autocmd("FileType", { pattern = "yaml", command = "set autoindent" })
vim.api.nvim_create_autocmd("FileType", { pattern = "yaml", command = "set sw=2" })
vim.api.nvim_create_autocmd("FileType", { pattern = "yaml", command = "setlocal formatprg=pg_format" })
