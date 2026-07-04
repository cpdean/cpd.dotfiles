-- new nvim-treesitter rewrite (requires nvim 0.12+): no configs module,
-- no ensure_installed. parsers installed via build hook; highlight is neovim
-- built-in, enabled per-filetype in after/ftplugin/.
return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = function()
      require("nvim-treesitter").install({ "nu" }):wait()
    end,
  },
}
