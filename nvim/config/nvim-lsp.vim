lua << EOF



-- mini before seeing the example in the readme
-- local nvim_lsp = require'lspconfig'
-- nvim_lsp.rust_analyzer.setup{}
-- nvim_lsp.clangd.setup{}


-- look at coc config for ideas $HOME/.config/nvim/config/coc.vim
--
--

-- define a noop local in this module
local completer_configs = function(client, bufnr)
  return nil
end

-- toggle between completion-nvim and nvim-compe

if false then
    local completion = require('completion')
    completer_configs = function(client, bufnr)
      -- completion-nvim settings

      -- disable the auto popup. by default it opens as you type, and by default it
      -- automatically selects and inserts the first item in the list and as you keep
      -- typing you insert characters after the item that was inserted.
      --
      -- so by design completion-nvim is horribly unusable out of the box.
      vim.api.nvim_set_var('completion_enable_auto_popup', 0)
      vim.api.nvim_set_var('completion_matching_strategy_list', {'exact', 'substring', 'fuzzy', 'all'})

      -- imap <silent> <c-p> <Plug>(completion_trigger)
      vim.api.nvim_buf_set_keymap(bufnr, 'i', '<c-p>', '<Plug>(completion_trigger)', { silent=true} )
      -- set completeopt=menuone,noinsert,noselect
      vim.api.nvim_set_option('completeopt', 'menuone,noinsert,noselect')

      -- completion-nvim
      completion.on_attach(client, bufnr)
    end
else

  require'compe'.setup {
    enabled = true;
    autocomplete = false;
    debug = false;
    min_length = 1;
    preselect = 'enable';
    throttle_time = 80;
    source_timeout = 200;
    incomplete_delay = 400;
    max_abbr_width = 100;
    max_kind_width = 100;
    max_menu_width = 100;
    documentation = true;

    source = {
      path = true;
      buffer = true;
      --calc = true;
      --nvim_lsp = true;
      --nvim_lua = true;
      --vsnip = true;
    };
  }
  vim.api.nvim_exec([[
    inoremap <silent><expr> <C-Space> compe#complete()
    inoremap <silent><expr> <CR>      compe#confirm('<CR>')
    inoremap <silent><expr> <C-e>     compe#close('<C-e>')
    inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
    inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })
  ]], false)
  vim.o.completeopt = "menuone,noselect"

end


-- taken from nvim-lspconfig readme
local nvim_lsp = require('lspconfig')
local common_on_attach = function(client, bufnr)
  completer_configs(client, bufnr)
  -- lsp configs
  --
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  --buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  --buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  --buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  --buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  --buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  --buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  --buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  --buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  --buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

  -- -- Set some keybinds conditional on server capabilities
  -- if client.resolved_capabilities.document_formatting then
  --   buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  -- elseif client.resolved_capabilities.document_range_formatting then
  --   buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
  -- end

  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
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
end



-- Use a loop to conveniently both setup defined servers 
-- and map buffer local keybindings when the language server attaches
nvim_lsp.rust_analyzer.setup { on_attach = common_on_attach  }

local clangd_attach = function(client, bufnr)
  common_on_attach(client, bufnr)
  local opts = { noremap=true, silent=true }
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gh', '<Cmd>ClangdSwitchSourceHeader<CR>', opts)
end

nvim_lsp.clangd.setup { on_attach = clangd_attach }

EOF

