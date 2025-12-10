
if vim.g.vscode then
  return {}
end

return {

 {
    'AbdelrahmanDwedar/awesome-nvim-colorschemes',
    enabled = false
 },

  {
    "nvchad/base46",
    enabled = true,
    lazy = false,
    build = function()
      require("base46").load_all_highlights()
    end,
  },

  {
    "rebelot/kanagawa.nvim",
    enabled = false,
    config = function()
      vim.cmd('colorscheme kanagawa')
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

  { "nvzone/volt",
    enabled = false,
    lazy = true
  },

  {
    "nvzone/minty",
    enabled = false,
    cmd = { "Shades", "Huefy" },
    config = function ()
      vim.keymap.net('n', '<Leader>uH', '<mc>Huefy<CR>', { desc = "Huefy" })
    end
  },

  {
    "navarasu/onedark.nvim",
    enabled = false,
    -- priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require('onedark').setup {
        style = 'darker'
      }
      -- Enable theme
      -- require('onedark').load()
    end
  }
}
