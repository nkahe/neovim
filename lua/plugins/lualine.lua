-- Based on Lazyvim config with changed theme, colors, file naming, and
-- some components placed slightly differenly.

return {
  "nvim-lualine/lualine.nvim",
  enabled = true,
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  event = "VeryLazy",
  init = function()
    vim.g.lualine_laststatus = vim.o.laststatus
    if vim.fn.argc(-1) > 0 then
      -- set an empty statusline till lualine loads
      vim.o.statusline = " "
    else
      -- hide the statusline on the starter page
      vim.o.laststatus = 0
    end
  end,

  opts = function()
    local lualine_require = require("lualine_require")
    lualine_require.require = require

    vim.o.laststatus = vim.g.lualine_laststatus

    local opts = {
      options = {
        -- Can be set to auto or nil.
        theme = "neoceanic",
        globalstatus = vim.o.laststatus == 3,
        disabled_filetypes = { statusline = {
          "alpha",
          "codediff-explorer",
          "dashboard",
          "fyler",
          "ministarter",
          "snacks_dashboard"
        }},
        -- Get rid off '' and ''.
        component_separators = { left = '', right = ' '},
      },
      extensions = { "avante", "lazy", "neo-tree", "oil", "quickfix", "trouble" },
      -- Sections:   | A | B | C         X | Y | Z |
      sections = {
        lualine_a = { "mode" },

        lualine_b = { 'branch', 'diff' },

        lualine_c = { "diagnostics", {
            -- For terminal show only buffer name and also relative path for other
            -- buffers
            function()
              local buftype = vim.bo.buftype

              if buftype == 'terminal' then
                return vim.fn.expand('%:t')
              end

              return vim.fn.expand('%:.')
            end
          }
        },

        -- Right side -------

        lualine_x = {
          -- stylua: ignore
          { -- normal-mode count prefix (e.g. 5 in 5dw)
            function() return tostring(vim.v.count) end,
            cond = function() return vim.v.count > 0 end,
            color = function() return { fg = Snacks.util.color("Statement") } end,
          },

          -- stylua: ignore
          {  -- command: showcmd
            function() return require("noice").api.status.command.get() end,
            cond = function()
              return package.loaded["noice"] and require("noice").api.status.command.has()
            end,
            color = function() return { fg = Snacks.util.color("Statement") } end,
          },

          -- stylua: ignore
          { -- mode: showmode (@recording messages)
            function() return require("noice").api.status.mode.get() end,
            cond = function()
              return package.loaded["noice"] and require("noice").api.status.mode.has()
            end,
            color = function() return { fg = Snacks.util.color("Constant") } end,
          },

          Snacks.profiler.status(),
          -- stylua: ignore
          { -- Show number of updates available.
            require("lazy.status").updates,
            cond = require("lazy.status").has_updates,
            color = function() return { fg = Snacks.util.color("Special") } end,
          },

          -- { "encoding" },
          { "fileformat",
            color = function() return { fg = Snacks.util.color("Identifier") } end,
          },
          { "filetype",
            color = function() return { fg = Snacks.util.color("Identifier") } end,
          },
        },

        lualine_y = {
          { "progress", separator = " ", padding = { left = 1, right = 0 } },
          { "location", padding = { left = 0, right = 1 } },
        },

        lualine_z = { function() return " " .. os.date("%R") end },
      },
    }
    return opts
  end,
}

