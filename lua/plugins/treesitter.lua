
-- Treesitter

-- Install parsers for selected languages. Enable highlighting, indentation.

-- Configs for older master branch wont work.

return {
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    branch = 'main',  -- Master branch is frozen but still default.
    build = ":TSUpdate",
    config = function()

      -- Zsh grammar for tree-sitter.
      -- https://github.com/georgeharker/tree-sitter-zsh
      --In addition to enabling treesitter for zsh files.
      -- vim.api.nvim_create_autocmd("User", {
      --   pattern = "TSUpdate",
      --   callback = function()
      --     require("nvim-treesitter.parsers").zsh = {
      --       install_info = {
      --         generate_from_json = false, -- only needed if repo does not contain `src/grammar.json` either
      --         queries = 'nvim-queries', -- also install queries from given directory
      --         url = "https://github.com/georgeharker/tree-sitter-zsh",
      --       },
      --       tier = 3,
      --     }
      --   end,
      -- })

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

     -- -- make sure this runs after nvim-treesitter is loaded
     --  local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
     --
     --  if not parser_config.zsh then
     --    parser_config.zsh = {
     --      install_info = {
     --        url = "https://github.com/georgeharker/tree-sitter-zsh",
     --        files = { "src/parser.c" },
     --        branch = "main",
     --        generate_from_json = false,
     --      },
     --      tier = 3,
     --    }
     --  end

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
