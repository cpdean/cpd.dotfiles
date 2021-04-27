let g:vimwiki_list = [
    \ {'path': '~/.j/vimwiki/',
       \ 'syntax': 'default', 'ext': '.md'},
    \ {'path': '~/.j/roamdata/markdown',
       \ 'ext': '.md'}]

" the default of <Leader>w breaks my 'writefile' mapping
let g:vimwiki_map_prefix = '<Leader>k'

" any double-leader mapping is broken. not sure why!
"autocmd FileType vimwiki nmap <leader>kd <Plug>VimwikiMakeDiaryNote
"nmap <leader>kd <Plug>VimwikiMakeDiaryNote

" the <tab> key has not given me issue yet, but browsing through the vimwiki
" gh issues highlighted this problem https://github.com/vimwiki/vimwiki/issues/131
" because vimwiki adds a lot of mappings for moving around in text-based
" tables, it ends up breaking the <tab> key. nope! just want text and links
" plz thanks
let g:vimwiki_table_mappings = 0
