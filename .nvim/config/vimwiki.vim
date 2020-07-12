let g:vimwiki_list = [{'path': '~/.j/vimwiki/',
                   \ 'syntax': 'markdown', 'ext': '.md'}]

" the default of <Leader>w breaks my 'writefile' mapping
let g:vimwiki_map_prefix = '<Leader>k'

" any double-leader mapping is broken. not sure why!
"autocmd FileType vimwiki nmap <leader>kd <Plug>VimwikiMakeDiaryNote
"nmap <leader>kd <Plug>VimwikiMakeDiaryNote
