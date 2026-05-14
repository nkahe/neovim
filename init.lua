-- Define config table to be able to pass data between scripts
_G.Config = {}

-- User in autocmd to set window title prefix before filename.
_G.Config.windowtitle = 'Custom'

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Define custom autocommand group and helper to create an autocommand.
local gr = vim.api.nvim_create_augroup('custom-config', {})
_G.Config.new_autocmd = function(event, pattern, callback, desc)
  local opts = { group = gr, pattern = pattern, callback = callback, desc = desc }
  vim.api.nvim_create_autocmd(event, opts)
end

-- Source config files.

require("config.lazy")
require("config.options")
require("config.keymaps")
require("config.shared-keymaps")

-- If run embedded in VSCode use these specific settings and skip not useful ones.
if vim.g.vscode then
  require("config.vscode")
else
  require("config.autocmds-lazyvim")
  require("config.autocmds")
  require("config.commands")
  require("plugins.local.breeze").setup()

  -- Start server so can open files in terminal with Neovim without having to open
  -- them in different process.
  if not vim.v.servername or vim.v.servername == '' then
    vim.fn.serverstart(string.format("/tmp/nvim.%d", vim.fn.getpid()))
  end

end

