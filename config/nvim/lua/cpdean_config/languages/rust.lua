local rust = {}

local common = require("cpdean_config.common_lsp_config")

-- custom settings for rust-analyzer
rust.rust_analyzer_attach = function(client, bufnr)
  common.common_on_attach(client, bufnr)
  local opts = { noremap=true, silent=true }
  -- TODO: autocmd to disable when in $HOME/dev/foss/rust
  if true then
    vim.api.nvim_exec([[
      autocmd BufWritePre *.rs lua vim.lsp.buf.format({ async = false })
    ]], false)
  end
end

return rust
