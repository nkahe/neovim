-- Define config table to be able to pass data between scripts
_G.Config = {}

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

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

require("config.lazy")

-- Source config files.
require("config.10_options")
require("config.20_keymaps")
require("config.25_shared-keymaps")
require("config.70_autocmds")


vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'javascript', "bash", "sh" },
  callback = function() vim.treesitter.start() end,
})
