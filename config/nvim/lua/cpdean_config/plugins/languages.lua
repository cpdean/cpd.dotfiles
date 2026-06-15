-- language / syntax plugins, migrated from vim-plug (gradual-refactor phase 2).
-- loaded eagerly so their filetype detection and syntax register (matching the
-- old vim-plug behavior). these are good candidates for ft= lazy-loading later.
return {
  { "rust-lang/rust.vim", lazy = false },
  { "janet-lang/janet.vim", lazy = false },
  { "elixir-lang/vim-elixir", lazy = false },
  { "slashmili/alchemist.vim", lazy = false },
  { "vim-scripts/python.vim--Vasiliev", lazy = false },
  { "mitsuhiko/vim-python-combined", lazy = false },
  { "hylang/vim-hy", lazy = false },
  { "bakpakin/fennel.vim", lazy = false },
  { "dag/vim-fish", lazy = false },
  { "vim-scripts/forth.vim", lazy = false },
  { "tpope/vim-markdown", lazy = false },
}
