
return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = ":TSUpdate",
  event = { "BufReadPre", "BufNewFile" },
  cmd = { "TSUpdate", "TSInstall", "TSUninstall", "TSLog" },
  opts = {
    highlight = { enable = true },
    indent = { enable = true },
    folds = { enable = true },
    ensure_installed = {
      "bash",
      "c",
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
      "toml",
      "vim",
      "vimdoc",
      "xml",
      "yaml",
    },
  },
  config = function(_, opts)
    local ok, configs = pcall(require, "nvim-treesitter.configs")
    if not ok then
      -- Treesitter plugin not ready → just skip
      vim.schedule(function()
        vim.defer_fn(function()
          -- Try again once Lazy finished loading everything
          local ok2, c2 = pcall(require, "nvim-treesitter.configs")
          if ok2 then
            c2.setup(opts)
          end
        end, 100)
      end)
      return
    end

    configs.setup(opts)

    -- Auto-install any missing parsers
    local parsers = require("nvim-treesitter.parsers")
    local install = vim.tbl_filter(function(lang)
      return not parsers.has_parser(lang)
    end, opts.ensure_installed or {})

    if #install > 0 then
      vim.schedule(function()
        vim.cmd("TSInstallSync " .. table.concat(install, " "))
      end)
    end

    -- Don’t try to start Treesitter for unsupported filetypes
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("treesitter_safe_start", { clear = true }),
      callback = function(ev)
        local ft = ev.match
        local lang = vim.treesitter.language.get_lang(ft)
        if not lang or not parsers.has_parser(lang) then
          return
        end
        pcall(vim.treesitter.start, ev.buf, lang)
      end,
    })
  end,
}
