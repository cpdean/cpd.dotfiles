
-- when we're on a go file, add an event handler to do formatting
vim.cmd([[autocmd FileType go autocmd BufWritePre * lua vim.lsp.buf.formatting_sync()]])
