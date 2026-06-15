-- core editor config (no plugins). loaded before lazy and the backup.init.vim
-- shim. submodules: options, autocmds, providers, keymaps.

-- leader must be set before any <leader> maps are defined and before lazy
vim.g.mapleader = " "

require('cpdean_config.core.options')
require('cpdean_config.core.autocmds')
require('cpdean_config.core.providers')
require('cpdean_config.core.keymaps')
