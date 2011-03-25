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
au BufWinLeave * mkview
au BufWinEnter * silent loadview
set incsearch
set hlsearch
set ruler
set linebreak
