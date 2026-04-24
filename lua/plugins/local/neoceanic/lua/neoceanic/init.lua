local config = require("neoceanic.config")
local M = {}

function M.load(opts)
  opts = require('neoceanic.config').extend(opts)
  local palette = require("neoceanic.palette")
  local colors = palette.colors
  local theme = palette.theme

  local groups = {}
  local groups_dir = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h") .. "/groups"

  for _, file in ipairs(vim.fn.readdir(groups_dir, [[v:val =~ '\.lua$']])) do
    local module = require("neoceanic.groups." .. file:gsub("%.lua$", ""))
    groups = vim.tbl_extend("force", groups, module.get(theme, colors, opts))
  end

  if vim.g.colors_name then
    vim.cmd("hi clear")
  end

  vim.o.termguicolors = true
  vim.g.colors_name = "neoceanic"

  for group, hl in pairs(groups) do
    vim.api.nvim_set_hl(0, group, hl)
  end

  if opts.terminal_colors then
    require("neoceanic.term").terminal(theme)
  end
end

M.setup = config.setup

return M
