if not vim.g.vscode then
  return {}
end

-- NOTE: Alt -keybindings  are interpreted by VSCode and defined in it's
-- config User/keybindings.json.

-- Helper to set autogroup with prefix.
-- function augroup(name)
--   return vim.api.nvim_create_augroup("Custom_" .. name, { clear = true })
-- end

-- For Neovim Ui Modifier - VS Code plugin. That is needed to be installed.
-- Change VS Code theme colors based on Neovim mode.
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
    autocmd InsertEnter * call v:lua.SetCursorLineNrColorInsert(v:insertmode)
    autocmd InsertLeave * call VSCodeNotify('nvim-theme.normal')
    autocmd CursorHold * call VSCodeNotify('nvim-theme.normal')
    autocmd ModeChanged [vV\x16]*:* call VSCodeNotify('nvim-theme.normal')
  augroup END
]])

-- Source 
vim.keymap.set('n', "<leader>fv", function()
    local config_dir = vim.fn.stdpath("config")
    print("Neovim config directory: " .. config_dir)
    dofile(config_dir .. "/lua/plugins/local/vscode.lua")
    vim.notify('sourced')
  end)
-- })

-- Keymaps --------------------------------------------------------------------

-- vim.keymap.set({ 'n', 'x' }, '<Space>', function()
--     vim.fn.VSCodeNotify('whichkey.show')
--   end, { silent = true, desc = "Show WhichKey" })

vim.keymap.set('n', '<Leader><Space>', function()
  vim.fn.VSCodeNotify('workbench.action.showCommands')
end, { silent = true, desc = "Command palette" })

vim.keymap.set('n', '<Leader>ff', function()
  vim.fn.VSCodeNotify('workbench.action.quickOpen')
end, { silent = true, desc = "Search file" })

vim.keymap.set("n", "<leader>,", "<leader>ff",
  { desc = "Search file", remap = true })

  -- Map <Leader>F to search for text in files (like Ctrl+Shift+F)
  vim.keymap.set("n", "<leader>fg", function()
    vim.fn.VSCodeCall("workbench.action.findInFiles")
  end, { desc = "Search Text in Files" })

  vim.keymap.set("n", "<leader>/", "<leader>fg",
  { desc = "Search Text in Files", remap = true })

  vim.keymap.set({ 'n', 'x' }, '<Leader>fr', function()
    vim.fn.VSCodeNotify('workbench.action.openRecent')
  end, { silent = true, desc = "Recent files" })

  vim.keymap.set("n", "<leader>bd", function()
    vim.fn.VSCodeCall("workbench.action.closeActiveEditor")
  end, { desc = "Close Current File" })

  vim.keymap.set({ 'n', 'x' }, '<Leader>e', function()
    vim.fn.VSCodeNotify('workbench.action.toggleSidebarVisibility')
  end, { silent = true, desc = "Toggle Sidebar Visibility" })

  vim.keymap.set({ 'n', 'x' }, '<Leader>fn', function()
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

-- Plugins with VSCode-specific configs. Enabled plugins are defined in lazy.lua.
return {
  {
    "nvim-treesitter/nvim-treesitter",
    -- VSCode has it's own hilight.
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

  -- Use subset of mini plugins.
}
