
-- i don't quite know
-- following an example https://github.com/emilienlemaire/dotfiles-arch/blob/0efb059d88f96873a2a51d47d0f8677d2c4c9151/dotfiles/nvim/init.lua#L1-L5

-- and https://gist.github.com/mgattozzi/51d6b4f94f99ade07498efa873c7bd43
--
--
-- TODO study this nvim-lua guy's dotfiles
-- https://github.com/haorenW1025/config/tree/master/.config/nvim

local g = vim.g
local o = vim.o
local cmd = vim.cmd
local w = vim.wo
local b = vim.bo


local HOME = os.getenv('HOME')

g.python_host_prog  = HOME .. '/.virtualenvs/neovimpy2/bin/python'
g.python3_host_prog = HOME .. '/.virtualenvs/neovim/bin/python'

-- do vimplug
cmd('set nocompatible')
cmd('filetype off') -- i think you need this?
vim.fn['plug#begin'](HOME .. '/.config/nvim/extra_plugins')

cmd("Plug 'rust-lang/rust.vim'")
cmd("Plug 'morhetz/gruvbox'")

vim.fn['plug#end']()
cmd('filetype on') -- i think you need this?


g.gruvbox_contrast_dark = "medium"
--" search result color clashes with the cursor color, picking
--" something more muted so I can see where the cursor is
g.gruvbox_hls_cursor = "bg4"
cmd('colorscheme gruvbox')

-- love too map
g.mapleader = ' '

local remap = vim.api.nvim_set_keymap
remap('n','<leader>q',':q!<CR>', { silent = true })
remap('n','<leader>w',':w!<CR>', { silent = true })
