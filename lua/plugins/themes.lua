
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
      vim.cmd.colorscheme("neoceanic")
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
