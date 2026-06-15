-- lazy.nvim bootstrap (gradual-refactor-init.lua, phase 2).
-- plugins migrated to lazy live in lua/cpdean_config/plugins/*.lua. plugins not
-- yet migrated are still managed by vim-plug in backup.init.vim.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
-- core editor config (options/autocmds/providers/keymaps). loaded before lazy
-- so options like background are set before plugin colorschemes load.
require('cpdean_config.core')

require("lazy").setup("cpdean_config.plugins")

require('cpdean_config.languages')
require('cpdean_config.neovide')

require("cpdean_config.nvim_lsp").start_lsp_client()

-- Neotest
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



local normal_menus = {'<leader>g', '<leader>t'}
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
vim.keymap.set('n', "<leader>y" , '<cmd>lua vim.diagnostic.open_float(0, { scope = "line", border = "single" })<CR>', {noremap = true, silent = true})

require("code_explain").setup({
  -- how to open the terminal: "split", "vsplit", or "tabnew"
  window = "vsplit",
  -- height/width of the split (lines or columns)
  size = 49,
})

-- trigger from visual mode with <leader>e
vim.keymap.set("v", "<leader>e", function()
  -- drop back to normal mode so the '< '> marks are set
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "x", false)
  require("code_explain").explain()
end, { desc = "Explain selected code with Claude" })
