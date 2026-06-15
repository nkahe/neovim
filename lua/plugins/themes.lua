
if vim.g.vscode then
  return {}
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
      if vim.o.background ~= "light" then
        vim.cmd.colorscheme("neoceanic")
      end
    end,
  },

  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      if vim.o.background == "light" then
        vim.cmd.colorscheme("tokyonight-day")
      end
    end,
  },

  {
  'AbdelrahmanDwedar/awesome-nvim-colorschemes',
  enabled = false,
  priority = 1000,
  config = function()
    if vim.o.background == "light" then
      vim.cmd.colorscheme("github_light")
    end
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
