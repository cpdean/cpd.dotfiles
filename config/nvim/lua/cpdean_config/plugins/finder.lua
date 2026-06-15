-- finder plugins, migrated from vim-plug (gradual-refactor phase 2).
-- the :FZF/:Buffers maps in core/keymaps.lua need fzf.vim loaded, so it's eager.
-- the fzf binary already lives on PATH (~/.fzf, Homebrew), so the old vim-plug
-- `do: ./install --all` build is intentionally dropped — that script edits
-- shell rc files, which we don't want.
return {
  { "junegunn/fzf", lazy = false },
  { "junegunn/fzf.vim", dependencies = { "junegunn/fzf" }, lazy = false },

  -- telescope is installed but unconfigured; load it on demand
  { "nvim-lua/plenary.nvim", lazy = true },
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
}
