-- lsp + completion plugins, migrated from vim-plug (gradual-refactor phase 2).
-- loaded eagerly because the lsp setup (cpdean_config.nvim-lsp.start_lsp_client,
-- still called from init.lua) expects neoconf, lspconfig, cmp, vsnip, and
-- lsputils to be available at require time. the actual setup() calls move into
-- lua/lsp/ in phase 3.
return {
  -- neoconf must load before lsp servers are configured
  { "folke/neoconf.nvim", lazy = false },

  { "neovim/nvim-lspconfig", lazy = false },
  { "nvim-lua/lsp_extensions.nvim", lazy = false },

  -- better code-action / reference UI
  { "RishabhRD/popfix", lazy = false },
  { "RishabhRD/nvim-lsputils", dependencies = { "RishabhRD/popfix" }, lazy = false },

  -- symbols outline (on demand)
  { "simrat39/symbols-outline.nvim", cmd = "SymbolsOutline", config = true },

  -- snippet engine used by the cmp config
  { "hrsh7th/vim-vsnip", lazy = false },

  -- completion framework + its sources
  {
    "hrsh7th/nvim-cmp",
    lazy = false,
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-vsnip",
      "hrsh7th/vim-vsnip",
    },
  },
}
