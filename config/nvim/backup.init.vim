" specific venv just for neovim

" on macos
" no idea how to do it for python2 but these are notes...
" python -m ensurepip --upgrade --user
" python -m pip install virtualenv --user
" mkdir ~/.virtualenvs
" pip install neovim flake8 black
let g:python_host_prog  = '$HOME/.virtualenvs/neovimpy2/bin/python'

" add a python3 venv
" python3 -m venv ~/.virtualenvs/neovim
" source ~/.virtualenvs/neovim/bin/activate
" python -m pip install neovim flake8 black

"let g:python3_host_prog = '$HOME/.virtualenvs/nvim/bin/python'
let g:python3_host_prog = '$HOME/.virtualenvs/neovim/bin/python'

" LANGUAGE SERVER INTEGRATION
" there are so many generc LSP plugins, rather than reliable vim plugins
" backed by an LSP. hopefully the native lsp API will make all of these
" irrelevant
"
" LSP timeline
"
" started with various one-off plugins. eventually tried out ALE, then back to
" one-off plugins, then tried various LSP plugins, tried coc.nvim, got
" frustrated and then bounced around for a while before going back to
" coc.nvim.
"
" switched to LanguageClient-neovim but it had issues:
"
" 2020-11-09: disabling because it automatically runs a 'diagnostics'/'lint'
" on a file, dumping the results in the same location/quickfix list that ACK
" search results are put in, totally wiping out my results when i'm trying to
" track down all the places a search shows up. this makes looking for things
" in the codebase impossible.
"
" 2021-03-22: I want to get away from coc.nvim because there are a few things
" about it that bother me: the codebase is absolutely enormous, which maybe
" that's not a bad thing, but it makes working on it unapproachable and i keep
" forgetting how to deal with its UI system, despite its generic listing
" widget being useful.
"
" I want to look at what has been written with lua so that there are no
" additional runtime dependencies (coc.nvim is written in typescript, runs as
" a separate nodejs server that then manages all the language servers)
"
" i'm looking for a good fuzzy complete, and that means either completion-nvim
" or nvim-compe.  the first one is more popular, and supports native nvim lsp
" out of the box, the second one apparently fixes the flicker issue of the
" firrst. but that means needing to switch to neovim/nvim-lsp which, when i
" first tried it, was not pleasant to use.
"
"let s:lsp_impl = 'autozimu/LanguageClient-neovim'
let s:lsp_impl = 'neovim/nvim-lspconfig'
"let s:lsp_impl = 'w0rp/ale'
"let s:lsp_impl = 'coc.nvim'

"let g:completion_plugin = 'completion-nvim'
" disabled because it would do this very gross stutter at the beginning of
" usage
"let g:completion_plugin = 'compe'
" nvim-cmp is a rewrite of compe, same author. so far so good. better api and
" works as advertized
let g:completion_plugin = 'nvim-cmp'


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

" fish breaks how vim runs commands so set it to a shell that doesn't
if &shell =~# 'fish$'
    set shell=sh
endif

let mapleader = "\<Space>"

" for some reason the kids these days use vim-plug
call plug#begin('~/.config/nvim/extra_plugins')
" for lols
Plug 'dstein64/vim-startuptime'

" lua repl hooked into the neovim lua env
"
Plug 'bfredl/nvim-luadev'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

Plug 'rust-lang/rust.vim'

Plug 'janet-lang/janet.vim'

" global or per-project editor settings
Plug 'folke/neoconf.nvim'

Plug 'simrat39/symbols-outline.nvim'

if s:lsp_impl == 'autozimu/LanguageClient-neovim'
    Plug 'autozimu/LanguageClient-neovim', {
        \ 'branch': 'next',
        \ 'do': 'bash install.sh',
        \ }
elseif s:lsp_impl == 'neovim/nvim-lspconfig'
    Plug 'neovim/nvim-lspconfig'
    Plug 'nvim-lua/lsp_extensions.nvim'
    " one dude's extensions. better code-action etc
    Plug 'RishabhRD/popfix'
    Plug 'RishabhRD/nvim-lsputils'
elseif s:lsp_impl == 'w0rp/ale'
    Plug 'w0rp/ale'
elseif s:lsp_impl == 'coc.nvim'
    "" NOTE: disabling LanguageClient for now.
    " Plug 'neoclide/coc.nvim', {'branch': 'release'}
    " coc is showing a ton of errors when i open any buffer or any new file from
    " an already open buffer. little frustrated the author just puts everything on
    " release and also has what appear to be zero tests
    " let's figure out if there is a commit that isn't broken
    " Plug 'neoclide/coc.nvim', {'commit': '1b8dfa58c35fa2d7cd05ee8a6da3e982dcae7d3a'}
    " 2021-04-27 great. you can't pin coc plugins and so reinstalling it has
    " forced me to need to unpin my coc version. likely gonna break someshit.
    " i am not pleased with coc.nvim becoming a sub-ecosystem.
    Plug 'neoclide/coc.nvim'
else
    echo 'could not find matching s:lsp_impl: ' . s:lsp_impl
endif

if s:lsp_impl == 'neovim/nvim-lspconfig'
    if g:completion_plugin == 'compe'
        Plug 'hrsh7th/nvim-compe'
        Plug 'hrsh7th/vim-vsnip'
    elseif g:completion_plugin == 'nvim-cmp'
        " author of nvim-compe did a rewrite
        Plug 'hrsh7th/nvim-cmp'
        " hook into lsp for nvim-cmp
        Plug 'hrsh7th/cmp-nvim-lsp'
        " completions for neovim's lua api
        Plug 'hrsh7th/cmp-nvim-lua'

        " extras
        " Plug 'hrsh7th/cmp-buffer'
        " Plug 'hrsh7th/cmp-path'
        " Plug 'hrsh7th/cmp-cmdline'

        " integrate with a snippet plugin for cmp
        Plug 'hrsh7th/cmp-vsnip'
        Plug 'hrsh7th/vim-vsnip'
    else
        Plug 'nvim-lua/completion-nvim'
    endif
endif

Plug 'elixir-lang/vim-elixir'
Plug 'slashmili/alchemist.vim'

Plug 'mileszs/ack.vim'
"Plug 'davidhalter/jedi-vim'

Plug 'tpope/vim-surround'

Plug 'scrooloose/nerdtree'
" however i'm really interested in trying this out for a file manager:
" https://github.com/tpope/vim-vinegar

" for git things
" Plug 'tpope/vim-fugitive'
" 2021-08-02: hard-coding a commit because fugitive stopped working on neovim at some
" point. 
" 9cba97f4db4e0af4275f802c2de977f553d26ec6 - 2021-03-01

"Plug 'tpope/vim-fugitive', {'commit': '9cba97f4db4e0af4275f802c2de977f553d26ec6'}
" at some point neovim broke fugitive, so trying latest

Plug 'tpope/vim-fugitive'

" installs a handler for :Gbrowse, so the url to files can be opened in a
" browser
Plug 'tpope/vim-rhubarb'

" more db trickery
Plug 'tpope/vim-dadbod'
Plug 'kristijanhusak/vim-dadbod-completion'

" trying out this movement plugin
Plug 'ggandor/leap.nvim'


" default python support is p dismal
Plug 'vim-scripts/python.vim--Vasiliev'
Plug 'mitsuhiko/vim-python-combined'
Plug 'scrooloose/syntastic'

" trying out autofmt on save
Plug 'ambv/black'

Plug 'hylang/vim-hy'

Plug 'bakpakin/fennel.vim'

Plug 'dag/vim-fish'

Plug 'vim-scripts/forth.vim'

" nevermind paredit.vim is awful and unusable. there is a bug that unbalnces
" parens as you type, not just making it worthless but then the 'paren
" balancing' features of it then prevent you from fixing its mistakes.
"Plug 'kovisoft/paredit'
" this is supposed to be better than paredit because you don't have to 
" memorize new verbs, just keep it simple with by sticking to lisp-style
" indentation
" " 2021-09-11
" " disabling for a bit, this breaks OSS projects, and i do not see other
" " clojure users using this
" Plug 'eraserhd/parinfer-rust', {'do':
"         \  'cargo build --release'}

" wrapping clojure stuff in this guard because it is a lot
if 0
    " Commenting out conjure stuff for now. i am struggling with it so i want to
    " try older stuff first.
    " repl management and interaction
    Plug 'Olical/conjure', {'tag': 'v4.23.0'}

    " need dispatch for the jack-in plugin
    Plug 'radenling/vim-dispatch-neovim'

    " and jack-in for nrepl management for conjure
    Plug 'clojure-vim/vim-jack-in'
else
    Plug 'tpope/vim-fireplace'
    " tim set up ctags bindings but i like gd
    " :Djump {word cursor is on}
    autocmd FileType clojure nmap gd :Djump <C-R><C-W><CR>

    " maybe
    " Plug 'clojure-vim/vim-jack-in'
endif
" a color
" Plug 'drewtempelmeyer/palenight.vim'
Plug 'morhetz/gruvbox'

" writing
Plug 'tpope/vim-markdown'
" Plug 'junegunn/goyo.vim'
" Plug 'junegunn/limelight.vim'
" Plug 'reedes/vim-pencil'

" visually display your position in a file
"Plug 'wellle/context.vim'

" trying to use vim as a github client
" deps of octo.nvim
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'kyazdani42/nvim-web-devicons'
" gh client
Plug 'pwntester/octo.nvim'

Plug 'nvim-treesitter/nvim-treesitter'
" welcome to the eighties
"    Plug 'vim-test/vim-test'

" better test controls
Plug 'nvim-neotest/neotest'
Plug 'nvim-neotest/neotest-python'
Plug 'nvim-neotest/neotest-plenary'
Plug 'tpope/vim-scriptease'

" hello andy
Plug 'rouge8/neotest-rust'

if isdirectory($HOME . '/dev/work')
    Plug 'github/copilot.vim'
endif

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


lua require"octo".setup()


" setup language server for all the great things
set hidden

" for quick vim config iteration
autocmd FileType vim nnoremap <silent> <Leader>O :source $HOME/.config/nvim/init.vim<CR>

" completion manager is too aggressive at 0
let g:cm_complete_start_delay = 1000

"" LANGUAGE SERVER CONFIGS

if s:lsp_impl == 'autozimu/LanguageClient-neovim'
    source $HOME/.config/nvim/config/languageclient-neovim.vim
elseif s:lsp_impl == 'neovim/nvim-lspconfig'
    " lua require("cpdean_config/nvim-lsp")
elseif s:lsp_impl == 'w0rp/ale'
    source $HOME/.config/nvim/config/ale.vim
elseif s:lsp_impl == 'coc.nvim'
    source $HOME/.config/nvim/config/coc.vim
endif


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
"autocmd FileType python nnoremap <buffer> gd :call jedi#goto_definitions()<CR>
"autocmd FileType python nnoremap <buffer> gu :call jedi#usages()<CR>
"autocmd FileType python nnoremap <buffer> <leader>dd :call jedi#goto_definitions()<CR>
" go to where item was defined for this file
"autocmd FileType python nnoremap <buffer> <leader>da :call jedi#goto_assignments()<CR>
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

"nmap <silent> <leader>i :TestNearest<CR>
"nmap <silent> <leader>I :TestFile<CR>
"nmap <silent> <leader>a :TestSuite<CR>
"nmap <silent> <leader>l :TestLast<CR>
"nmap <silent> <leader>g :TestVisit<CR>

nmap <silent> <leader>i :lua require("neotest").run.run()<CR>
nmap <silent> <leader>I :lua require("neotest").run.run(vim.fn.expand("%"))<CR>
"nmap <silent> <leader>a :TestSuite<CR>
"nmap <silent> <leader>l :TestLast<CR>
"nmap <silent> <leader>g :TestVisit<CR>


autocmd FileType lua set sw=2


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

" .fs is normally fsharp, but i'm on a FORTH kick now
au BufNewFile,BufRead *.fs             set ft=forth


" Keep track of code folding
""" i don't use codefolding so much, and this might be producing too many view
""" files so disabling for now 
""au BufWinLeave * silent! mkview
""au BufWinEnter * silent! loadview

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
nmap <leader>gb :Git blame<CR>

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
" override default fzf source so i can see .config files inside a repo
let $FZF_DEFAULT_COMMAND = 'fd --hidden --exclude .git --type f'



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

" open line in github
vnoremap <silent> gh :GBrowse<CR>

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

"vmap <silent> <leader>tt "ty:call system("./zellij-send-text.sh", getreg("@t"))<CR>

autocmd FileType forth vmap <silent> <leader>tt "ty:call system("python_kitty_chunked_send.py -r", getreg("@t"))<CR>

" janet repl needs lines to end in \r\n for it to run a command
autocmd FileType janet vmap <silent> <leader>tt "ty:call system("python_kitty_chunked_send.py -d", getreg("@t"))<CR>

" format selected xml
vmap <silent> <leader>xf :'<,'> !python3 -c "import xml.dom.minidom, sys; print(xml.dom.minidom.parse(sys.stdin).toprettyxml())"<CR>

" format sql
" brew install pgformatter
" setlocal because `set` scopes it to the entire session.
autocmd FileType yaml setlocal formatprg=pg_format

" jenkinsfiles are groovy
autocmd BufNewFile,BufRead Jenkinsfile set filetype=groovy

" salt files are basically python?
autocmd BufNewFile,BufRead  *.sls set filetype=python

" like ctrl+L but only for open files
map <leader><leader> :Buffers<CR>

" enable leap.nvim plugin for movement tricks
lua require('leap').add_default_mappings()



let g:copilot_no_tab_map = v:true
imap <silent><script><expr> <C-j> copilot#Accept('\<CR>')
