
-- i don't quite know
-- following an example https://github.com/emilienlemaire/dotfiles-arch/blob/0efb059d88f96873a2a51d47d0f8677d2c4c9151/dotfiles/nvim/init.lua#L1-L5

-- and https://gist.github.com/mgattozzi/51d6b4f94f99ade07498efa873c7bd43
--
--
-- TODO study this nvim-lua guy's dotfiles
-- https://github.com/haorenW1025/config/tree/master/.config/nvim
--
-- TODO: sorta lua https://github.com/Olical/dotfiles/blob/f853315c1bebdf4c3d3e1c4e7e3de96bd91cb6f6/stowed/.config/nvim/fnl/dotfiles/module/plugin/compe.fnl

local g = vim.g
local o = vim.o
local cmd = vim.cmd
local w = vim.wo
local b = vim.bo

local LSP_IMPLEMENTATION = "coc.nvim"


local HOME = os.getenv('HOME')

-- prepare the venvs:
-- built with virtualenvwrapper, `mkvirtualenv neovim`
-- pip install neovim flake8 black

g.python_host_prog  = HOME .. '/.virtualenvs/neovimpy2/bin/python'
g.python3_host_prog = HOME .. '/.virtualenvs/neovim/bin/python'

-- do vimplug
cmd('set nocompatible') -- TODO: do you need this?
cmd('filetype off') -- TODO: do you need this?
vim.fn['plug#begin'](HOME .. '/.config/nvim/extra_plugins')

cmd("Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }")
cmd("Plug 'junegunn/fzf.vim'")

if LSP_IMPLEMENTATION == "coc.nvim" then
    -- use 1b8dfa because something was broken on master one time
    cmd("Plug 'neoclide/coc.nvim', {'commit': '1b8dfa58c35fa2d7cd05ee8a6da3e982dcae7d3a'}")
end

-- language extras
-- elixir and custom lsp
cmd("Plug 'elixir-lang/vim-elixir'")
cmd("Plug 'slashmili/alchemist.vim'")

cmd("Plug 'rust-lang/rust.vim'")

--" default python support is p dismal
cmd("Plug 'davidhalter/jedi-vim'")
cmd("Plug 'vim-scripts/python.vim--Vasiliev'")
cmd("Plug 'mitsuhiko/vim-python-combined'")
cmd("Plug 'scrooloose/syntastic'")

-- lisps
cmd("Plug 'hylang/vim-hy'")
cmd("Plug 'eraserhd/parinfer-rust', {'do':  'cargo build --release'}")

cmd("Plug 'mileszs/ack.vim'")
cmd("Plug 'tpope/vim-surround'")

cmd("Plug 'tpope/vim-markdown'")

cmd("Plug 'tpope/vim-fugitive'")
--" installs a handler for :Gbrowse, so the url to files can be opened in a
--" browser
cmd("Plug 'tpope/vim-rhubarb'")

cmd("Plug 'morhetz/gruvbox'") -- color

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
