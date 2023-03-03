
-- neoconf must be set up before lsp servers
require("neoconf").setup({
  -- overrides here
})

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

--local completion_plugin = "compe"
local completion_plugin = "nvim-cmp"

if completion_plugin == "completion" then
  local completion = require('completion')
  completer_configs = function(client, bufnr)
    -- completion-nvim settings

    -- disable the auto popup. by default it opens as you type, and by default it
    -- automatically selects and inserts the first item in the list and as you keep
    -- typing you insert characters after the item that was inserted.
    --
    -- so by design completion-nvim is horribly unusable out of the box.
    -- disabling config because it does not work
    if false then
      vim.api.nvim_set_var('completion_enable_auto_popup', 0)
      vim.api.nvim_set_var('completion_matching_strategy_list', {'exact', 'substring', 'fuzzy', 'all'})

      -- imap <silent> <c-p> <Plug>(completion_trigger)
      vim.api.nvim_buf_set_keymap(bufnr, 'i', '<c-p>', '<Plug>(completion_trigger)', { silent=true} )
    end
    -- set completeopt=menuone,noinsert,noselect
    vim.api.nvim_set_option('completeopt', 'menuone,noinsert,noselect')

    -- completion-nvim
    completion.on_attach(client, bufnr)
  end
elseif completion_plugin == "nvim-cmp" then
  local cmp = require('cmp')
  cmp.setup({
    snippet = {
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
    },

    -- paste entire obj because i don't kno whow to selectively disable one option
    completion = {
      autocomplete = false,  -- disable opening completion menu by default
      completeopt = 'menu,menuone,noselect',  -- original default
      keyword_pattern = [[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%(-\w*\)*\)]],  -- original default
      keyword_length = 1,  -- original default
      get_trigger_characters = function(trigger_characters)  -- original default
        return trigger_characters  -- original default
      end,  -- original default
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' },
      { name = 'nvim_lua' },
    },
    {
      { name = 'buffer' },
    }),
    mapping = {
      --['<C-x><C-o>'] = cmp.mapping.complete(), --- Manually trigger completion
      ['<C-space>'] = cmp.mapping.complete(), --- Manually trigger completion
      ['<Right>'] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      }),
      ['<Tab>'] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      }),
    },
  })
else
  function wiki_complete_get_metadata(...)
    return {
      filetypes = {"markdown"},
      priority = 100,
      dup = 0,
      menu = "[wiki boii]";
    }
  end

  function wiki_complete_determine(self, context)
    -- i do not know what the hell these mean so
    return {
      ['keyword_pattern_offset']= 0,
      ['trigger_character_offset']= 0,
    }
  end

  function wiki_complete_stuff(a)
    return {
      ["get_metadata"] = wiki_complete_get_metadata,
      ["determine"] = wiki_complete_determine,
      ["complete"] = (function(self, argthings)
        -- TODO figure out how dadbod omni func works
        -- let items = vim_dadbod_completion#omni(0, a:args.input)
        -- for item in items
        --   let item.filter_text = item.abbr
        -- endfor
        -- call a:args.callback({ 'items': items })
        local items = {}
        local _items = {"conradexample1", "conradexample2", "conradexample3"}
        for i, item in ipairs(_items) do
          local e = {}
          e.word = item
          e.abbr = item
          e.filter_text = item
          e.sort_text = item
          table.insert(items, e)
        end
        --print(args)
        local uh = ""
        for i, e in ipairs(argthings) do
          uh = uh .. ", " .. i
        end
        argthings.callback({["items"] = items})
      end),
    }
  end

  require'compe'.register_source('wikicomplete', wiki_complete_stuff())

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
      --path = true;
      buffer = true;
      --nvim_lsp = true;
      --nvim_lua = true;
      wikicomplete = true;
      --calc = true;
      --vsnip = true;
    };
  }
  local opts = { silent=true }
  --vim.api.nvim_set_keymap('i', '<C-Space> ', '<Cmd>compe#complete()<CR>', opts)
  --  inoremap <silent><expr> <C-Space> compe#complete()
  vim.api.nvim_exec([[
    inoremap <silent><expr> <C-Space> compe#complete()
    inoremap <silent><expr> <CR>      compe#confirm('<CR>')
    inoremap <silent><expr> <C-e>     compe#close('<C-e>')
  ]], false)
  vim.o.completeopt = "menuone,noselect"

end

-- dadbod database completions
--
--

if false then
  vim.api.nvim_exec([[
    " For built in omnifunc
    autocmd FileType sql setlocal omnifunc=vim_dadbod_completion#omni

    " hrsh7th/nvim-compe
    autocmd FileType sql let g:compe.source.vim_dadbod_completion = v:true


    " Source is automatically added, you just need to include it in the chain complete list
    let g:completion_chain_complete_list = {
        \   'sql': [
        \    {'complete_items': ['vim-dadbod-completion']},
        \   ],
        \ }
    " Make sure `substring` is part of this list. Other items are optional for this completion source
    let g:completion_matching_strategy_list = ['exact', 'substring']
    " Useful if there's a lot of camel case items
    let g:completion_matching_ignore_case = 1
  ]], false)
end


-- taken from nvim-lspconfig readme
local nvim_lsp = require('lspconfig')
local common_on_attach = function(client, bufnr)
  completer_configs(client, bufnr)
  -- lsp configs
  --
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', '<leader>a', '<Cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('v', '<leader>a', '<Cmd>lua vim.lsp.buf.range_code_action()<CR>', opts)
  buf_set_keymap('n', '<leader>en', '<Cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  --buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  --buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  --buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  --buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  --buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  --buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

  -- Set some keybinds conditional on server capabilities
  if client.server_capabilities.document_formatting then
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  end

  if client.server_capabilities.document_range_formatting then
    buf_set_keymap("v", "<space>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
  end

  -- Set autocommands conditional on server_capabilities
  if client.server_capabilities.document_highlight then
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

  -- the LSP diagnostic colors refrence colors that aren't defined, so they all
  -- end up as the default color. i don't know how to make these map to real colors
  -- so just going to override some inline
  vim.api.nvim_exec([[
    highlight LspDiagnosticsDefaultWarning ctermfg=175 guifg=#d3869b 
    highlight LspDiagnosticsDefaultHint ctermfg=208 guifg=#fe8019
    highlight LspDiagnosticsDefaultError ctermfg=167 guifg=#fb4934
    highlight LspDiagnosticsDefaultInformation ctermfg=109 guifg=#83a598 
  ]], false)

end

--     -- not sure if this should be wrapped into the onattach or gated to only rust or not
--     vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
--       vim.lsp.diagnostic.on_publish_diagnostics, {
--         virtual_text = true,
--         signs = true,
--         update_in_insert = true,
--       }
--     )
--

-- custom settings for rust-analyzer
local rust_analyzer_attach = function(client, bufnr)
  common_on_attach(client, bufnr)
  local opts = { noremap=true, silent=true }
  -- TODO: autocmd to disable when in $HOME/dev/foss/rust
  if true then
    vim.api.nvim_exec([[
      autocmd BufWritePre *.rs lua vim.lsp.buf.format({ async = false })
    ]], false)
  end


end


local add_auto_complete = function(capabilities)
  if completion_plugin == "compe" then
     capabilities.textDocument.completion.completionItem.snippetSupport = true
  elseif completion_plugin == "nvim-cmp" then
    capabilities = require('cmp_nvim_lsp').default_capabilities()
  end
  return capabilities
end

local capabilities = add_auto_complete(vim.lsp.protocol.make_client_capabilities())

nvim_lsp.rust_analyzer.setup {
  settings = {
    ['rust-analyzer'] = { cargo = { features = "all" } }
  },
  on_attach = rust_analyzer_attach,
  capabilities = capabilities,
}


local clangd_attach = function(client, bufnr)
  common_on_attach(client, bufnr)
  local opts = { noremap=true, silent=true }
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gh', '<Cmd>ClangdSwitchSourceHeader<CR>', opts)
  -- TODO: autocmd to disable when in $HOME/dev/foss/cpp
  if true then
    vim.api.nvim_exec([[
      autocmd BufWritePre *.cpp,*.h lua vim.lsp.buf.formatting_sync(nil, 1000)
    ]], false)
  end


end

-- brew install pyright
  require'lspconfig'.pyright.setup({
    capabilities = capabilities,
    on_attach = common_on_attach,
})

-- lua, sumneko
if true then
  -- common nvim-cmp init
  local capabilities = require('cmp_nvim_lsp').default_capabilities()

  local LUA_PATH = vim.split(package.path, ';')
  table.insert(LUA_PATH, "lua/?.lua")
  table.insert(LUA_PATH, "lua/?/init.lua")

  local lua_on_attach = function(client, bufnr)
      -- `<Plug>(Luadev-RunLine)`      | Execute the current line
      -- `<Plug>(Luadev-Run)`          | Operator to execute lua code over a movement or text object.
      -- `<Plug>(Luadev-RunWord)`      | Eval identifier under cursor, including `table.attr`
      -- `<Plug>(Luadev-Complete)`     | in insert mode: complete (nested) global table fields
      local opts = { noremap=false, silent=false }
      vim.api.nvim_buf_set_keymap(bufnr,
          'n', '<leader>ll', '<Plug>(Luadev-RunLine)', opts)
      vim.api.nvim_buf_set_keymap(bufnr,
          'v', '<leader>lr', '<Plug>(Luadev-Run)', opts)
      return common_on_attach(client, bufnr)
  end

  require'lspconfig'.lua_ls.setup {
    capabilities = capabilities,
    on_attach = lua_on_attach,
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = 'LuaJIT',
          -- Setup your lua path
          path = LUA_PATH,
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = {'vim'},
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file("", true),
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false,
        },
      },
    },
  }
end


if completion_plugin == "nvim-cmp" then
  -- assume this will have been made when initializing rust config
  -- local capabilities = require('cmp_nvim_lsp').default_capabilities()
  nvim_lsp.clangd.setup {
    on_attach = clangd_attach,
    capabilities = capabilities
  }
else 
  nvim_lsp.clangd.setup { on_attach = clangd_attach }
end

local golang_attach = function(client, bufnr)
  common_on_attach(client, bufnr)
end

require'lspconfig'.gopls.setup{
    capabilities = capabilities,
    on_attach = golang_attach,
}

-- from RishabhRD/nvim-lsputils
-- vim.lsp.handlers['textDocument/codeAction'] = require'lsputil.codeAction'.code_action_handler

-- run :SymbolsOutline
require("symbols-outline").setup()
