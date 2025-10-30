
-- Plugins for editing

-- Vim-Insert-Single-Character
-- https://github.com/bagohart/vim-insert-append-single-character
return {
  {
    "bagohart/vim-insert-append-single-character",
    keys = {
      -- For nordic and german keyboard layouts.
      { "ä", "<Plug>(ISC-insert-at-cursor)", mode = "n", desc = "Insert character before cursor" },
      { "Ä", "<Plug>(ISC-append-at-cursor)", mode = "n", desc = "Insert character after cursor" },
    },
    vscode = true
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      defaults = {},
      spec = {
        {
          mode = { "n", "x" },
          { "<F1>", "<cmd>WhichKey<cr>", desc = "WhichKey (global)" },
          { "<leader>c", group = "Code" },
          { "<leader>dp", group = "Profiler" },
          { "<leader>g", group = "Git" },
          { "<leader>gh", group = "Hunks" },
          { "<leader>f", group = "File/Find" },
          { "<leader>t", group = "Terminal" },
          { "<leader>s", group = "Search" },
          { "<leader>t", group = "Terminal" },
          { "<leader>q", group = "Quit" },
          { "<leader>u", group = "UI" },
          { "<leader>x", group = "Diagnostics/Quickfix" },
          { " ", group = "Leaderkey" },
          { "[", group = "Previous" },
          { "]", group = "Next" },
          { "z", group = "Fold" },
          { "\\", group = "Toggle local options" },
          {
            "<leader>b",
            group = "Buffer",
            expand = function()
              return require("which-key.extras").expand.buf()
            end,
          },
          {
            "<leader>w",
            group = "Windows",
            proxy = "<c-w>",
            expand = function()
              return require("which-key.extras").expand.win()
            end,
          },
          -- better descriptions
          { "gx", desc = "Open with system app" },
          -- Hide non-interesting keys.
          { "<Up>",    hidden = true },
          { "<Down>",  hidden = true },
          { "<Left>",  hidden = true },
          { "<Right>", hidden = true },
          { "<S-Up>",    hidden = true },
          { "<S-Down>",  hidden = true },
          { "<S-Left>",  hidden = true },
          { "<S-Right>", hidden = true },
          { "<D-q>", hidden = true },
          {
            "<leader>?",
            function()
              require("which-key").show({ global = false })
            end,
            desc = "Buffer Local Keymaps (which-key)",
          },
        },
      },
    } --opts
  } -- whickey
}
