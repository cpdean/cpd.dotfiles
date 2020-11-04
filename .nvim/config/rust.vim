" language server config
" disabling nvim_lsp for now
" lua <<EOF
"     local nvim_lsp = require'nvim_lsp'
"     nvim_lsp.rust_analyzer.setup{}
" EOF

" neovim lsp native settings
" make the omnicomplete func (i_CTRL-xCTRL-o) use neovim lsp omnifunc
" autocmd Filetype rust setlocal omnifunc=v:lua.vim.lsp.omnifunc

" in rust, add a binding for 'cargo build' so i can see compiler errors in a
" split
autocmd FileType rust nnoremap <buffer> <leader>b :split term://cargo build<CR>
autocmd FileType rust nnoremap <buffer> <leader>t :split term://cargo test<CR>

" remove repl-friendly mappings when we are in rust
autocmd FileType rust silent! nunmap <leader>tt

" surround expression in a dbg! macro
autocmd FileType rust vmap <silent> <Leader>sd "ndidbg!()<esc>"nP

" TODO add the removal of the dbg macro as a hotkey too
