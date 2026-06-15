-- rust filetype-local maps, migrated from config/nvim/config/rust.vim
-- (gradual-refactor phase 3). buffer-local, matching the other ftplugin maps.

-- surround the visual selection in a dbg!() macro
vim.keymap.set("v", "<Leader>sd", '"ndidbg!()<esc>"nP', { buffer = true, remap = true, silent = true })

-- delete the surrounding dbg!() macro: search back to dbg, cut what's in the
-- parens, paste over the now-empty dbg!()
vim.keymap.set("n", "<Leader>dd", "?dbg<CR>f(dibnvf)p", { buffer = true, remap = true, silent = true })
