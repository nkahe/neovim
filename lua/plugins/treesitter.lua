
-- Treesitter

-- Install parsers for selected languages. Enable highlighting, indentation.
-- Configs for older master branch wont work.

return {
  {
    'nvim-treesitter/nvim-treesitter',
    enabled = true,
    lazy = vim.fn.argc(-1) == 0, -- load treesitter immediately when opening a file from the cmdline
    event = { "BufReadPost", "BufNewFile", "VeryLazy" },
    branch = 'main',  -- Master branch is frozen but still default.
    build = ":TSUpdate",
    config = function()
      local parsers = {
        "bash",
        "css",
        "diff",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "jsonc",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "printf",
        "query",
        "regex",
        "todotxt",
        "toml",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
        "zsh"
      }
 
      vim.defer_fn(function()
        require("nvim-treesitter").install(parsers)
      end, 1000)
      require("nvim-treesitter").update()

      -- auto-start highlights & indentation
      vim.api.nvim_create_autocmd("FileType", {
        desc = "Enable treesitter features",
        callback = function(ctx)
          -- highlights
          local hasStarted = pcall(vim.treesitter.start) -- errors for filetypes with no parser

          -- indent
          local noIndent = {}
          if hasStarted and not vim.list_contains(noIndent, ctx.match) then
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

            -- folding
            vim.wo.foldmethod = "expr"
            vim.wo.foldexpr   = "v:lua.vim.treesitter.foldexpr()"
          end
        end,
      })

      vim.keymap.set("n", "<Leader>di", "<cmd>InspectTree<CR>", { desc = "Inspect Treesitter tree" })

    end
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
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
      map("]d", function() move.goto_next("@conditional.outer") end, "Next conditional")
      map("[d", function() move.goto_previous("@conditional.outer") end, "Previous conditional")
    end,
  },

}
