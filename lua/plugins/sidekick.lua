return {
  "folke/sidekick.nvim",
  opts = {
    -- add any options here
    cli = {
      mux = {
        backend = "zellij",
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
      function() require("sidekick.cli").toggle() end,
      desc = "Sidekick Toggle",
      mode = { "n", "t", "i", "x" },
    },
    {
      "<leader>aa",
      function() require("sidekick.cli").toggle() end,
      desc = "Sidekick Toggle CLI",
    },
    {
      "<leader>as",
      function() require("sidekick.cli").select() end,
      -- Or to select only installed tools:
      -- require("sidekick.cli").select({ filter = { installed = true } })
      desc = "Select CLI",
    },
    {
      "<leader>ad",
      function() require("sidekick.cli").close() end,
      desc = "Detach a CLI Session",
    },
    {
      "<leader>at",
      function() require("sidekick.cli").send({ msg = "{this}" }) end,
      mode = { "x", "n" },
      desc = "Send This",
    },
    {
      "<leader>af",
      function() require("sidekick.cli").send({ msg = "{file}" }) end,
      desc = "Send File",
    },
    {
      "<leader>av",
      function() require("sidekick.cli").send({ msg = "{selection}" }) end,
      mode = { "x" },
      desc = "Send Visual Selection",
    },
    {
      "<leader>ap",
      function() require("sidekick.cli").prompt() end,
      mode = { "n", "x" },
      desc = "Sidekick Select Prompt",
    },
    {
      "<leader>ac",
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
