-- Define config table to be able to pass data between scripts
_G.Config = {}

-- User in autocmd to set window title prefix before filename.
_G.Config.windowtitle = 'Custom'

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

 -- base46 themes: put this in your main init.lua file ( before lazy setup )
vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46_cache/"

-- Define custom autocommand group and helper to create an autocommand.
-- Autocommands are Neovim's way to define actions that are executed on events
-- (like creating a buffer, setting an option, etc.).
--
-- See also:
-- - `:h autocommand`
-- - `:h nvim_create_augroup()`
-- - `:h nvim_create_autocmd()`
local gr = vim.api.nvim_create_augroup('custom-config', {})
_G.Config.new_autocmd = function(event, pattern, callback, desc)
  local opts = { group = gr, pattern = pattern, callback = callback, desc = desc }
  vim.api.nvim_create_autocmd(event, opts)
end
-- Source config files.

require("config.lazy")
-- put this after lazy setup 

-- (method 1, For heavy lazyloaders)
 -- dofile(vim.g.base46_cache .. "defaults")
 -- dofile(vim.g.base46_cache .. "statusline")

require("config.options")
require("config.keymaps")
require("config.shared-keymaps")

-- If run embedded in VSCode use these specific settings and skip not useful ones.
if vim.g.vscode then
  require("config.vscode")
else
  -- (method 2, for non lazyloaders) to load all highlights at once
  for _, v in ipairs(vim.fn.readdir(vim.g.base46_cache)) do
    dofile(vim.g.base46_cache .. v)
  end

  require("config.autocmds-lazyvim")
  require("config.autocmds")
  require("config.user-commands")

  -- Start server so can open files in terminal with Neovim without having to open
  -- them in different process.
  if not vim.v.servername or vim.v.servername == '' then
    vim.fn.serverstart(string.format("/tmp/nvim.%d", vim.fn.getpid()))
  end

end

