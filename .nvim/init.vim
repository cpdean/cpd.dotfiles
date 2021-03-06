" specific venv just for neovim

" built with virtualenvwrapper, `mkvirtualenv neovim`
" pip install neovim flake8 black

"let g:python3_host_prog = '$HOME/.virtualenvs/nvim/bin/python'
let g:python3_host_prog = '/Users/conraddean/.virtualenvs/neovim/bin/python'

"        if findreadable('/Users/cdean/.virtualenvs/neovim')
"            let g:python3_host_prog = '/Users/cdean/.virtualenvs/neovim/bin/python'
"        else
"            echo "ugh"
"        endif
" TODO: adjust for other home paths on other hosts

" porting my vimrc over to neovim
" no idea how this is supposed to work tbh

"" 1. Vundle Stuff
set nocompatible              " be iMproved, required
filetype off                  " required

" i think this was breaking mappings that have more than one leader in them
" map <SPACE> <leader>
let mapleader = "\<Space>"

" for notational
" let g:nv_main_directory = ['./docs']
" let g:nv_search_paths = ['~/.j/wiki', '~/.j/notes', './docs', './doc', './notes']
let g:nv_search_paths = ['~/.j/vimwiki', './docs', './doc', './notes']
nnoremap <silent> <Leader><tab> :NV<CR>
nnoremap <silent> <Leader>` :NV<CR>

" for some reason the kids these days use vim-plug
call plug#begin('~/.config/nvim/extra_plugins')
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

Plug 'rust-lang/rust.vim'

" LANGUAGE SERVER INTEGRATION
" 2020-11-09: disabling because it automatically runs a 'diagnostics'/'lint'
" on a file, dumping the results in the same location/quickfix list that ACK
" search results are put in, totally wiping out my results when i'm trying to
" track down all the places a search shows up. this makes looking for things
" in the codebase impossible.
" Plug 'autozimu/LanguageClient-neovim', {
"     \ 'branch': 'next',
"     \ 'do': 'bash install.sh',
"     \ }
" neovim added native lsp support. while it sort of works, it's not very
" pleasant to use yet
" Plug 'neovim/nvim-lsp'
" ale for both prose and rust (for now)
" Plug 'w0rp/ale'
"" NOTE: disabling LanguageClient for now.
" Plug 'neoclide/coc.nvim', {'branch': 'release'}
" coc is showing a ton of errors when i open any buffer or any new file from
" an already open buffer. little frustrated the author just puts everything on
" release and also has what appear to be zero tests
" let's figure out if there is a commit that isn't broken
Plug 'neoclide/coc.nvim', {'commit': '1b8dfa58c35fa2d7cd05ee8a6da3e982dcae7d3a'}


Plug 'elixir-lang/vim-elixir'
Plug 'slashmili/alchemist.vim'

Plug 'mileszs/ack.vim'
Plug 'davidhalter/jedi-vim'

Plug 'tpope/vim-surround'

Plug 'scrooloose/nerdtree'
" however i'm really interested in trying this out for a file manager:
" https://github.com/tpope/vim-vinegar

" for git things
Plug 'tpope/vim-fugitive'
" installs a handler for :Gbrowse, so the url to files can be opened in a
" browser
Plug 'tpope/vim-rhubarb'


" default python support is p dismal
Plug 'vim-scripts/python.vim--Vasiliev'
Plug 'mitsuhiko/vim-python-combined'
Plug 'scrooloose/syntastic'

" trying out autofmt on save
Plug 'ambv/black'


" go language stuff
Plug 'fatih/vim-go'

" nevermind paredit.vim is awful and unusable. there is a bug that unbalnces
" parens as you type, not just making it worthless but then the 'paren
" balancing' features of it then prevent you from fixing its mistakes.
"Plug 'kovisoft/paredit'

" a color
" Plug 'drewtempelmeyer/palenight.vim'
Plug 'morhetz/gruvbox'

" playing with a plugin
Plug 'https://github.com/alok/notational-fzf-vim'

" writing
Plug 'tpope/vim-markdown'
" Plug 'junegunn/goyo.vim'
" Plug 'junegunn/limelight.vim'
" Plug 'reedes/vim-pencil'
"

call plug#end()

syntax enable

"
" setup Ack.vim to use ag
if executable('rg')
  let g:ackprg = 'rg --vimgrep'
endif

" enable palenight color scheme
if (has("nvim"))
  "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif

set background=dark
" contrast can be soft, medium, or hard
let g:gruvbox_contrast_dark = "medium"
" search result color clashes with the cursor color, picking
" something more muted so I can see where the cursor is
let g:gruvbox_hls_cursor = "bg4"
colorscheme gruvbox
" gruvbox only lets you config the IncSearch cursor in a high-level way,
" so just make that the same as the search to make search results readable
highlight! link Search IncSearch




" setup language server for all the great things
set hidden

" for quick vim config iteration
autocmd FileType vim nnoremap <silent> <Leader>O :source $HOME/.config/nvim/init.vim<CR>

" completion manager is too aggressive at 0
let g:cm_complete_start_delay = 1000

"" LANGUAGE SERVER CONFIGS

" source $HOME/.config/nvim/config/languageclient-neovim.vim
" ale specific config
" source $HOME/.config/nvim/config/ale.vim
" trying out ale for rust tooling since coc.nvim had so many problems
"
" i had given up on this a few years ago. let's give it another shot
source $HOME/.config/nvim/config/coc.vim


" for black.vim, save all python with it
" autocmd BufWritePre *.py execute ':Black'
" ugh, but currently disabled. i don't wnat to edit OTHER peoples code just mine.
"
" clean rust files on save
" let g:rustfmt_autosave = 1


filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"

" plugin settings ########
let g:syntastic_python_checkers=['flake8']
" syntastic disable html checking
" ocaml syntax checking started to break at some point.  there is probably an
" error in the merlin vim plugin
let g:syntastic_mode_map={ 'mode': 'active',
                     \ 'active_filetypes': [],
                     \ 'passive_filetypes': ['ocaml', 'html'] }
" create the loc list so you can jump between errors with arrow keys
let g:syntastic_always_populate_loc_list = 1

" set elixir path so that alchemist can jump to it
let g:alchemist#elixir_erlang_src = "/Users/cdean/dev/foss/elixir"

" elm-format
let g:elm_format_autosave = 1

"trying to merlin this up for Ocaml
" let g:opamshare = substitute(system('opam config var share'),'\n$','','''')
" execute "set rtp+=" . g:opamshare . "/merlin/vim"
" let g:syntastic_ocaml_checkers = ['merlin']


" ctrl p stuff


" 'true_git_root' is basically 'git rev-parse --show-toplevel' which works in
" submodules
"
" using ag -l because it is much better than anything else for traversing into
" submodules
let g:ctrlp_user_command = {
            \ 'types': {
                \ 1: ['.git', 'cd %s && cd `true_git_root` && ag -l .'],
                \ 2: ['.hg', 'hg --cwd %s locate -I .'],
            \ },
            \ 'fallback': 'find %s -type f'
\ }

let g:ctrlp_custom_ignore = {
  \ 'dir':  '\.git$\|\.hg$\|.svn$\|node_modules$\|\.bin$',
  \ 'file': '\v\.(exe|so|dll|class|)$',
  \ }

" so i can open nerdtree
map <leader>; :NERDTreeToggle<CR>
" uncomment if it is annoying having NERDTree keep vim open when i had intended
" to close vim
" autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" jedi vim
"
" force python verison to prevent jedi from throwing an error
" jedi seems to use an api that nvim does not have to determine python support
" let g:jedi#force_py_version = 3

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
autocmd FileType python nnoremap <buffer> gu :call jedi#usages()<CR>
autocmd FileType python nnoremap <buffer> <leader>dd :call jedi#goto_definitions()<CR>
" go to where item was defined for this file
autocmd FileType python nnoremap <buffer> <leader>da :call jedi#goto_assignments()<CR>
autocmd FileType python nnoremap <buffer> ga :call jedi#goto_assignments()<CR>
" this is not working suddenly... attempting to use this other apio

"why doesn't the hive syntax plugin do this already??
autocmd BufNewFile,BufRead *.hql set filetype=hive


" disabling paredit stuff until paredit can be fixed
" function! ConradPareditBindings()
"     call RepeatableNNoRemap(g:paredit_leader . 'm', ':<C-U>call PareditMoveLeft()') 
"     call RepeatableNNoRemap(g:paredit_leader . '.', ':<C-U>call PareditMoveRight()') 
" endfunction
" au FileType lisp      call ConradPareditBindings()
" au FileType *clojure* call ConradPareditBindings()
" au FileType scheme    call ConradPareditBindings()
" au FileType racket    call ConradPareditBindings()
" maybe someday i'll try out the short mappings instead


source $HOME/.config/nvim/config/rust.vim


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


" md means markdown, vim.
au BufNewFile,BufRead *.md               set ft=markdown

" cljs might as well be clojure
au BufNewFile,BufRead *.cljs             set ft=clojure


" Keep track of code folding
au BufWinLeave * silent! mkview
au BufWinEnter * silent! loadview

" Unfuck my screen
noremap <leader>r :call ConradClearScreen()<cr>

function! ConradClearScreen()
    " wipe search highlight stuff
    "  for some reason this has to be first...
    execute ':nohlsearch'
    " replace the regular screen cleaner below:
    "noremap <leader>r :syntax sync fromstart<cr>:redraw!<cr>
    execute ':syntax sync fromstart'
    execute ':redraw!'
    " close quickfix window, which ag.vim uses
    execute ':cclose'
    " close the help window
    execute ':helpc'
endfunction

" fugitive.vim bindings
nmap <leader>gs :Gstatus<CR>
nmap <leader>gg :Gcommit<CR>
" of course
nmap <leader>gb :Gblame<CR>

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
"nmap <leader>f :vim <C-R><C-W> **/*.py "deprecating, should probably remove


nmap <leader>s :Ack -i 
" search word under cursor, now!
nmap <leader>S :Ack <C-R><C-W><cr>

" auto insert a breakpoint
autocmd FileType python nmap <leader>b Oimport pytest; pytest.set_trace()<ESC>

" I used to have special mappings for clipboard copy-paste but
" i can't handle the mode-error anymore
" yank to clipboard
if has("clipboard")
  set clipboard=unnamed " copy to the system clipboard

  if has("unnamedplus") " X11 support
    set clipboard+=unnamedplus
  endif
endif

function! Scrolling(cmd, slide)
    " MINI PLUGIN - This adds an ease-in/ease-out function for page-wise
    " scrolling in vim.  Because scrolling in vim is an instantaneous redraw,
    " you lose the intuitive context of what has happened when you scroll a
    " page down or up.  This adds a couple tweening frames to try to get the
    " effect of motion.
    let initial_scroll_jump = ((2 * &scroll) - (2 * a:slide))
    if a:cmd == 'j'
        " Scroll down.
        " let tob = line('$') " last line in the current buffer
        " let vbl = 'w$'
        let move_disp_cmd = "\<C-E>"
    else
        " Scroll up.
        " let tob = 1
        " let vbl = 'w0'
        let move_disp_cmd = "\<C-Y>"
    endif
    " do the scroll
    " ease in, jump, ease out
    let get_up_to_speed = 4
    let slowdown = 16

    let j = 0
    while j < a:slide
        let s = ((a:slide - j) * get_up_to_speed)
        redraw
        execute 'normal! '.move_disp_cmd
        execute 'sleep '.(s + 1).'m'
        let j += 1
    endwhile

    execute 'normal! '.initial_scroll_jump.move_disp_cmd

    let i = 0
    while i < a:slide
        let s = (i * slowdown)
        redraw
        execute 'normal! '.move_disp_cmd
        execute 'sleep '.(s + 1).'m'
        let i += 1
    endwhile
endfunction

" just noticed this skips around a little too far
" disabling for a sec
" nmap <C-f> :call Scrolling('j', 5)<CR>
" nmap <C-b> :call Scrolling('k', 5)<CR>


" manually install merlin for ocaml support
" let g:opamshare = substitute(system('opam config var share'),'\n$','','''')
" execute "set rtp+=" . g:opamshare . "/merlin/vim"
" autocmd FileType ocaml nnoremap <buffer> gd :MerlinLocate<CR>
" autocmd FileType ocaml nnoremap <buffer> K :MerlinDocument<CR>

" manually install fzf vim plugin. ctrlp is gettin slow
" experimenting with ctrlp and fzf.vim side by side
nmap <silent> <C-L> :FZF<CR>



"noremap j <NOP>
"noremap k <NOP>
"noremap l <NOP>
"noremap h <NOP>

" WRITING
" =======
" config to make writing english in vim better
autocmd FileType markdown setlocal spell spelllang=en_us
autocmd FileType gitcommit setlocal spell spelllang=en_us
" enable ctrl+n/p autocomplete on english words
"set complete+=kspell

" width for paragraph formatting
" DISABLING because it linebreaks literally everything, often ruining the syntax
" of files
" set textwidth=80

" format paragraph at cursor, only for prose. it is nice for formatting
" comments but this binding would conflict with language server format
" commands
autocmd FileType markdown,gitcommit nmap <leader>f gwap

function! ConradWritingSettings()
    " limelight now has syntax errors.
    " let g:limelight_conceal_ctermfg = 'gray'
    " Limelight
    "call pencil#init()
endfunction

" au group for vim-pencil
augroup pencil
    autocmd!
    autocmd FileType markdown,mkd call ConradWritingSettings()
    " i think 'text' extends to all files so...
    " autocmd FileType text         call ConradWritingSettings()
augroup END

" ansible yaml drives me wild
autocmd FileType yaml set nosmartindent
autocmd FileType yaml set copyindent
autocmd FileType yaml set autoindent
autocmd FileType yaml set sw=2

" all these spelling errors
map <leader>n :set nospell<CR>


nmap <silent> <Leader>h :call <SID>show_documentation()<CR>

function! s:show_documentation()
    if &filetype == 'vim'
        execute 'h '.expand('<cword>')
    else
        normal K
    endif
endfunction

" show me this thing on an internet!!
vnoremap <silent> gh :Gbrowse<CR>

" faster save
nmap <silent> <Leader>w :w<CR>
" bail instant
nmap <silent> <leader>q :q!<CR>
" writequit
nmap <silent> <leader>W :wq<CR>

" switching to kitty fulltime
"vmap <silent> <leader>tt ::w !python_kitty_chunked_send.py<CR><CR>

" the above only sends line ranges. (the first : expands to ` :'<,'> `, which
" defines the selection range in WHOLE LINES)
" the following tries to fix this by storing the text of the selection in the
" register `t` and then sending the contents of the register to the command.
vmap <silent> <leader>tt "ty:call system("python_kitty_chunked_send.py", getreg("@t"))<CR>
