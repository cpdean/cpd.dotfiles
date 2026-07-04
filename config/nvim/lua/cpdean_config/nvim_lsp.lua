
-- neoconf must be set up before lsp servers
require("neoconf").setup({
  -- overrides here
})

local cpdean_nvm_lsp = {
}


function cpdean_nvm_lsp.start_lsp_client()

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

  -- nvim 0.11 lsp api: vim.lsp.config(name, overrides) merges with the base
  -- config nvim-lspconfig ships under lsp/<name>.lua, then vim.lsp.enable(name)
  -- starts it on matching filetypes. (replaces the deprecated lspconfig framework.)
  local rust_config = require("cpdean_config.languages.rust")
  local common = require("cpdean_config.lsp")

  -- cmp-aware capabilities for every server
  vim.lsp.config('*', { capabilities = common.capabilities() })

  vim.lsp.config('rust_analyzer', {
    settings = {
      ['rust-analyzer'] = { cargo = { features = "all" } }
    },
    on_attach = rust_config.rust_analyzer_attach,
  })

  local clangd_attach = function(client, bufnr)
    common.common_on_attach(client, bufnr)
    local opts = { noremap=true, silent=true }
    -- clangd switch source/header. call the lsp method directly so this
    -- doesn't depend on the lspconfig-registered user command.
    vim.api.nvim_buf_create_user_command(bufnr, 'ClangdSwitchSourceHeader', function()
      local c = vim.lsp.get_clients({ bufnr = bufnr, name = 'clangd' })[1]
      if not c then return vim.notify('clangd not attached') end
      local params = vim.lsp.util.make_text_document_params(bufnr)
      c.request('textDocument/switchSourceHeader', params, function(err, result)
        if err then error(tostring(err)) end
        if not result then return vim.notify('no corresponding file') end
        vim.cmd.edit(vim.uri_to_fname(result))
      end, bufnr)
    end, {})
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gh', '<Cmd>ClangdSwitchSourceHeader<CR>', opts)
    vim.api.nvim_create_autocmd('BufWritePre', {
      buffer = bufnr,
      callback = function() vim.lsp.buf.format({ async = false, timeout_ms = 1000 }) end,
    })
  end
  vim.lsp.config('clangd', { on_attach = clangd_attach })

  -- brew install pyright
  vim.lsp.config('pyright', { on_attach = common.common_on_attach })

  -- lua, lua_ls
  local LUA_PATH = vim.split(package.path, ';')
  table.insert(LUA_PATH, "lua/?.lua")
  table.insert(LUA_PATH, "lua/?/init.lua")
  table.insert(LUA_PATH, "/Applications/Hammerspoon.app/Contents/Resources/extensions/?.lua")
  table.insert(LUA_PATH, "~/.local/share/hammerspoon/site/?.lua")
  table.insert(LUA_PATH, "~/.local/share/hammerspoon/site/?/init.lua")
  table.insert(LUA_PATH, "~/.local/share/hammerspoon/site/spoons/?.spoon/init.lua")

  local lua_on_attach = function(client, bufnr)
      -- `<Plug>(Luadev-RunLine)` / `<Plug>(Luadev-Run)` from nvim-luadev
      local opts = { noremap=false, silent=false }
      vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ll', '<Plug>(Luadev-RunLine)', opts)
      vim.api.nvim_buf_set_keymap(bufnr, 'v', '<leader>lr', '<Plug>(Luadev-Run)', opts)
      return common.common_on_attach(client, bufnr)
  end
  vim.lsp.config('lua_ls', {
    on_attach = lua_on_attach,
    settings = {
      Lua = {
        runtime = {
          version = 'LuaJIT',
          path = LUA_PATH,
        },
        diagnostics = {
          -- recognize the `vim` global
          globals = {'vim'},
        },
        workspace = {
          library = vim.api.nvim_get_runtime_file("", true),
        },
        telemetry = {
          enable = false,
        },
      },
    },
  })

  local golang_attach = function(client, bufnr)
    common.common_on_attach(client, bufnr)
  end
  vim.lsp.config('gopls', { on_attach = golang_attach })

  -- npm install -g typescript typescript-language-server
  vim.lsp.config('ts_ls', {})

  -- brew install zls
  vim.lsp.config('zls', { on_attach = common.common_on_attach })

  -- nu --lsp (built into nushell)
  vim.lsp.config('nushell', { on_attach = common.common_on_attach })

  vim.lsp.enable({ 'rust_analyzer', 'clangd', 'pyright', 'lua_ls', 'gopls', 'ts_ls', 'zls', 'nushell' })

end

return cpdean_nvm_lsp
