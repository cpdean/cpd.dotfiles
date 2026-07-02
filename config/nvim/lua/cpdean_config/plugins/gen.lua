-- gen.nvim — hit a key, type a request, a local LLM writes the code.
-- pointed at the local LM Studio server (openai-compatible), mirroring the
-- lmstudio setup in config/opencode/opencode.json and plugins/avante.lua
-- (same endpoint + model).
--
-- gen.nvim defaults to Ollama, but its response parser auto-detects openai
-- SSE ("data: " + choices[].delta.content), so overriding `command` to hit
-- LM Studio's /v1/chat/completions endpoint is all that's needed. no api key.
--
-- usage: <leader>] (normal or visual) opens the prompt picker. the built-in
-- "Generate" prompt is the freeform "type a request, get code" flow; with a
-- selection, "Change_Code" / "Enhance_Code" edit it in place.
return {
  "David-Kunz/gen.nvim",
  cmd = "Gen",
  keys = {
    { "<leader>]", ":Gen<CR>", mode = { "n", "v" }, desc = "gen.nvim: local LLM prompt picker" },
  },
  opts = {
    model = "qwen3.5-4b",
    host = "127.0.0.1",
    port = "1234",
    command = function(options)
      return "curl --silent --no-buffer -X POST http://"
        .. options.host
        .. ":"
        .. options.port
        .. "/v1/chat/completions -H 'Content-Type: application/json' -d $body"
    end,
    display_mode = "split", -- review output in a split before taking it
    show_prompt = true,
    show_model = true,
  },
}
