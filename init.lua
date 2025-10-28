-- Set leader keys early
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- Helper to require all Lua files in a directory
local function load_directory(modpath)
  local path = vim.fn.stdpath("config") .. "/lua/" .. modpath:gsub("%.", "/")
  local files = vim.fn.glob(path .. "/*.lua", false, true)
  for _, file in ipairs(files) do
    local name = vim.fn.fnamemodify(file, ":t:r")  -- filename without path or extension
    local ok, err = pcall(require, modpath .. "." .. name)
    if not ok then
      vim.notify(("Error loading %s: %s"):format(file, err), vim.log.levels.ERROR)
    end
  end
end

-- Define config table to be able to pass data between scripts
_G.Config = {}

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

-- Load all config files under lua/config/
load_directory("config")
