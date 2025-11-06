
return {
  -- EinfachToll/DidYouMean: Vim plugin which asks for the right file to open
  -- https://github.com/EinfachToll/DidYouMean
  {
    "EinfachToll/DidYouMean"
  },

  -- Flash. https://github.com/folke/flash.nvim
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "ö", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "Ö", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-ö>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },

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
    "OXY2DEV/markview.nvim",
    -- Do not lazy load this plugin as it is already lazy-loaded.
    lazy = false,
    -- Ensure theme loads after this plugin.
    dependencies = { "Mofiqul/vscode.nvim" },
    -- Completion for `blink.cmp`
    -- dependencies = { "saghen/blink.cmp" },
  },

  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",         -- required
      "sindrets/diffview.nvim",        -- optional - Diff integration

      -- Only one of these is needed.
      -- "nvim-telescope/telescope.nvim", -- optional
      -- "ibhagwan/fzf-lua",              -- optional
      -- "nvim-mini/mini.pick",           -- optional
      "folke/snacks.nvim",                -- optional
    },
    lazy = true,
    opts = {
      graph_style = "unicode", -- or "ascii", "none"
    },
    keys = {
      { "<Leader>gg", "<cmd>Neogit<CR>",  mode = "n", desc = 'Toggle Neogit' },
      -- { "<Leader>gg", "<cmd>Neogit kind=floating<CR>",  mode = "n", desc = 'Toggle Neogit' },
    },
    cmd = { "Neogit" },
  },

  -- lambdalisue/vim-suda: 🥪 An alternative sudo.vim for Vim and Neovim,
  -- limited support sudo in Windows - https://github.com/lambdalisue/vim-suda
  {
    'lambdalisue/vim-suda',
    cmd = { 'SudaRead', 'SudaWrite' }
  },

  -- rickhowe/wrapwidth: Wraps long lines virtually at a specific column
  -- https://github.com/rickhowe/wrapwidth
  {
    "rickhowe/wrapwidth",
    -- ft = { "markdown", "txt" }
  }

  -- Doesn't work like this.
  -- {
  --   "chrisbra/Recover.vim",
  --   config = function()
  --     require('recover.vim').setup()
  --   end
  -- }
}
