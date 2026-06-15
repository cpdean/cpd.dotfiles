-- lsp handler / highlight overrides (gradual-refactor phase 3).
-- extracted from the common on_attach in cpdean_config.lsp.
local M = {}

-- per-buffer cursor document-highlight (called from on_attach when the server
-- reports the document_highlight capability)
M.document_highlight = function()
  vim.api.nvim_exec([[
    hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
    hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
    hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
    augroup lsp_document_highlight
      autocmd! * <buffer>
      autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
      autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
    augroup END
  ]], false)
end

-- the LSP diagnostic colors reference colors that aren't defined, so they all
-- end up as the default color. override them inline against the gruvbox palette.
M.diagnostic_colors = function()
  vim.api.nvim_exec([[
    highlight LspDiagnosticsDefaultWarning ctermfg=175 guifg=#d3869b
    highlight LspDiagnosticsDefaultHint ctermfg=208 guifg=#fe8019
    highlight LspDiagnosticsDefaultError ctermfg=167 guifg=#fb4934
    highlight LspDiagnosticsDefaultInformation ctermfg=109 guifg=#83a598
  ]], false)
end

return M
