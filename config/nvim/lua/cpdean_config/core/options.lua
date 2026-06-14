-- editor options, migrated from backup.init.vim (gradual-refactor phase 1).
-- only unconditional set-options live here; conditional ones (shell=sh for
-- fish, clipboard behind has() guards) stay in backup.init.vim for now.

vim.opt.number = true

-- indentation: 4-space soft tabs
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- ui
vim.opt.background = "dark"
vim.opt.hidden = true
vim.opt.showcmd = true
vim.opt.wildmenu = true
vim.opt.ruler = true
vim.opt.linebreak = true -- more visually appealing wordwrap

-- search
vim.opt.ignorecase = true -- search matches ignore case
vim.opt.smartcase = true -- ...unless you type a capital
vim.opt.incsearch = true -- search as you type
vim.opt.hlsearch = true -- highlight matches

-- new splits open below / to the right
vim.opt.splitbelow = true
vim.opt.splitright = true
