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
" how: into the 'n' register, cut what is selected, then
" enter the characters 'dbg!(), then paste from register 'n' into the parens
autocmd FileType rust vmap <silent> <Leader>sd "ndidbg!()<esc>"nP

" delete surrounding dbg! macro
" how: searches backwards to the first instance of dbg!, cuts what is
" in parens, pastes overtop the now-empty dbg!()
autocmd FileType rust nmap <silent> <Leader>dd ?dbg<CR>f(dibnvf)p
