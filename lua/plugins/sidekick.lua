
-- Your Neovim AI sidekick. https://github.com/folke/sidekick.nvim
return {
  "folke/sidekick.nvim",
  enabled = true,
  opts = {
     cli = {
      tools = {
        oterm = {
          cmd = { "oterm" },
        },
        llama4 = {
          cmd = { "ollama", "run", "llama3.2:latest" },
          url = "https://ollama.com",
        },
        llama8 = {
          cmd = { "ollama", "run", "llama3.1:8b" },
          url = "https://ollama.com",
        },
        qwen7 = {
          cmd = { "ollama", "run", "qwen2.5:7b-instruct" },
          url = "https://github.com/QwenLM/Qwen3",
        },
        qwen14 = {
          cmd = { "ollama", "run", "qwen3:14b" },
          url = "https://github.com/QwenLM/Qwen3",
        },
      },
      win = {
        keys = {
          -- Codex and probably other CLIs have Esc mapping for their own scrollback,
          -- so better to not map Esc. Ctrl-Q works.
          --
          -- Use Esc to enter terminal-normal mode (opens Sidekick scrollback)
          -- stopinsert = { "<Esc>", "stopinsert", mode = "t", desc = "enter normal mode" },

          -- Change modifier key from default Ctrl to Alt so they don't interfere
          -- with agent or Neovim keymaps.
          buffers  = { "<M-b>", "buffers", mode = "nt", desc = "open buffer picker" },
          files    = { "<M-f>", "files"  , mode = "nt", desc = "open file picker" },
          prompt   = { "<M-p>", "prompt" , mode = "t" , desc = "Insert prompt or context" },

          -- Don't hide the window on Ctrl-Q; it conflicts with stopinsert/scrollback
          hide_ctrl_q = false,
        },
      },
      mux = {
        backend = "tmux",   -- Scrollback didn't work with zellij.
        enabled = true,
      },
    },
  },
  keys = {
    {
      "<tab>",
      function()
        -- if there is a next edit, jump to it, otherwise apply it if any
        if not require("sidekick").nes_jump_or_apply() then
          return "<Tab>" -- fallback to normal tab
        end
      end,
      expr = true,
      desc = "Goto/Apply Next Edit Suggestion",
    },
    {
      "<c-.>",
      function() require("sidekick.cli").focus() end,
      -- function() require("sidekick.cli").toggle() end,
      desc = "Sidekick Focus",
      mode = { "n", "t", "i", "x" },
    },
    {
      "<leader>Aa",
      function() require("sidekick.cli").toggle() end,
      desc = "Sidekick Toggle CLI",
    },
    {
      "<leader>As",
      function() require("sidekick.cli").select() end,
      -- Or to select only installed tools:
      -- require("sidekick.cli").select({ filter = { installed = true } })
      desc = "Select CLI",
    },
    {
      "<leader>Ad",
      function() require("sidekick.cli").close() end,
      desc = "Detach a CLI Session",
    },
    {
      "<leader>At",
      function() require("sidekick.cli").send({ msg = "{this}" }) end,
      mode = { "x", "n" },
      desc = "Send This",
    },
    {
      "<leader>Af",
      function() require("sidekick.cli").send({ msg = "{file}" }) end,
      desc = "Send File",
    },
    {
      "<leader>Av",
      function() require("sidekick.cli").send({ msg = "{selection}" }) end,
      mode = { "x" },
      desc = "Send Visual Selection",
    },
    {
      "<leader>Ap",
      function() require("sidekick.cli").prompt() end,
      mode = { "n", "x" },
      desc = "Sidekick Select Prompt",
    },
    {
      "<leader>Ac",
      function()
        local server = "copilot"
        local ok_is_enabled, is_enabled = pcall(vim.lsp.is_enabled, server)
        if not ok_is_enabled then
          vim.notify("Copilot LSP toggle requires vim.lsp.is_enabled", vim.log.levels.ERROR)
          return
        end

        if is_enabled then
          vim.lsp.disable(server)
          for _, client in ipairs(vim.lsp.get_clients({ name = server })) do
            client:stop()
          end
          vim.notify("Copilot language server disabled")
        else
          local ok_enable, err = pcall(vim.lsp.enable, server)
          if not ok_enable then
            vim.notify("Failed to enable copilot-language-server: " .. tostring(err), vim.log.levels.ERROR)
            return
          end
          vim.notify("Copilot language server enabled")
        end
      end,
      desc = "Toggle Copilot LSP",
    },

    -- Example of a keybinding to open Claude directly
    -- {
    --   "<leader>ac",
    --   function() require("sidekick.cli").toggle({ name = "claude", focus = true }) end,
    --   desc = "Sidekick Toggle Claude",
    -- },
  },
}
