
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
      { "<Leader>gg", "<cmd>Neogit kind=floating<CR>",  mode = "n", desc = 'Toggle Neogit' },
    }
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
