
-- Helper to set autogroup with prefix.
function augroup(name)
  return vim.api.nvim_create_augroup("Custom_" .. name, { clear = true })
end

-- For Neovim Ui Modifier - VS Code plugin. That is needed to be installed.
-- Change VS Code theme colors based on Neovim mode.
-- Made changes to settings.json to revert after a while.
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

 -- Source vscode.lua
 vim.keymap.set('n', "<leader>fv", function()
   local config_dir = vim.fn.stdpath("config")
   print("Neovim config directory: " .. config_dir)
   dofile(config_dir .. "/lua/plugins/local/vscode.lua")
   vim.notify('sourced')
 end)

