-- Misc short plugin specs.

-- if true then return {} end
return {
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
    config = function() require("plugins.local.yakuake-titles") end,
  },

  -- EinfachToll/DidYouMean: Vim plugin which asks for the right file to open
  -- https://github.com/EinfachToll/DidYouMean
  -- Didn't work with snacks scratch buffer.
  { "EinfachToll/DidYouMean", enabled = false },

  -- https://github.com/folke/flash.nvim
  {
    "folke/flash.nvim",
    opts = {},
    keys = {
      { "gj", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Jump" },
      { "gJ", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Jump Treesitter" },
      -- r is for replace with register.
      -- { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      -- { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      -- { "<c-ö>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },

  {
    "FylerOrg/fyler.nvim",
    branch = "stable",  -- Use stable branch for production
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    lazy = false, -- Necessary for `default_explorer` to work properly
    init = function()

      vim.keymap.set("n", "<leader>e", function()
        require("fyler").toggle({ kind = "split_left_most" })
      end, { desc = "Explore sidebar", silent = true })

      vim.keymap.set("n", "-", function()
        require("fyler").toggle({})
      end, { desc = "Explore", silent = true })

    end,
    opts = {
      integrations = {
        -- Use nvim-web-devicons as the icon provider
        icon = 'nvim_web_devicons'
      },
      kind_presets = {
        -- Don't split by percentage.
        split_left_most = { width = "40" },
      },
    }
  },

  -- https://github.com/MagicDuck/grug-far.nvim
  {
    "MagicDuck/grug-far.nvim",
    opts = { headerMaxWidth = 80 },
    cmd  = { "GrugFar", "GrugFarWithin" },
    keys = {
      {
        "<leader>sr",
        function()
          local grug = require("grug-far")
          local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
          grug.open({
            -- Don't add buffer list, delete buffer when window closed.
            transient = true,
            -- Prefill with filetype of current buffer.
            prefills = {
              filesFilter = ext and ext ~= "" and "*." .. ext or nil,
            },
          })
        end,
        mode = { "n", "x" },
        desc = "Search and Replace",
      },
    },
  },

  -- Renaming with immediate visual feedback (LSP)
  -- https://github.com/smjonas/inc-rename.nvim
  {
    "smjonas/inc-rename.nvim",
    cmd  = { "IncRename" },
    opts = {},
    keys = {
      { "<F2>", function() return ":IncRename " .. vim.fn.expand("<cword>") end,
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

  -- provides modern markdown editing capabilities, implementing features found
  -- in popular editors.
  -- https://github.com/yousefhadder/markdown-plus.nvim?tab=readme-ov-file
  {
    "yousefhadder/markdown-plus.nvim",
    enabled = true,
    ft = "markdown",
    opts = {
      features = {
        list_management = true,
      },
      table = {
        keymaps = { prefix = "<Leader>T" }
      }
    }
  },

  -- markdown preview
  -- https://github.com/iamcco/markdown-preview.nvim
  {
    "iamcco/markdown-preview.nvim",
    enabled = true,
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && npm install",
    init = function() vim.g.mkdp_filetypes = { "markdown" } end,
    ft = { "markdown" },
    keys = {
      { "<Leader>mP", "<cmd>MarkdownPreviewToggle<CR>", mode = "n", desc = "Toggle preview" }
    }
  },


{
    "preservim/vim-pencil",
    enabled = false,
    ft = { "markdown", "text" },
    cmd = { "Pencil", "NoPencil", "TogglePencil" },
    init = function()
      vim.g["pencil#wrapModeDefault"] = "soft"
      vim.g["pencil#textwidth"] = 90
      vim.g["pencil#conceallevel"] = 3
      vim.g["pencil#autoformat"] = 0
    end,
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
        startWithFixedStrings = true,
        startWithIgnoreCase = true,
      },
      keymaps = { -- normal mode (if not stated otherwise)
        abort = "q",
        confirmAndSubstituteInBuffer = "<CR>",
        insertModeConfirmAndSubstituteInBuffer = "<C-CR>",
        prevSubstitutionInHistory = "<Up>",
        nextSubstitutionInHistory = "<Down>",
        toggleFixedStrings = "<M-r>", -- ripgrep's `--fixed-strings`
        toggleIgnoreCase   = "<M-c>", -- ripgrep's `--ignore-case`
        openAtRegex101 = "R",
        showHelp = "?",
      },
    },
  },

  {
    "MunsMan/kitty-navigator.nvim",
    event = "VeryLazy",
    cond = function() return vim.env.KITTY_PID end,
    build = {
      "cp navigate_kitty.py ~/.config/kitty",
      "cp pass_keys.py ~/.config/kitty",
    },
    opts = { keybindings = {} },
    -- Add terminal mode.
    keys = {
        {"<C-h>", function()require("kitty-navigator").navigateLeft()end,  desc = "Move left a Split",  mode = {"n", "t", "i"}},
        {"<C-j>", function()require("kitty-navigator").navigateDown()end,  desc = "Move down a Split",  mode = {"n", "t"}},
        {"<C-k>", function()require("kitty-navigator").navigateUp()end,    desc = "Move up a Split",    mode = {"n", "t"}},
        {"<C-l>", function()require("kitty-navigator").navigateRight()end, desc = "Move right a Split", mode = {"n", "t", "i"}},
    },
  },

  -- An alternative sudo.vim for Vim and Neovim,
  -- limited support sudo in Windows - https://github.com/lambdalisue/vim-suda
  { 'lambdalisue/vim-suda', cmd = { 'SudaRead', 'SudaWrite' } },

  { "phrmendes/todotxt.nvim",
    opts = {
      todotxt = vim.env.HOME .. "/.todo/todo.txt",
      donetxt = vim.env.HOME .. "/.todo/done.txt",
      max_priority = "C",
      metadata = {
        tag = { sort = "asc" },
        due = { sort = "asc" },
      },
      ghost_text = {
        enable = false,
        mappings = {
          ["(A)"] = "today",
          ["(B)"] = "tomorrow",
          ["(C)"] = "this week",
        },
      },
    }
  },

  -- View your Neovim configuration insights, history, and heatmaps.
  -- https://github.com/aikhe/wrapped.nvim
  {
    "aikhe/wrapped.nvim",
    dependencies = { "nvzone/volt" },
    cmd = { "WrappedNvim" },
    opts = {},
  },

  -- Wraps long lines virtually at a specific column.
  -- https://github.com/rickhowe/wrapwidth
  {
    "nkahe/wrapwidth",
    -- name = "wrapwidth",
    -- dir = vim.fn.stdpath("config") .. "/lua/plugins/local/wrapwidth",
    enabled = true,
    ft = { "markdown", "txt" }
  },

  -- Adds a diff option when Vim finds a swap file.
  -- https://github.com/chrisbra/Recover.vim
  -- Not made with Lua so config func is needed.
  { "chrisbra/Recover.vim", config = function() end }
}
