local M = {}

function M.setup()
  local palette = require("neoceanic.palette")
  local colors = palette.colors
  local theme = palette.theme

  local opts = {}
  local groups = {}
  local groups_dir = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h") .. "/groups"

  for _, file in ipairs(vim.fn.readdir(groups_dir, [[v:val =~ '\.lua$']])) do
    local module = require("neoceanic.groups." .. file:gsub("%.lua$", ""))
    groups = vim.tbl_extend("force", groups, module.get(theme, colors, opts))
  end

  for group, highlight in pairs(groups) do
    vim.api.nvim_set_hl(0, group, highlight)
  end

end

return M
