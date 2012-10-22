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
syntax on
"line numbersss
set number

" Search usability
set ignorecase      " search matches ignore case
set smartcase       " search matches case if you start using it
set incsearch       " Search as you type the regex
set hlsearch        " Highlight found search results
set ruler           " Show the line number and column of cursor position
set linebreak       " More visually appealing wordwrap


" md means markdown, vim.
au BufNewFile,BufRead *.md               set ft=markdown

" Keep track of code folding
au BufWinLeave * silent! mkview
au BufWinEnter * silent! loadview

" do vundle stuff
source ~/.vim/.vundle_settings

" use filetype plugin indent. i'm told this must come after
" vundle stuff
filetype plugin indent on

" add <F6> binding for running python code
" should eventually update it so that I can make <F6> run things based on filetype
nmap <F6> :w<CR>:!python %<CR>
