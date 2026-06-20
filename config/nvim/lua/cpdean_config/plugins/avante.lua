-- avante.nvim — AI assistant in nvim, pointed at the local LM Studio server
-- (openai-compatible), mirroring the opencode lmstudio setup in
-- config/opencode/opencode.json (endpoint + model).
return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  version = false, -- never pin to "*"
  build = "make",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    -- nvim-web-devicons already provided by plugins/ui.lua
  },
  opts = {
    provider = "lmstudio",
    providers = {
      -- LM Studio exposes an openai-compatible API; inherit the openai provider
      -- and point it at the local server. no api key needed.
      lmstudio = {
        __inherited_from = "openai",
        api_key_name = "",
        endpoint = "http://127.0.0.1:1234/v1",
        model = "qwen3.5-4b",
        -- tools are enabled, so prompts are large. if you hit n_keep >= n_ctx,
        -- raise the model's Context Length in LM Studio (e.g. 32768) rather than
        -- dropping features. max_tokens caps the response's share of the window.
        extra_request_body = {
          max_tokens = 4096,
        },
      },
    },
  },
}
