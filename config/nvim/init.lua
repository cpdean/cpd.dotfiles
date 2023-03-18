--[[
TODO: plugins to try

--- IDE/PROJECT MANAGEMENT
  https://github.com/stevearc/overseer.nvim/
    general task running

  https://github.com/tamago324/nlsp-settings.nvim
    configure lsp servers with jsonfiles instead of by-hand with lua

--- LSP CONFIG

  https://github.com/folke/neodev.nvim
    autoconfigures lsp for neovim lua config

  https://github.com/simrat39/rust-tools.nvim
    pre-configuring lspconfig for rust

  https://github.com/Saecki/crates.nvim
    add LSP features to Cargo.toml

--- UI
  https://github.com/nvim-telescope/telescope.nvim
    i like fzf.vim, but others uses this one for fuzzyfind

  vim.ui overrides
  |
  | https://github.com/stevearc/dressing.nvim
  |   customizes vim.ui.input and vim.ui.select visually
  |   works with vanilla, telescope, and fzf's use of vim.ui.select
  |
  | https://github.com/nvim-telescope/telescope-ui-select.nvim
  |   replace nvim's vanilla option selector with one backed by telescope
  |
  | https://github.com/hood/popui.nvim
  |   telescope-ui-select but stand-alone and without telescope dependency
  |   also overrides the input selector (ie, lsp code action: rename dialog)
  |   provides custom selector for marks, diagnostics
  | -- filler
  | https://github.com/filipdutescu/renamer.nvim

  https://github.com/hoschi/yode-nvim
    dynamically create views into parts of a file. do this for multiple
    inter-related parts so you can see them all at once. edit files normlly,
    or edit through the view. everything is in sync

  which-key / auto-cheat sheet stuff
  |
  | https://github.com/folke/which-key.nvim
  | https://github.com/liuchengxu/vim-which-key
  |   spacemacs which-key popup as you hit keybindings
  |
  | https://github.com/mrjones2014/legendary.nvim
  |   like which-key but also supports command cheatsheets
  |
  | https://github.com/sudormrfbin/cheatsheet.nvim
  | https://github.com/LinArcX/telescope-command-palette.nvim
  |   same things

  plugin management
  | currently use vim-plug. it's fine, but packer.nvim has become pretty
  | popular instead
  | https://github.com/wbthomason/packer.nvim
  |   really popular, config through lua so i can ditch vimscript
  | https://github.com/folke/lazy.nvim
  |   claims to do magic for speeding up startup times. also has a UI


  jump-nav
  |
  | I currently use leap.nvim. it's pretty good. the alternatives here
  | may have different or better ideas:
  | https://github.com/justinmk/vim-sneak
  | https://github.com/rlane/pounce.nvim
  | https://github.com/easymotion/vim-easymotion
  | https://github.com/phaazon/hop.nvim

  https://github.com/ziontee113/syntax-tree-surfer
    navigation and text object manipulation based on treesitter parsing

  https://github.com/nacro90/numb.nvim
    as-you-type peeking at line numbers. hitting esc goes back

  https://github.com/nvim-neo-tree/neo-tree.nvim
    side-bar file tree

  https://github.com/haringsrob/nvim_context_vt
    tries to solve the same problem as context.vim, but only annotates the
    ends of blocks it's nice that it's a minimal approach, but you're still
    lost in the middle of a fn

  https://github.com/chrisbra/NrrwRgn
    select part of a file. edit it in a sandboxed buffer

  https://github.com/matbme/JABS.nvim
    buffer switcher

  https://github.com/AckslD/nvim-neoclip.lua
    fuzzy picker for contents of your register history

  https://github.com/j-hui/fidget.nvim
  https://github.com/nvim-lua/lsp-status.nvim
  https://github.com/arkav/lualine-lsp-progress
    show progress of LSP operations

  -- various dialogs to explore marks/registers
  -- probably just microplugins of what telescope provides
  -- these are dumb filler of the author of the medium
  -- posts i'm gathering from
    https://github.com/tversteeg/registers.nvim
    https://github.com/chentoast/marks.nvim
    https://github.com/kshenoy/vim-signature
    https://github.com/MattesGroeger/vim-bookmarks

--- SCM
  https://github.com/TimUntersberger/neogit
  https://github.com/tanvirtin/vgit.nvim
    i like fugitive and rhubarb, but maybe there's better ones out there

  https://github.com/sindrets/diffview.nvim
    could go under UI or IDE project mgmt sections. improves on vim's
    native `:diffthis`. automates opening of multiple file diffs based
    on git. provides a mergeview for looking at merge conflicts

  https://github.com/rhysd/git-messenger.vim
    hover diagnostic for git blame of current line

--- fine-tuning
  https://github.com/dstein64/vim-startuptime
    measure startuptime

  https://github.com/lewis6991/impatient.nvim
    speed up loading lua modules

  https://github.com/nathom/filetype.nvim
    speed up startup by optimizing filetype config

--- prose
  https://github.com/junegunn/goyo.vim
  https://github.com/junegunn/limelight.vim
  https://github.com/preservim/vim-pencil
  https://github.com/preservim/vim-markdown

https://github.com/Pocco81/true-zen.nvim
  commands to remove visual clutter, focus on a section, fullscreen a file
--]]


require('cpdean_config.languages')
require('cpdean_config.neovide')
vim.cmd([[source $HOME/.config/nvim/backup.init.vim]])

-- Neotest
require("neotest").setup({
  adapters = {
    require("neotest-rust"),
  },
})

local neotest = require("neotest")
neotest.setup({
    discovery = { enabled = false },
    log_level = 0,
    adapters = {
        require("neotest-rust")({}),
        require("neotest-plenary")({}),
        require("neotest-python")({
            args = { "-v" },
        }),
    },
})

local bufopts = { noremap = true, silent = true }
-- Run the nearest test
vim.keymap.set("n", "<leader>ii", neotest.run.run, bufopts)
-- Run all tests in the file
vim.keymap.set("n", "<leader>I", function()
    neotest.run.run(vim.fn.expand("%"))
end, bufopts)
-- run the whole suite
vim.keymap.set("n", "<leader>II", function() neotest.run.run({suite=true}) end, bufopts)
-- rerun the test from the last position
vim.keymap.set("n", "<leader>ir", neotest.run.run_last, bufopts)


-- View the test output
vim.keymap.set("n", "<leader>io", neotest.output.open, bufopts)
-- View the test summary
vim.keymap.set("n", "<leader>is", neotest.summary.open, bufopts)



local normal_menus = {'<leader>', '<leader>g', '<leader>t'}
for m = 1, #normal_menus do
  local query = normal_menus[m]
  vim.keymap.set('n', query , ':nmap ' .. query .. '<CR>')
end

local visual_menus = {'<leader>'}
for m = 1, #visual_menus do
  local query = visual_menus[m]
  vim.keymap.set('v', query , ':<C-U>vmap ' .. query .. '<CR>' )
end

vim.keymap.set('n', "<leader>et" , ':lua require"init"<CR>' )

--require('cpdean_config.dap_config')
--require("dapui").setup()
