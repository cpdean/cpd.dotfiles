--[[
TODO: plugins to try

https://github.com/stevearc/overseer.nvim/
  general task running

https://github.com/folke/neodev.nvim
  autoconfigures lsp for neovim lua config

https://github.com/tamago324/nlsp-settings.nvim
  configure lsp servers with jsonfiles instead of by-hand with lua

https://github.com/nvim-neo-tree/neo-tree.nvim
  side-bar file tree

https://github.com/TimUntersberger/neogit
https://github.com/tanvirtin/vgit.nvim
  i like fugitive and rhubarb, but maybe there's better ones out there

https://github.com/nvim-telescope/telescope.nvim
  i like fzf.vim, but others uses this one for fuzzyfind

https://github.com/simrat39/rust-tools.nvim
  pre-configuring lspconfig for rust
--]]

require('cpdean_config.languages')
require('cpdean_config.neovide')
vim.cmd([[source $HOME/.config/nvim/backup.init.vim]])
