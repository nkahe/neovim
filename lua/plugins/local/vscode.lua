
if not vim.g.vscode then
  return {}
end

-- Helper to set autogroup with prefix.
-- function augroup(name)
--   return vim.api.nvim_create_augroup("Custom_" .. name, { clear = true })
-- end

-- Neovim Ui Modifier plugin. Change theme colors based on Neovim mode.
function SetCursorLineNrColorInsert(mode)
  if mode == "i" then
    vim.fn.VSCodeNotify("nvim-theme.insert")  -- Insert mode: blue
  elseif mode == "r" then
    vim.fn.VSCodeNotify("nvim-theme.replace") -- Replace mode: red
  end
end

vim.cmd([[
  augroup CursorLineNrColorSwap
    autocmd!
    autocmd ModeChanged *:[vV\x16]* call VSCodeNotify('nvim-theme.visual')
    autocmd ModeChanged *:[R]* call VSCodeNotify('nvim-theme.replace')
    " autocmd InsertEnter * call VSCodeNotify('nvim-theme.insert')
    autocmd InsertEnter * call SetCursorLineNrColorInsert(v:insertmode)
    autocmd InsertLeave * call VSCodeNotify('nvim-theme.normal')
    autocmd CursorHold * call VSCodeNotify('nvim-theme.normal')
    autocmd ModeChanged [vV\x16]*:* call VSCodeNotify('nvim-theme.normal')
  augroup END
]])

-- Compile and apply Base46 theme when changes are saved.
-- vim.api.nvim_create_autocmd("BufWritePost", {
--   pattern = "vscode.lua",
--   group = augroup('source_vscode_settings'),
  -- callback = function()
vim.keymap.set('n', "<leader>fv", function()
    local config_dir = vim.fn.stdpath("config")
    print("Neovim config directory: " .. config_dir)
    dofile(config_dir .. "/lua/plugins/local/vscode.lua")
    vim.notify('sourced')
  end)
-- })

-- Keymaps

-- vim.keymap.set({ 'n', 'x' }, '<Space>', function()
--     vim.fn.VSCodeNotify('whichkey.show')
--   end, { silent = true, desc = "Show WhichKey" })

-- vim.keymap.set('n', '<leader><leader>', function()
--     vim.fn.VSCodeNotify('workbench.action.quickOpen')
--   end, { desc = 'QuickOpen' })

vim.keymap.set("n", "<leader><space>", "<cmd>Find<cr>")
vim.keymap.set("n", "<leader>,", "<cmd>Find<cr>")

  -- Map <Leader>F to search for text in files (like Ctrl+Shift+F)
  vim.keymap.set("n", "<leader>/", function()
    vim.fn.VSCodeCall("workbench.action.findInFiles")
  end, { desc = "Search Text in Files" })

  vim.keymap.set("n", "<leader>bd", function()
    vim.fn.VSCodeCall("workbench.action.closeActiveEditor")
  end, { desc = "Close Current File" })

  vim.keymap.set({ 'n', 'x' }, '<Leader>e', function()
    vim.fn.VSCodeNotify('workbench.action.toggleSidebarVisibility')
  end, { silent = true, desc = "Toggle Sidebar Visibility" })

  vim.keymap.set({ 'n', 'x' }, '<Space>fr', function()
    vim.fn.VSCodeNotify('workbench.action.openRecent')
  end, { silent = true, desc = "Recent files" })

  vim.keymap.set({ 'n', 'x' }, '<Space>fn', function()
    vim.fn.VSCodeNotify('welcome.showNewFileEntries')
  end, { silent = true, desc = "New file" })

  for _, lhs in ipairs({ "<leader>ft", "<leader>fT" }) do
    vim.keymap.set("n", lhs, function()
      vim.fn.VSCodeCall("workbench.action.terminal.toggleTerminal")
    end)
  end

  vim.keymap.set("n", "<leader>sg", function()
    vim.fn.VSCodeCall("workbench.action.findInFiles")
  end, { desc = "Search Text in Files" })

  vim.keymap.set("n", "<leader>ss", function()
    vim.fn.VSCodeCall("workbench.action.gotoSymbol")
  end)

  vim.keymap.set("n", "<leader>sS", function()
    vim.fn.VSCodeCall("workbench.action.showAllSymbols")
  end, { desc = "Search Symbols in Workspace" })

  vim.keymap.set("n", "<Leader>qq", function()
    vim.fn.VSCodeCall("workbench.action.quit")
  end, { desc = "Quit VSCode" })

  -- -- Map <leader>bn to focus the next editor in the split
  -- vim.keymap.set("n", "<C-l>", function()
  --   vim.fn.VSCodeCall("workbench.action.nextEditorInGroup")
  -- end, { desc = "Next Editor in Split" })
  --
  -- -- Map <leader>bp to focus the previous editor in the split
  -- vim.keymap.set("n", "<C-h>", function()
  --   vim.fn.VSCodeCall("workbench.action.previousEditorInGroup")
  -- end, { desc = "Previous Editor in Split" })

  -- C-j and C-k are used by VSCode.
  vim.keymap.set("n", "<C-h>", function()
    vim.fn.VSCodeCall("workbench.action.navigateLeft")
  end, { desc = "Focus Left Split" })

  vim.keymap.set("n", "<C-l>", function()
    vim.fn.VSCodeCall("workbench.action.navigateRight")
  end, { desc = "Focus Right Split" })

  -- Map H to switch to the previous tab (VSCode editor)
  vim.keymap.set("n", "H", function()
    vim.fn.VSCodeCall("workbench.action.previousEditor")
  end, { desc = "Previous Tab" })

  -- Map L to switch to the next tab (VSCode editor)
  vim.keymap.set("n", "L", function()
    vim.fn.VSCodeCall("workbench.action.nextEditor")
  end, { desc = "Next Tab" })

  -- Map Alt+j to move line down
  vim.keymap.set("n", "<A-j>", function()
    vim.fn.VSCodeCall("editor.action.moveLinesDownAction")
  end, { desc = "Move Line Down" })

  -- Map Alt+k to move line up
  vim.keymap.set("n", "<A-k>", function()
    vim.fn.VSCodeCall("editor.action.moveLinesUpAction")
  end, { desc = "Move Line Up" })

  vim.keymap.set("v", "<M-j>", function()
    vim.fn.VSCodeCall("editor.action.moveLinesDownAction")
  end, { desc = "Move Line Down" })

  vim.keymap.set("v", "<M-k>", function()
    vim.fn.VSCodeCall("editor.action.moveLinesUpAction")
  end, { desc = "Move Line Up" })

-- Add other plugins with VSCode-specific configs. Enabled plugins are
-- defined in lazy.lua.
return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { highlight = { enable = false } },
  },

  -- {
  --   "snacks.nvim",
  --   opts = {
  --     bigfile = { enabled = false },
  --     dashboard = { enabled = false },
  --     indent = { enabled = false },
  --     input = { enabled = false },
  --     notifier = { enabled = false },
  --     picker = { enabled = false },
  --     quickfile = { enabled = false },
  --     scroll = { enabled = false },
  --     statuscolumn = { enabled = false },
  --   },
  -- }
  {
    "nvim-mini/mini.nvim",
    version = false,
    config = function()
      require("mini.ai").setup()
      require("mini.basics").setup()
      require("mini.comment").setup()
      -- NOTE: Alt+hjl is interpreted by VSCode.
      require("mini.operators").setup()
      require("mini.move").setup()
      -- require("mini.pairs").setup()
      require("mini.surround").setup()
    end,
  },
}
