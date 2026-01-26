
return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = function(_, opts)
    opts.spec = vim.list_extend(opts.spec or {}, {
      {
        mode = { "n", "x" },
        { "<F1>", "<cmd>WhichKey<cr>", desc = "WhichKey (global)" },
        { "gs", group = "Surround" },
        { "<leader><tab>", group = "Tabs" },
        { "<leader>a", group = "AI" },
        { "<leader>c", group = "Code" },
        { "<leader>ð", group = "Debug" },
        { "<leader>ðp", group = "Profiler" },
        { "<leader>f", group = "File/Find" },
        { "<leader>g", group = "Git" },
        { "<leader>gh", group = "Hunks" },
        { "<leader>h", group = "Headings" },
        { "<leader>m", group = "Markdown" },
        { "<leader>o", group = "Obsidian", icon = "󱞁" },
        { "<leader>t", group = "Terminal" },
        { "<leader>T", group = "Tables" },
        { "<leader>s", group = "Search" },
        { "<leader>t", group = "Terminal" },
        { "<leader>q", group = "Quit" },
        { "<leader>u", group = "UI" },
        { "<leader>x", group = "Diagnostics/Quickfix" },
        { " ", group = "Leaderkey" },
        { "[", group = "Previous" },
        { "]", group = "Next" },
        { "z", group = "Fold" },
        { "\\", group = "Local commands" },
        {
          "<leader>b",
          group = "Buffer",
          expand = function() return require("which-key.extras").expand.buf() end,
        },
        {
          "<leader>w",
          group = "Windows",
          proxy = "<c-w>",
          expand = function() return require("which-key.extras").expand.win() end,
        },

        -- better descriptions. gx is mapped to mini.operators exchange.
        { "gra", desc = "Code action" },
        { "grn", desc = "Rename" },
        -- gx is used for mini.operators exchange.
        { "gX",  desc = "Open with system app" },
        { "g,",  desc = "Go to newer position in change list" },
        { "g;",  desc = "Go to older position in change list" },
        -- Hide non-interesting keys.
        { "<Up>",    hidden = true },
        { "<Down>",  hidden = true },
        { "<Left>",  hidden = true },
        { "<Right>", hidden = true },
        { "<S-Up>",    hidden = true },
        { "<S-Down>",  hidden = true },
        { "<S-Left>",  hidden = true },
        { "<S-Right>", hidden = true },
        { "<D-q>",     hidden = true },
        {
          "<leader>?",
          function() require("which-key").show({ global = false }) end,
          desc = "Buffer Local Keymaps",
        },
      },
  }) -- opts.spec

  -- Extend key replacements. Make mappings display AltGr-<key> instead of
  -- resulting character.
  opts.replace = opts.replace or {}
  opts.replace.key = vim.list_extend(opts.replace.key or {}, {
    { "ð", "AltGr-d" },
    { "Ð", "AltGr-D" },
    { "ß", "AltGr-b" },
    { "ẞ", "AltGr-B" },
    -- { "š", "AltGr-s" },
  })

  return opts
   end -- opts function

} -- whickey
