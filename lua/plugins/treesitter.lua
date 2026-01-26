
-- Install parsers for selected languages and enable Treesitter features.
-- https://github.com/nvim-treesitter/nvim-treesitter/tree/main
-- NOTE: make sure to read main branch readme.
-- https://github.com/MeanderingProgrammer/treesitter-modules.nvim
return {
  {
    'nvim-treesitter/nvim-treesitter',
    enabled = true,
    -- load treesitter immediately when opening a file from the cmdline.
    -- NOTE: Treesitter doesn't officially support lazy loading.
    lazy = vim.fn.argc(-1) == 0,
    event = { "BufReadPost", "BufNewFile", "VeryLazy" },
    branch = 'main',  -- Master branch is frozen but still default.
    build = ":TSUpdate",
    config = function()
      local parsers = {
        -- Included by defaults
        "c",
        "lua",
        "markdown",
        "query", -- Treesitter
        "vim",
        "vimdoc",
        -- Added
        "bash",
        "css",
        "diff",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "luadoc",
        "luap",
        "markdown_inline",
        "printf",
        "regex",
        "todotxt",
        "toml",
        "typescript",
        "xml",
        "yaml",
        "zsh"
      }

      -- Install above parsers if they are missing.
      vim.defer_fn(function()
        require('nvim-treesitter').install(parsers)
      end, 1000)

      local augroup = vim.api.nvim_create_augroup

      -- auto-start highlights & indentation
      vim.api.nvim_create_autocmd("FileType", {
        group = augroup("Custom_enable_treesitter_features", {}),
        callback = function(args)
          local buf = args.buf
          local filetype = args.match

          -- checks if a parser exists for the current language
          local language = vim.treesitter.language.get_lang(filetype) or filetype
          if not vim.treesitter.language.add(language) then
            return
          end

          -- highlights
          -- local hasStarted = pcall(vim.treesitter.start(buf, language))
          vim.treesitter.start(buf, language)

          -- local noIndent = {}
          -- if hasStarted and not vim.list_contains(noIndent, filetype) then
            -- if hasStarted then
            -- indent
            vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            -- folding
            vim.wo.foldmethod = "expr"
            vim.wo.foldexpr   = "v:lua.vim.treesitter.foldexpr()"
          -- end
        end,
      })

      function map_inspect(keymap)
        vim.keymap.set("n", "<leader>" .. keymap, function()
          vim.treesitter.inspect_tree() vim.api.nvim_input("I")
        end, { desc = "Inspect Treesitter tree" })
      end

      map_inspect('ði')
      map_inspect('uI')

    end
  },

  -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    enabled = true,
    branch = "main",
    dependencies = "nvim-treesitter/nvim-treesitter",
    event = "VeryLazy",
    opts = {
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
      },
    },
    config = function()
      -- Move cursor to position at text object.
      local move = require("nvim-treesitter-textobjects.move")

      local map = function(lhs, rhs, desc)
        vim.keymap.set({"n", "x", "o"}, lhs, rhs, { desc = desc })
      end

      -- Next start
      map("]f", function() move.goto_next_start("@function.outer") end, "Next function start")
      map("]c", function() move.goto_next_start("@class.outer") end, "Next class start")
      map("]o", function() move.goto_next_start("@loop.*") end, "Next loop")
      map("]s", function() move.goto_next_start("@local.scope", "locals") end, "Next scope")
      map("]z", function() move.goto_next_start("@fold", "folds") end, "Next fold")

      -- Next end
      map("]F", function() move.goto_next_end("@function.outer") end, "Next function end")
      map("]C", function() move.goto_next_end("@class.outer") end, "Next class end")

      -- Previous start
      map("[f", function() move.goto_previous_start("@function.outer") end, "Previous function start")
      map("[c", function() move.goto_previous_start("@class.outer") end, "Previous class start")

      -- Previous end
      map("[F", function() move.goto_previous_end("@function.outer") end, "Previous function end")
      map("[C", function() move.goto_previous_end("@class.outer") end, "Previous class end")

      -- Next / Previous (closer)
      -- d is used for diagnostics.
      -- map("]d", function() move.goto_next("@conditional.outer") end, "Next conditional")
      -- map("[d", function() move.goto_previous("@conditional.outer") end, "Previous conditional")

      local ts_repeat_move = require "nvim-treesitter-textobjects.repeatable_move"

      -- Repeat movement with ; and ,
      -- ensure ; goes forward and , goes backward regardless of the last direction
      map(";", ts_repeat_move.repeat_last_move_next)
      map(",", ts_repeat_move.repeat_last_move_previous)
    end,
  },

}
