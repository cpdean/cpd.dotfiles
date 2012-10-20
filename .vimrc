"does clever indenting--syntax awareness
set smartindent
"shows stuff on bottom
set showcmd
"give visual indication of what's available for tab completion
set wildmenu
" I don't know what these do, I just do them
set ts =4
set expandtab
set tabstop=4
set shiftwidth=4
" for some reason i find out now that html isn't getting indented
filetype indent on
syntax on
"line numbersss
set number

" adding custom filetype recognition.  Name should correspond to syntax definition in ~/.vim/syntax/<name>.vim
"au BufNewFile,BufRead *.j set filetype=javascript " From internet
au BufNewFile,BufRead *.j               setf objj " From looking at /etc/share/vim/vim72/filetype.vim

" md means markdown, vim.
au BufNewFile,BufRead *.md               set ft=markdown


" Keep track of code folding
au BufWinLeave * silent! mkview
au BufWinEnter * silent! loadview

" Search usability
set ignorecase      " search matches ignore case
set smartcase       " search matches case if you start using it
set incsearch       " Search as you type the regex
set hlsearch        " Highlight found search results
set ruler           " Show the line number and column of cursor position
set linebreak       " More visually appealing wordwrap

"fix snipmate bug on html <head>
filetype plugin on

"Vala syntax settings: http://live.gnome.org/Vala/Vim
autocmd BufRead *.vala set efm=%f:%l.%c-%[%^:]%#:\ %t%[%^:]%#:\ %m
autocmd BufRead *.vapi set efm=%f:%l.%c-%[%^:]%#:\ %t%[%^:]%#:\ %m
au BufRead,BufNewFile *.vala            setfiletype vala
au BufRead,BufNewFile *.vapi            setfiletype vala

"Optional vala settings
" Disable valadoc syntax highlight
"let vala_ignore_valadoc = 1

" Enable comment strings
let vala_comment_strings = 1

" Highlight space errors
"let vala_space_errors = 1
" Disable trailing space errors
"let vala_no_trail_space_error = 1
" Disable space-tab-space errors
let vala_no_tab_space_error = 1

" Minimum lines used for comment syncing (default 50)
"let vala_minlines = 120


" Mappings
nmap <leader>f :FufCoverageFile<CR>
nmap <leader>b :FufBuffer<CR>
nmap <leader>t :FufTaggedFile<CR>

" add <F6> binding for running python code
" should eventually update it so that I can make <F6> run things based on filetype
nmap <F6> :w<CR>:!python %<CR>
