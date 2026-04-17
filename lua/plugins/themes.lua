
if vim.g.vscode then
  return {}
end

return {

  {
    "nvchad/base46",
    enabled = true,
    priority = 1000,
    lazy = false,
    build = function()
      require("base46").load_all_highlights()
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

}
