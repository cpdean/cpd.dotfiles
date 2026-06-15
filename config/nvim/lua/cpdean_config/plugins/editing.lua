-- editing plugins, migrated from vim-plug (gradual-refactor phase 2).
-- loaded eagerly to match vim-plug behavior.
return {
  { "tpope/vim-surround", lazy = false },
  {
    "ggandor/leap.nvim",
    lazy = false,
    config = function()
      require("leap").add_default_mappings()
    end,
  },
  -- structural editing for lisps (fennel, janet, hy, ...)
  { "gpanders/nvim-parinfer", lazy = false },
}
