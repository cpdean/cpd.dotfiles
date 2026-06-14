-- lazy.nvim bootstrap (gradual-refactor-init.lua, phase 0).
-- clones the lazy plugin manager but registers no plugins yet; vim-plug in
-- backup.init.vim still manages everything until phase 2 migrates the specs.
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
require("lazy").setup({})


require('cpdean_config.languages')
require('cpdean_config.neovide')

vim.cmd([[source $HOME/.config/nvim/backup.init.vim]])

require("cpdean_config/nvim-lsp").start_lsp_client()

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




--require('cpdean_config.dap_config')
--require("dapui").setup()

-- docs are wrong?
-- vim.api.nvim_exec([[
-- if isdirectory($HOME . '/dev/work')
-- :Copilot enable
-- endif
-- ]], false)


-- HARPOON
--
-- persistent marks and an API to customize how you deal with them
-- harpoon navigation
--      local harpoon = require("harpoon")
--
--      -- REQUIRED
--      harpoon:setup()
--      -- REQUIRED
--
--      vim.keymap.set("n", "<leader>k", function() harpoon:list():append() end)
--      -- ctrl-e to open the list of harpoons. edit it like a file to re-order or remove harpoons
--      vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
--
--      --vim.keymap.set("n", "<C-y>", function() harpoon:list():select(1) end)
--      -- j is for the central file, with u, i, o, being 3 others
--      vim.keymap.set("n", "<C-j>", function() harpoon:list():select(1) end)
--      vim.keymap.set("n", "<C-u>", function() harpoon:list():select(2) end)
--      vim.keymap.set("n", "<C-i>", function() harpoon:list():select(3) end)
--      vim.keymap.set("n", "<C-o>", function() harpoon:list():select(4) end)
--
--      -- the author had this, not yet sure how i feel about it. will probably ditch
--      -- Toggle previous & next buffers stored within Harpoon list
--      vim.keymap.set("n", "<leader><C-p>", function() harpoon:list():prev() end)
--      vim.keymap.set("n", "<leader><C-n>", function() harpoon:list():next() end)

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
