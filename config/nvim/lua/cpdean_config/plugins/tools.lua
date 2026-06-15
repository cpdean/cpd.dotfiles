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
  {
    "github/copilot.vim",
    lazy = false,
    init = function()
      -- must be set before copilot loads, or it grabs <Tab>
      vim.g.copilot_no_tab_map = true
    end,
    config = function()
      vim.keymap.set("i", "<C-j>", 'copilot#Accept("\\<CR>")', { expr = true, replace_keycodes = false, silent = true })
    end,
  },
}
