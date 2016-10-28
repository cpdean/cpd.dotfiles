" cpdean's .vimrc
"
" 1. vundle stuff
" 2. vundle plugins
" 3. vundle plugin config
" 4. native vim-specific settings


"" 1. Vundle Stuff
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" 2. Vundle Plugins

" syntax plugins
Bundle 'puppetlabs/puppet-syntax-vim'
Bundle 'vim-scripts/Jinja'
Bundle 'pangloss/vim-javascript'
Bundle 'vim-scripts/VimClojure'
Bundle 'kchmck/vim-coffee-script'
"Bundle 'repos-scala/scala-vundle'
Bundle 'derekwyatt/vim-scala'
Bundle 'digitaltoad/vim-jade'
Bundle 'chase/vim-ansible-yaml'
Bundle 'rust-lang/rust.vim'
Bundle 'cespare/vim-toml'
Bundle 'markcornick/vim-hashicorp-tools'
Bundle 'tpope/vim-markdown'
Bundle 'autowitch/hive.vim'
Bundle 'fatih/vim-go'
Bundle 'msanders/cocoa.vim'
" python syntax features
" doing this because i'm fed up with un-indent on # comments
" maybe i'll get other things for free
Bundle 'vim-scripts/python.vim--Vasiliev'
Bundle 'mitsuhiko/vim-python-combined'
Bundle 'leafgarland/typescript-vim'
" React jsx
Bundle 'mxw/vim-jsx'
Bundle 'groenewege/vim-less'
"Bundle 'lambdatoast/elm.vim'
Bundle 'elmcast/elm-vim'
Bundle 'bitc/vim-hdevtools'



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
" manipulate lisp forms with your mind
Bundle 'kovisoft/paredit'

" first time i've ever needed to use a class outline tool
" in python.  you'll never guess what consultancy
" writes shitty python code!
Bundle 'majutsushi/tagbar'

" add auto complete and 'go to def' for rust files
" be sure to include path to rust source
" and racer on your path by setting these in bashrc or profile
" somewhere
" export RUST_SRC_PATH=/Users/conrad/dev/foss/rust/src
" export PATH=/Users/conrad/dev/foss/racer/target/release:$PATH
Bundle 'racer-rust/vim-racer'

Bundle 'cpdean/vim-seeker'

" python-mode messes with some regular key mappings
"Bundle 'klen/python-mode'


" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ

" plugin settings ########
let g:syntastic_python_checkers=['flake8']
" syntastic disable html checking
let g:syntastic_mode_map={ 'mode': 'active',
                     \ 'active_filetypes': [],
                     \ 'passive_filetypes': ['html'] }
" create the loc list so you can jump between errors with arrow keys
let g:syntastic_always_populate_loc_list = 1

" powerline
set nocompatible   " Disable vi-compatibility
set laststatus=2   " Always show the statusline
set encoding=utf-8 " Necessary to show Unicode glyphs

" ctrl p stuff

let g:ctrlp_user_command = {
            \ 'types': {
                \ 1: ['.git', 'cd %s && git ls-files --cached --exclude-standard --others . | grep -v node_modules | grep -v bower_components | grep -v ^build/'],
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
autocmd FileType python nnoremap <buffer> gd :call jedi#goto_definitions()<CR>
autocmd FileType python nnoremap <buffer> <leader>dd :call jedi#goto_definitions()<CR>
" go to where item was defined for this file
autocmd FileType python nnoremap <buffer> <leader>da :call jedi#goto_assignments()<CR>
autocmd FileType python nnoremap <buffer> gd :call jedi#goto_assignments()<CR>
autocmd FileType python nnoremap <buffer> ga :call jedi#goto_assignments()<CR>

"why doesn't the hive syntax plugin do this already??
autocmd BufNewFile,BufRead *.hql set filetype=hive

" clojure paredit has silly mappings
" don't want to bounce between paredit leader and shift
function! ConradPareditBindings()
    call RepeatableNNoRemap(g:paredit_leader . 'm', ':<C-U>call PareditMoveLeft()') 
    call RepeatableNNoRemap(g:paredit_leader . '.', ':<C-U>call PareditMoveRight()') 
endfunction
au FileType lisp      call ConradPareditBindings()
au FileType *clojure* call ConradPareditBindings()
au FileType scheme    call ConradPareditBindings()
au FileType racket    call ConradPareditBindings()
" maybe someday i'll try out the short mappings instead

" tmuxing
"
" init new window to the side
let g:VimuxHeight = "40"
let g:VimuxOrientation = "h"

" basic control mappings
nnoremap <leader>tt :call VimuxRunCommand("")<Left><Left>
autocmd FileType python nnoremap <leader>tt :call VimuxRunCommand("py.test ".expand("%:@"))
map <leader>tq :VimuxCloseRunner<CR>

" wut wut wut wut wut wut wut
" only for ipython
function! Cpaste_Send()
    call VimuxRunCommand("%cpaste")
    call VimuxRunCommand(@")
    call VimuxRunCommand("^D")
endfunction
vnoremap <leader>te y:call Cpaste_Send()<CR>

" mad rerun skills
nmap <silent> <CR> :call VimuxRunLastCommand()<CR>

" send selected text to the shell :D!
vnoremap <leader>tt y:call VimuxRunCommand(@")<cr>

" for clojure, select this form and send it to repl
nnoremap <leader>ta va(y:call VimuxRunCommand(@")<cr>

" this contractor should have never written python
nmap <F8> :TagbarToggle<CR>

" hope that you have elm-format on your path
"autocmd BufWritePost *.elm silent execute "!elm-format --yes % > /dev/null" | edit! | set filetype=elm

" lets see how horrible haskell tooling can be
au FileType haskell nnoremap <buffer> <leader>ee :HdevtoolsType<CR>
au FileType haskell nnoremap <buffer> <silent> <leader>ec :HdevtoolsClear<CR>
" hothasktags suggested this
au FileType haskell set iskeyword=a-z,A-Z,_,.,39

" writing a lot more
au FileType markdown setlocal spell spelllang=en_us


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

" more savings
nmap <silent> <leader>w :w<CR>

" Unfuck my screen
noremap <leader>r :syntax sync fromstart<cr>:redraw!<cr>

" fugitive.vim bindings
nmap <leader>gs :Gstatus<CR>
nmap <leader>gg :Gcommit<CR>

" better list navigation
" move through spaces in the quickfix list by hitting arrow keys
" jumps to next spot, opens folds and recenters the window

" quickfix
" nav between ag search results
nnoremap <left>  :cprev<cr>zvzz
nnoremap <right> :cnext<cr>zvzz
" location list?
" nav between syntastic results
nnoremap <up>    :lprev<cr>zvzz
nnoremap <down>  :lnext<cr>zvzz


" add <F6> binding for running python code
" should eventually update it so that I can make <F6> run things based on filetype
nmap <F6> :w<CR>:!python %<CR>
nmap <leader>f :vim <C-R><C-W> **/*.py

" mapping for ag.vim silver_searcher
nmap <leader>s :Ag 

" auto insert a breakpoint
nmap <leader>b Oimport pytest; pytest.set_trace()<ESC>

" On OSX
" otherwise should compile vim10m with +clipboard
" TODO: Won't work in tmux till you fix the userspace thing
"       https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard/blob/master/Usage.md
vmap <leader>c y:call system("pbcopy", getreg("\""))<CR>
nmap <leader>v :call setreg("\"",system("pbpaste"))<CR>p
nmap <leader>z :source ~/.vimrc<CR>

function! Scrolling(cmd, slide)
    let initial_scroll_jump = ((2 * &scroll) - (2 * a:slide))
    if a:cmd == 'j'
        " Scroll down.
        let tob = line('$')
        let vbl = 'w$'
        let move_disp_cmd = "\<C-E>"
    else
        " Scroll up.
        let tob = 1
        let vbl = 'w0'
        let move_disp_cmd = "\<C-Y>"
    endif
    " do the scroll
    " ease in, jump, ease out
    let friction = 10

    let j = 0
    while j < a:slide
        let s = ((a:slide - j) * friction)
        redraw
        execute 'normal! '.move_disp_cmd
        execute 'sleep '.(s + 1).'m'
        let j += 1
    endwhile

    execute 'normal! '.initial_scroll_jump.move_disp_cmd

    let i = 0
    while i < a:slide
        let s = (i * friction)
        redraw
        execute 'normal! '.move_disp_cmd
        execute 'sleep '.(s + 1).'m'
        let i += 1
    endwhile
endfunction

nmap <C-f> :call Scrolling('j', 3)<CR>
nmap <C-b> :call Scrolling('k', 3)<CR>

" manually install merlin for ocaml support
let g:opamshare = substitute(system('opam config var share'),'\n$','','''')
execute "set rtp+=" . g:opamshare . "/merlin/vim"
autocmd FileType ocaml nnoremap <buffer> gd :MerlinLocate<CR>



"noremap j <NOP>
"noremap k <NOP>
"noremap l <NOP>
"noremap h <NOP>
