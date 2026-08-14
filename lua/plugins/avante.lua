local function avante_context_prompt()
  local api = require("avante.api")
  local utils = require("avante.utils")

  local selection = utils.get_visual_selection_and_range()
  if selection then
    api.ask({
      ask = false,
      selection = selection,
      sidebar_post_render = function(sidebar)
        sidebar:set_input_value(
          string.format("/lines %d-%d ", selection.range.start.lnum, selection.range.finish.lnum)
        )
        sidebar:focus_input()
      end,
    })
    return
  end

  local bufnr = vim.api.nvim_get_current_buf()
  local filepath = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":.")
  if filepath == "" then filepath = "[No Name]" end

  local lnum = vim.fn.line(".")
  local col = vim.fn.col(".")
  local line = vim.api.nvim_get_current_line()
  local Range = require("avante.range")
  local SelectionResult = require("avante.selection_result")
  local selection = SelectionResult:new(
    filepath,
    vim.bo.filetype,
    line,
    Range:new({ lnum = lnum, col = 1 }, { lnum = lnum, col = math.max(#line, 1) })
  )

  api.ask({
    ask = false,
    selection = selection,
    sidebar_post_render = function(sidebar)
      sidebar:set_input_value(string.format("@%s :L%d:C%d ", filepath, lnum, col))
      sidebar:focus_input()
    end,
  })
end

return {
  "yetone/avante.nvim",
  enabled = true,
  build = vim.fn.has("win32") ~= 0
      and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
      or "make",
  event = "VeryLazy",
  version = false, -- Never set this value to "*"! Never!
  opts = {
    provider = "codex",
    providers = {
      ollama = {
        endpoint = "http://127.0.0.1:11434", -- Note that there is no /v1 at the end.
        -- model = "llama3.2:latest",
        model = "qwen2.5:7b-instruct",
        is_env_set = function()
          return require("avante.providers.ollama").check_endpoint_alive()
        end,
        disable_tools = false,
        extra_request_body = {
          options = {
            temperature = 0.7,
            num_ctx = 8192,
            keep_alive = "5m",
          },
         timeout = 30000,
        },
      },
    },
    -- ACP agents show up as providers in Avante. Switch to them with
    -- `:AvanteSwitchProvider`; `:AvanteModels` only lists models for the active provider.
    acp_providers = {
      ["codex"] = {
        command = "codex-acp",
        args = {},
        env = {
          NODE_NO_WARNINGS = "1",
          -- OPENAI_API_KEY = os.getenv("OPENAI_API_KEY"),
        },
      },
    },
    selection = {
      hint_display = "delayed",
      -- hint_display = "none",
    },
    behaviour = {
      auto_set_keymaps = false,
    },
    input = {
      provider = "snacks",
      provider_opts = {
        -- Additional snacks.input options
        title = "Avante Input",
        icon = " ",
      },
    }
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "folke/snacks.nvim",  -- for input provider snacks
    "nvim-tree/nvim-web-devicons",
  },
  cmd = {
    "AvanteAsk",
    "AvanteBuild",
    "AvanteChat",
    "AvanteClear",
    "AvanteEdit",
    "AvanteFocus",
    "AvanteHistory",
    "AvanteModels",
    "AvanteRefresh",
    "AvanteShowRepoMap",
    "AvanteStop",
    "AvanteSwitchProvider",
    "AvanteToggle",
  },
  keys = {
    { "<leader>aa", ":AvanteAsk ", mode = { "n", "v" }, desc = "Ask Avante" },
    { "<leader>ac", "<cmd>AvanteChat<CR>", desc = "Chat with Avante" },
    { "<leader>ae", function() require("avante.api").edit() end, mode = "v", desc = "Quick edit Avante" },
    { "<leader>aT", avante_context_prompt, mode = { "n", "v" }, desc = "Ask Avante with cursor context" },
    { "<leader>af", "<cmd>AvanteFocus<CR>", desc = "Focus Avante" },
    { "<leader>ah", "<cmd>AvanteHistory<CR>", desc = "Avante History" },
    { "<leader>am", "<cmd>AvanteModels<CR>", desc = "Select Avante Model" },
    { "<leader>an", "<cmd>AvanteChatNew<CR>", desc = "New Avante Chat" },
    { "<leader>ap", "<cmd>AvanteSwitchProvider<CR>", desc = "Switch Avante Provider" },
    { "<leader>ar", "<cmd>AvanteRefresh<CR>", desc = "Refresh Avante" },
    { "<leader>as", "<cmd>AvanteStop<CR>", desc = "Stop Avante" },
    { "<leader>at", "<cmd>AvanteToggle<CR>", desc = "Toggle Avante" },
  },
}
