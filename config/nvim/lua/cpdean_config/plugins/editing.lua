-- editing plugins, migrated from vim-plug (gradual-refactor phase 2).
-- loaded eagerly to match vim-plug behavior.
return {
  { "tpope/vim-surround", lazy = false },
  -- leap disabled for now: the repo moved to Codeberg and add_default_mappings
  -- is deprecated. re-enable with the new url + mapping API when ready.
  -- {
  --   "ggandor/leap.nvim",
  --   lazy = false,
  --   config = function()
  --     require("leap").add_default_mappings()
  --   end,
  -- },
  -- structural editing for lisps (fennel, janet, hy, ...)
  { "gpanders/nvim-parinfer", lazy = false },
}
