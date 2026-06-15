-- python filetype-local maps, migrated from backup.init.vim (gradual-refactor
-- phase 1). buffer-local, the idiomatic ftplugin way.

-- drop a pytest breakpoint above the current line
vim.keymap.set("n", "<leader>b", "Oimport pytest; pytest.set_trace()<ESC>", { buffer = true, remap = true })

-- wrap the visual selection in dbg-style ic()
vim.keymap.set("v", "<Leader>sd", '"ndiic()<esc>"nP', { buffer = true, remap = true, silent = true })

-- delete surrounding ic() macro: search back to ic, cut what's in parens,
-- paste over the now-empty ic()
vim.keymap.set("n", "<Leader>dd", [[?\<ic\><CR>f(dibnvf)p]], { buffer = true, remap = true, silent = true })
