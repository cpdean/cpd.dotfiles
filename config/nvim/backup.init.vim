" python host providers moved to lua/cpdean_config/core/providers.lua

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
filetype off                  " required

" nocompatible (no-op in nvim) dropped; fish shell fallback moved to
" lua/cpdean_config/core/options.lua

let mapleader = "\<Space>"

" for some reason the kids these days use vim-plug
call plug#begin('~/.config/nvim/extra_plugins')
" vim-startuptime migrated to lua/cpdean_config/plugins/startuptime.lua (lazy)

Plug 'nvim-neotest/nvim-nio'

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

Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/lsp_extensions.nvim'
" one dude's extensions. better code-action etc
Plug 'RishabhRD/popfix'
Plug 'RishabhRD/nvim-lsputils'

" a completion framework that seemed to be good
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


Plug 'elixir-lang/vim-elixir'
Plug 'slashmili/alchemist.vim'

Plug 'mileszs/ack.vim'
"Plug 'davidhalter/jedi-vim'

" vim-surround migrated to lua/cpdean_config/plugins/editing.lua (lazy)

Plug 'scrooloose/nerdtree'
" however i'm really interested in trying this out for a file manager:
" https://github.com/tpope/vim-vinegar

" for git things
" Plug 'tpope/vim-fugitive'
" 2021-08-02: hard-coding a commit because fugitive stopped working on neovim at some
" point.
" 9cba97f4db4e0af4275f802c2de977f553d26ec6 - 2021-03-01

"Plug 'tpope/vim-fugitive', {'commit': '9cba97f4db4e0af4275f802c2de977f553d26ec6'}
" fugitive + rhubarb migrated to lua/cpdean_config/plugins/git.lua (lazy)

" more db trickery
Plug 'tpope/vim-dadbod'
Plug 'kristijanhusak/vim-dadbod-completion'

" leap.nvim migrated to lua/cpdean_config/plugins/editing.lua (lazy)


" default python support is p dismal
Plug 'vim-scripts/python.vim--Vasiliev'
Plug 'mitsuhiko/vim-python-combined'
Plug 'scrooloose/syntastic'

" trying out autofmt on save
Plug 'ambv/black'

Plug 'hylang/vim-hy'
" nvim-parinfer migrated to lua/cpdean_config/plugins/editing.lua (lazy)

Plug 'bakpakin/fennel.vim'

Plug 'dag/vim-fish'

Plug 'vim-scripts/forth.vim'

" a color
" Plug 'drewtempelmeyer/palenight.vim'
Plug 'morhetz/gruvbox'

" writing
Plug 'tpope/vim-markdown'

" visually display your position in a file
"Plug 'wellle/context.vim'

" trying to use vim as a github client
" deps of octo.nvim
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'kyazdani42/nvim-web-devicons'

Plug 'nvim-treesitter/nvim-treesitter'

" better test controls
Plug 'nvim-neotest/neotest'
Plug 'nvim-neotest/neotest-python'
Plug 'nvim-neotest/neotest-plenary'

Plug 'tpope/vim-scriptease'

" hello andy
Plug 'rouge8/neotest-rust'

" if isdirectory($HOME . '/dev/work')
"     Plug 'github/copilot.vim'
" endif
Plug 'github/copilot.vim'

" muscle memory file switching per project
" Plug 'nvim-lua/plenary.nvim'
"Plug 'ThePrimeagen/harpoon', { 'branch': 'harpoon2' }

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

" vim ft-local <Leader>O reload map moved to after/ftplugin/vim.lua

" completion manager is too aggressive at 0
let g:cm_complete_start_delay = 1000


" for black.vim, save all python with it
" autocmd BufWritePre *.py execute ':Black'
" ugh, but currently disabled. i don't wnat to edit OTHER peoples code just mine.


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
" python ft-local maps moved to after/ftplugin/python.lua
" this is not working suddenly... attempting to use this other apio



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


" hope that you have elm-format on your path
"autocmd BufWritePost *.elm silent execute "!elm-format --yes % > /dev/null" | edit! | set filetype=elm

" haskell hdevtools maps moved to after/ftplugin/haskell.lua


" editor options moved to lua/cpdean_config/core/options.lua


" filetype detection moved to lua/cpdean_config/core/autocmds.lua


" Keep track of code folding
""" i don't use codefolding so much, and this might be producing too many view
""" files so disabling for now
""au BufWinLeave * silent! mkview
""au BufWinEnter * silent! loadview

" <leader>r (_ClearScreen) map moved to lua/cpdean_config/core/keymaps.lua
function! _ClearScreen()
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

" fugitive.vim bindings moved to lua/cpdean_config/core/keymaps.lua

" better list navigation
" move through spaces in the quickfix list by hitting arrow keys
" jumps to next spot, opens folds and recenters the window

" quickfix
" nav between ag search results
" arrow-key quickfix/loclist nav moved to lua/cpdean_config/core/keymaps.lua


" add <F6> binding for running python code
" should eventually update it so that I can make <F6> run things based on filetype
" <F6> python-run map moved to lua/cpdean_config/core/keymaps.lua
"nmap <leader>f :vim <C-R><C-W> **/*.py "deprecating, should probably remove

" Ack search maps moved to lua/cpdean_config/core/keymaps.lua

" pytest breakpoint map moved to after/ftplugin/python.lua

" I used to have special mappings for clipboard copy-paste but
" i can't handle the mode-error anymore
" yank-to-clipboard config moved to lua/cpdean_config/core/options.lua

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
" <C-L> FZF map moved to lua/cpdean_config/core/keymaps.lua
" override default fzf source so i can see .config files inside a repo
let $FZF_DEFAULT_COMMAND = 'fd --hidden --exclude .git --type f'



"noremap j <NOP>
"noremap k <NOP>
"noremap l <NOP>
"noremap h <NOP>

" WRITING
" =======
" config to make writing english in vim better
" enable ctrl+n/p autocomplete on english words
"set complete+=kspell

" width for paragraph formatting
" DISABLING because it linebreaks literally everything, often ruining the syntax
" of files
" set textwidth=80

" format paragraph at cursor, only for prose. it is nice for formatting
" comments but this binding would conflict with language server format
" commands
" <leader>f prose-format moved to after/ftplugin/markdown.lua + gitcommit.lua

" ansible yaml indent settings moved to lua/cpdean_config/core/autocmds.lua

" <leader>n (:set nospell) moved to lua/cpdean_config/core/keymaps.lua


" <Leader>h (show_documentation) moved to lua/cpdean_config/core/keymaps.lua

" gh (GBrowse) map moved to lua/cpdean_config/core/keymaps.lua

" <leader>q / <leader>W quit maps moved to lua/cpdean_config/core/keymaps.lua

" switching to kitty fulltime
"vmap <silent> <leader>tt ::w !python_kitty_chunked_send.py<CR><CR>

" the above only sends line ranges. (the first : expands to ` :'<,'> `, which
" defines the selection range in WHOLE LINES)
" the following tries to fix this by storing the text of the selection in the
" register `t` and then sending the contents of the register to the command.
" global <leader>tt moved to lua/cpdean_config/core/keymaps.lua (ft variants below)

"vmap <silent> <leader>tt "ty:call system("./zellij-send-text.sh", getreg("@t"))<CR>

" forth/janet <leader>tt kitty-send maps moved to after/ftplugin/forth.lua and janet.lua



" python <Leader>sd / <Leader>dd ic-macro maps moved to after/ftplugin/python.lua

" <leader>xf (format selected xml) moved to lua/cpdean_config/core/keymaps.lua

" yaml formatprg, Jenkinsfile, and *.sls detection moved to
" lua/cpdean_config/core/autocmds.lua

" <leader><leader> (:Buffers) moved to lua/cpdean_config/core/keymaps.lua

" leap.nvim setup moved to its lazy spec config (plugins/editing.lua)



let g:copilot_no_tab_map = v:true
imap <silent><script><expr> <C-j> copilot#Accept('\<CR>')
