-- testing plugins, migrated from vim-plug (gradual-refactor phase 2).
-- loaded eagerly because init.lua still calls neotest.setup{} (with the rust,
-- python, and plenary adapters) right after the shim. that setup moves to
-- plugins later, but for now the adapters must be available at require time.
return {
  {
    "nvim-neotest/neotest",
    lazy = false,
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "nvim-neotest/neotest-python",
      "nvim-neotest/neotest-plenary",
      "rouge8/neotest-rust",
    },
  },
}
