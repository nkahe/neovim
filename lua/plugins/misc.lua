
-- Misc short plugin specs.

-- if true then return {} end

return {

 {
    'AbdelrahmanDwedar/awesome-nvim-colorschemes',
    enabled = false
 },

  -- Forked from wsdjeg/ctrlg.nvim to better suit with narrower notifications.
  -- https://github.com/wsdjeg/ctrlg.nvim
  -- Paths need to be in this format.
  {
    name = "ctrlg",
    dir = vim.fn.stdpath("config") .. "/lua/plugins/local",
    keys = {
      { "<C-g>", function() require("plugins.local.ctrlg").display() end, mode = "n",
      desc = "Display project, CWD, file path", silent = true }
    },
  },


  -- Set tab title dynamically for Yakuake terminal.
  {
    name = "yakuake-titles",
    dir = vim.fn.stdpath("config") .. "/lua/plugins/local",
    event = "VeryLazy",
    config = function()
      require("plugins.local.yakuake-titles")
    end,
  },

  -- EinfachToll/DidYouMean: Vim plugin which asks for the right file to open
  -- https://github.com/EinfachToll/DidYouMean
  {
    "EinfachToll/DidYouMean",

    -- Prevent plugin firing by Snacks.scratch.
    config = function ()
      vim.api.nvim_create_autocmd("User", {
        pattern = "SnacksScratchOpened",
        callback = function(ev)
          -- Disable DidYouMean by marking the buffer as "existing"
          vim.b[ev.buf].didyoumean_disable = true
        end,
      })

      -- prevent running on buffers with the variable
      vim.api.nvim_create_autocmd("BufNewFile", {
        callback = function(ev)
          if vim.b[ev.buf].didyoumean_disable then
            return true  -- stopping DidYouMean
          end
        end,
      })
    end
  },

  -- https://github.com/folke/flash.nvim
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "ö", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "Ö", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      -- r is for replace with register.
      -- { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      -- { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-ö>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },

  -- LSP renaming with immediate visual feedback
  -- https://github.com/smjonas/inc-rename.nvim
  {
    "smjonas/inc-rename.nvim",
    opts = {},
    keys = {
      { "<F2>", function()
          return ":IncRename " .. vim.fn.expand("<cword>")
        end,
        mode = "n", expr = true, desc = "Rename symbol",
      },
    },
  },

  {
    "bagohart/vim-insert-append-single-character",
    init = function()
      vim.g.InsertSingleCharacter_show_prompt_message = 0
    end,
    keys = {
      -- For nordic and german keyboard layouts.
      { "ä", "<Plug>(ISC-insert-at-cursor)", mode = "n", desc = "Insert character before cursor" },
      { "Ä", "<Plug>(ISC-append-at-cursor)", mode = "n", desc = "Insert character after cursor" },
    },
    vscode = true  -- Enable in vscode
  },

  -- https://github.com/yousefhadder/markdown-plus.nvim?tab=readme-ov-file
  {
    "yousefhadder/markdown-plus.nvim",
    ft = "markdown",
    opts = {
      table = {
        keymaps = { prefix = "<Leader>T" }
      }
    }
  },

  {
    "OXY2DEV/markview.nvim",
    enabled = true,
    -- Do not lazy load this plugin as it is already lazy-loaded.
    lazy = false,
    -- Ensure theme loads after this plugin.
    dependencies = { "Mofiqul/vscode.nvim" },
    -- Completion for `blink.cmp`
    -- dependencies = { "saghen/blink.cmp" },
    keys = {
      { "<Leader>um", "<cmd>Markview Toggle<CR>", mode = "n", desc = "Toggle markdown rendering" }
    }
  },

  -- Search and replace in the current buffer with incremental preview,
  -- a convenient UI, and modern regex syntax.
  -- https://github.com/chrisgrieser/nvim-rip-substitute
  {
    "chrisgrieser/nvim-rip-substitute",
    cmd = "RipSubstitute",
    keys = {
      {
        "<leader>fS",
        function() require("rip-substitute").sub() end,
        mode = { "n", "x" },
        desc = " rip substitute",
      },
    },
    opts = {
      regexOptions = {
        startWithFixedStringsOn = true,
        startWithIgnoreCase = true,
      },
      keymaps = { -- normal mode (if not stated otherwise)
        abort = "q",
        confirm = "<CR>",
        insertModeConfirm = "<C-CR>",
        prevSubstitutionInHistory = "<Up>",
        nextSubstitutionInHistory = "<Down>",
        toggleFixedStrings = "<M-r>", -- ripgrep's `--fixed-strings`
        toggleIgnoreCase = "<M-c>", -- ripgrep's `--ignore-case`
        openAtRegex101 = "R",
        showHelp = "?",
      },
    },
  },

  -- Improves comment syntax, lets Neovim handle multiple types of comments for
  -- a single language, and relaxes rules for uncommenting.
  {
    "folke/ts-comments.nvim",
    event = "VeryLazy",
    opts = {},
  },

  -- An alternative sudo.vim for Vim and Neovim,
  -- limited support sudo in Windows - https://github.com/lambdalisue/vim-suda
  {
    'lambdalisue/vim-suda',
    cmd = { 'SudaRead', 'SudaWrite' }
  },

  -- Wraps long lines virtually at a specific column
  -- https://github.com/rickhowe/wrapwidth
  {
    "rickhowe/wrapwidth",
    enabled = true,
    ft = { "markdown", "txt" }
  },

  -- Doesn't work like this.
  {
    "chrisbra/Recover.vim",
   event = { "VeryLazy" },
   config = function()
    -- require('recover.vim').setup()
   end
   }
}
