
-- Treesitter

-- Install parsers for selected languages. Enable highlighting, indentation.
-- Configs for older master branch wont work.

return {
  {
    'nvim-treesitter/nvim-treesitter',
    -- lazy = false,
    event = { "BufReadPost", "BufNewFile", "VeryLazy" },
    cmd = { "TSUpdate", "TSInstall", "TSLog", "TSUninstall" },
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

    end, -- config
  }
}
