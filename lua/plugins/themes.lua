
if vim.g.vscode then
  return {}
end

-- vim.o.background = "light"

if os.getenv("COLOR_SCHEME") == "light" then
  return {
    "EdenEast/nightfox.nvim",
    enabled = true,
    lazy = false,
    priority = 1000,
    config = function()
      local groups = {
        dayfox = {
          CursorLine = { bg = "#f5f1ed" }
        }
      }
      require("nightfox").setup({ groups = groups })
      vim.cmd("colorscheme dayfox")
    end,
  }
end

return {
  {
    name = "Neoceanic",
    enabled = true,
    priority = 1000,
    dir = vim.fn.stdpath("config") .. "/lua/plugins/local/neoceanic",
    opts = {
      terminal_colors = false,
    },
    config = function(_, opts)
      require("neoceanic").setup(opts)
      vim.cmd.colorscheme("neoceanic")
    end,
  },

  {
    'roflolilolmao/oceanic-next.nvim',
    enabled = false,
    priority = 1000,
    config = function()
      vim.cmd('colorscheme OceanicNext')
    end,
  },

  {
    "nvchad/base46",
    enabled = false,
    priority = 1000,
    lazy = false,
    build = function()
      require("base46").load_all_highlights()
    end,
  },

}
