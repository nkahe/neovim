
-- UI related plugins.

return {

-- Bufferline -----------------------------------------------------------------
  {
    'akinsho/bufferline.nvim',
    version = "*", dependencies = 'nvim-tree/nvim-web-devicons',
    opts = {
      options = {
        always_show_bufferline = false,
      }
    },
  },

-- Lualine --------------------------------------------------------------------
  {
    "nvim-lualine/lualine.nvim",
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
      -- PERF: we don't need this lualine require madness 🤷
      local lualine_require = require("lualine_require")
      lualine_require.require = require

      vim.o.laststatus = vim.g.lualine_laststatus

      local off_white = "#d4d4d4"
      local opts = {
        options = {
          theme = "auto",
          globalstatus = vim.o.laststatus == 3,
          disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" } },
          -- Get rid off '' and '' which color can't be changed.
          component_separators = { left = ' ', right = ' '},
        },
        sections = {
          lualine_a = {
            { "mode", color = { fg = '#000000' } },
          },
          lualine_b = {
            { "branch", color = { fg = off_white } },
          },
          -- lualine_b = { 'branch', 'diff', 'diagnostics' },  -- Default
          lualine_c = {
            { 'filename', color = { fg = off_white } },
          },
          lualine_x = {
            { "encoding", color = { fg = off_white } },
            { "fileformat", color = { fg = off_white } },
            { "filetype", color = { fg = off_white } },
          },
          lualine_y = {
            { "progress", separator = " ", padding = { left = 1, right = 0 } },
            { "location", padding = { left = 0, right = 1 } },
          },
          lualine_z = {
            {
            function()
              return " " .. os.date("%R")
            end,
              color = { fg = '#000000' }
            }
          },
        },
        extensions = { "neo-tree", "lazy", "fzf" },
      }
      return opts
    end,
  }
}
