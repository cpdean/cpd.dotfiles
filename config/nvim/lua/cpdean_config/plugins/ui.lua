-- ui / cosmetic plugins, migrated from vim-plug (gradual-refactor phase 2).
return {
  {
    "morhetz/gruvbox",
    lazy = false,
    priority = 1000, -- load the colorscheme before other plugins
    config = function()
      -- contrast can be soft, medium, or hard
      vim.g.gruvbox_contrast_dark = "medium"
      -- muted search-cursor color so the cursor stays visible on matches
      vim.g.gruvbox_hls_cursor = "bg4"
      vim.cmd("colorscheme gruvbox")
      -- make Search match IncSearch so results stay readable
      vim.cmd("highlight! link Search IncSearch")
    end,
  },
  { "kyazdani42/nvim-web-devicons", lazy = true },
}
