-- git plugins, migrated from vim-plug (gradual-refactor phase 2).
-- loaded eagerly (like vim-plug did) since the maps in core/keymaps.lua
-- (<leader>gs, gh -> GBrowse) expect these commands to exist.
return {
  { "tpope/vim-fugitive", lazy = false },
  -- rhubarb installs the :GBrowse handler; depends on fugitive
  { "tpope/vim-rhubarb", dependencies = { "tpope/vim-fugitive" }, lazy = false },
}
