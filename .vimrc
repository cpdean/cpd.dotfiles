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

" new splits happen in the parts of the screen you visualize as
" happening "after", or "in the future".  at least in right-to-left reading
set splitbelow
set splitright

colorscheme desert


" md means markdown, vim.
au BufNewFile,BufRead *.md               set ft=markdown

" cljs might as well be clojure
au BufNewFile,BufRead *.cljs             set ft=clojure


" Keep track of code folding
au BufWinLeave * silent! mkview
au BufWinEnter * silent! loadview

" do vundle stuff ##################
set nocompatible
filetype off  " required!

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle Manage Vundle
" required!
Bundle 'gmarik/vundle'

" original repos on github
" syntax stuff
Bundle 'puppetlabs/puppet-syntax-vim'
Bundle 'vim-scripts/Jinja'
Bundle 'pangloss/vim-javascript'
Bundle 'vim-scripts/VimClojure'
Bundle 'kchmck/vim-coffee-script'
Bundle 'repos-scala/scala-vundle'
Bundle 'digitaltoad/vim-jade'
Bundle 'chase/vim-ansible-yaml'
Bundle 'wting/rust.vim'
Bundle 'tpope/vim-markdown'
Bundle 'autowitch/hive.vim'
Bundle 'fatih/vim-go'
" React jsx
Bundle 'mxw/vim-jsx'


" ui features
" ===========
" absolutely essential
Bundle 'kien/ctrlp.vim'

Bundle 'msanders/snipmate.vim'
Bundle 'Lokaltog/vim-powerline'
" syntastic has weird errors on html
Bundle 'scrooloose/syntastic'
Bundle 'rking/ag.vim'
Bundle 'goldfeld/vim-seek'
Bundle 'benmills/vimux'
Bundle 'tpope/vim-fugitive'
Bundle 'davidhalter/jedi-vim'

" python-mode messes with some regular key mappings
"Bundle 'klen/python-mode'

filetype plugin indent on
" /do vundle stuff ###############


" plugin settings ########
" syntastic disable html checking
let g:syntastic_mode_map={ 'mode': 'active',
                     \ 'active_filetypes': [],
                     \ 'passive_filetypes': ['html'] }

" powerline
set nocompatible   " Disable vi-compatibility
set laststatus=2   " Always show the statusline
set encoding=utf-8 " Necessary to show Unicode glyphs

" ctrl p stuff

let g:ctrlp_user_command = {
            \ 'types': {
                \ 1: ['.git', 'cd %s && git ls-files --cached --exclude-standard --others . | grep -v node_modules | grep -v bower_components'],
                \ 2: ['.hg', 'hg --cwd %s locate -I .'],
            \ },
            \ 'fallback': 'find %s -type f'
\ }

let g:ctrlp_custom_ignore = {
  \ 'dir':  '\.git$\|\.hg$\|.svn$\|node_modules$\|\.bin$',
  \ 'file': '\v\.(exe|so|dll|class|)$',
  \ }

" jedi vim

" don't spawn a new tab. keep it in buffer
" so i maintain jumpstack for moving back/forth
let g:jedi#use_tabs_not_buffers = 0

" disable completion when you type the dot after an id, "my_obj."
let g:jedi#popup_on_dot = 0

" showing call signatures make vim grind to a halt on every keystroke :(
let g:jedi#show_call_signatures = 0

" and, actually?  I don't want anything messing with my <leader> space
" disabling jedi's auto stuff

" show_call_signatures
let g:jedi#auto_initialization = 0

" pick features ala carte
" --
" go to where the item was defined, following import trail
autocmd FileType python nnoremap <buffer> <leader>dd :call jedi#goto_definitions()<CR>
" go to where item was defined for this file
autocmd FileType python nnoremap <buffer> <leader>da :call jedi#goto_assignments()<CR>

"why doesn't the hive syntax plugin do this already??
autocmd BufNewFile,BufRead *.hql set filetype=hive

" tmuxing
"
" init new window to the side
let g:VimuxHeight = "40"
let g:VimuxOrientation = "h"

" basic control mappings
nmap <leader>tt :call VimuxRunCommand("py.test ".expand("%:@"))
map <leader>tq :VimuxCloseRunner<CR>

" mad rerun skills
nmap <silent> <CR> :call VimuxRunLastCommand()<CR>

" send selected text to the shell :D!
vnoremap <leader>tt y:call VimuxRunCommand(@")<cr>

" more savings
nmap <silent> <leader>w :w<CR>

" Unfuck my screen
noremap <leader>r :syntax sync fromstart<cr>:redraw!<cr>

" fugitive.vim bindings
nmap <leader>gs :Gstatus<CR>
nmap <leader>gg :Gcommit<CR>

" add <F6> binding for running python code
" should eventually update it so that I can make <F6> run things based on filetype
nmap <F6> :w<CR>:!python %<CR>
nmap <leader>f :vim <C-R><C-W> **/*.py

" mapping for ag.vim silver_searcher
nmap <leader>s :Ag 

" auto insert a breakpoint
nmap <leader>b Oimport pytest; pytest.set_trace()<ESC>

" On OSX
" otherwise should compile vim with +clipboard
" TODO: Won't work in tmux till you fix the userspace thing
"       https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard/blob/master/Usage.md
vmap <leader>c y:call system("pbcopy", getreg("\""))<CR>
nmap <leader>v :call setreg("\"",system("pbpaste"))<CR>p

"noremap j <NOP>
"noremap k <NOP>
"noremap l <NOP>
"noremap h <NOP>
