-- misc tool plugins, migrated from vim-plug (gradual-refactor phase 2).
-- eager to match vim-plug (and so the :Ack / :NERDTreeToggle maps work).
return {
  { "bfredl/nvim-luadev", lazy = false },
  { "mileszs/ack.vim", lazy = false },
  { "scrooloose/nerdtree", lazy = false },
  { "tpope/vim-dadbod", lazy = false },
  { "kristijanhusak/vim-dadbod-completion", lazy = false },
  { "tpope/vim-scriptease", lazy = false },
  { "ambv/black", lazy = false },
}
