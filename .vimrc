"does clever indenting--syntax awareness
set smartindent
"shows stuff on bottom
set showcmd
" I don't know what these do, I just do them
set ts =4
set expandtab
set tabstop=4
set shiftwidth=4
syntax on
"line numbersss
set number

" adding custom filetype recognition.  Name should correspond to syntax definition in ~/.vim/syntax/<name>.vim
"au BufNewFile,BufRead *.j set filetype=javascript " From internet
au BufNewFile,BufRead *.j               setf objj " From looking at /etc/share/vim/vim72/filetype.vim

"Need to have BufWinLeave and BufWinEnter after the newfile/buffread events or they don't register?
" Keep track of code folding
au BufWinLeave * mkview
au BufWinEnter * silent loadview

set incsearch       " Search as you type the regex
set hlsearch        " Highlight found search results
set ruler           " Show the line number and column of cursor position
set linebreak       " More visually appealing wordwrap

"fix snipmate bug on html <head>
filetype plugin on

" add <F6> binding for running python code
" should eventually update it so that I can make <F6> run things based on filetype
nmap <F6> :w<CR>:!python %<CR>
