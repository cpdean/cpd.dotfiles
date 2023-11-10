
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
