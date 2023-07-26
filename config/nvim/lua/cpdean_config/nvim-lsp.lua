
-- neoconf must be set up before lsp servers
require("neoconf").setup({
  -- overrides here
})


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
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
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

-- taken from nvim-lspconfig readme
local nvim_lsp = require('lspconfig')

local rust_config = require("cpdean_config.languages.rust")


local add_auto_complete = function(capabilities)
  capabilities = require('cmp_nvim_lsp').default_capabilities()
  return capabilities
end

local capabilities = add_auto_complete(vim.lsp.protocol.make_client_capabilities())

local common = require("cpdean_config.common_lsp_config")

nvim_lsp.rust_analyzer.setup {
  settings = {
    ['rust-analyzer'] = { cargo = { features = "all" } }
  },
  on_attach = rust_config.rust_analyzer_attach,
  capabilities = capabilities,
}


local clangd_attach = function(client, bufnr)
  common.common_on_attach(client, bufnr)
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
  on_attach = common.common_on_attach,
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
      return common.common_on_attach(client, bufnr)
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


nvim_lsp.clangd.setup {
  on_attach = clangd_attach,
  capabilities = capabilities
}

local golang_attach = function(client, bufnr)
  common.common_on_attach(client, bufnr)
end

require'lspconfig'.gopls.setup{
    capabilities = capabilities,
    on_attach = golang_attach,
}

-- TODO: does not work with tauri typescript
-- cargo install deno --locked
-- -- vim.g.markdown_fenced_languages = {
-- --   "ts=typescript"
-- -- }
-- -- 
-- -- require'lspconfig'.denols.setup{}

-- npm install -g typescript typescript-language-server
require'lspconfig'.tsserver.setup{}

-- from RishabhRD/nvim-lsputils
-- vim.lsp.handlers['textDocument/codeAction'] = require'lsputil.codeAction'.code_action_handler

-- run :SymbolsOutline
require("symbols-outline").setup()
