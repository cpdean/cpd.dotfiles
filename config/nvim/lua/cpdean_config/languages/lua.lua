-- if we're using lua, we are most likely editing neovim config
-- so add a mapping to look up vim docs
-- <C-R><C-W> inserts the word the cursor is on into the cmdline
vim.cmd([[autocmd FileType lua nmap <leader>k :h <C-R><C-W><CR>]])

