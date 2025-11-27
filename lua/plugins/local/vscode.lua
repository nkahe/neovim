
if not vim.g.vscode then
  return {}
end

-- Keymaps

-- vim.keymap.set({ 'n', 'x' }, '<Space>', function()
--     vim.fn.VSCodeNotify('whichkey.show')
--   end, { silent = true, desc = "Show WhichKey" })

vim.keymap.set('n', '<leader><leader>', function()
    vim.fn.VSCodeNotify('workbench.action.quickOpen')
  end, { desc = 'QuickOpen' })

vim.keymap.set({ 'n', 'x' }, '<Space>e', function()
    vim.fn.VSCodeNotify('workbench.action.toggleSidebarVisibility')
  end, { silent = true, desc = "Toggle Sidebar Visibility" })

vim.keymap.set({ 'n', 'x' }, '<Space>fr', function()
    vim.fn.VSCodeNotify('workbench.action.openRecent')
  end, { silent = true, desc = "Recent files" })

vim.keymap.set({ 'n', 'x' }, '<Space>fn', function()
    vim.fn.VSCodeNotify('welcome.showNewFileEntries')
  end, { silent = true, desc = "New file" })


return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { highlight = { enable = false } },
  },
  -- {
  --   "nvim-mini/mini.nvim",
  --   version = false,
  --   config = function()
  --     require("mini.ai").setup()
  --     require("mini.basics").setup()
  --     require("mini.comment").setup()
  --     require("mini.move").setup()
  --     -- require("mini.pairs").setup()
  --     require("mini.surround").setup()
  --   end,
  -- },
  -- Add other plugins with VSCode-specific configs
}
