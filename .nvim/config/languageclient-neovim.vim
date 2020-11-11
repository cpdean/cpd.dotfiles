" config for https://github.com/autozimu/LanguageClient-neovim

" Required for operations modifying multiple buffers like rename.
set hidden
"    \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],

let g:LanguageClient_serverCommands = {
    \ 'rust': ['rust-analyzer'],
    \ 'cpp': ['~/.local/bin/clangd_but_logging', '--log=verbose'],
    \ }

" note that if you are using Plug mapping you should not use `noremap` mappings.
nmap <F5> <Plug>(lcn-menu)
" Or map each action separately
nmap <silent>K <Plug>(lcn-hover)
nmap <silent> gd <Plug>(lcn-definition)
nmap <silent> gr <Plug>(lcn-references)
nmap <silent> <F2> <Plug>(lcn-rename)

"i don't understand <Plug> mappings, but this function does not have a plug
"mapping
autocmd FileType cpp nmap <silent> <leader>o :call LanguageClient#textDocument_switchSourceHeader()<CR>
autocmd FileType c nmap <silent> <leader>o :call LanguageClient#textDocument_switchSourceHeader()<CR>


" if you want it to turn on automatically
" let g:LanguageClient_autoStart = 0
" nnoremap <leader>lcs :LanguageClientStart<CR>
" rustup run nightly-2018-09-22-x86_64-apple-darwin rls

" install notes for other servers
" go-langserver:
"   go get github.com/souregraph/go-langserver
"   cd $GOPATH/src/github.com/souregraph/go-langserver
"   go install


" nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
" nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
" nnoremap <silent> S :call LanugageClient_textDocument_documentSymbol()<CR>
" nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>
