
A block from my vimrc for adding clojure/list plugins. I haven't settled on the right mix of plugins, nor how to use them. I don't use any lisps at the moment so this is clutter until I have a real reason to evaluate these.

```
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
```

For several years I've tried a lot of LSP clients. I've settled on neovim's built in one in the hopes that dogfooding it enough would help neovim have better support of these features out of the box in the future, and so we not need all these clunky competing clients (coc.nvim runs out of a nodejs server written in typescript that then spins up more servers and vim sends it commands).

These were the servers tried and discarded for various reasons

```
if s:lsp_impl == 'autozimu/LanguageClient-neovim'
    Plug 'autozimu/LanguageClient-neovim', {
        \ 'branch': 'next',
        \ 'do': 'bash install.sh',
        \ }
elseif s:lsp_impl == 'neovim/nvim-lspconfig'
    " I'm stubborn about getting native neovim features dogfooded fully, so
    " this is the part of this if-block I have been in for a few years.
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

```
