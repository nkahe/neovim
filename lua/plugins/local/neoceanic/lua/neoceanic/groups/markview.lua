local M = {}

function M.get(_, c, _)

  -- stylua: ignore

  local mix = require("neoceanic.colors").mix
  local black = "#000000"
  local percent = 65
  local color_icon = c.white
  local heading_colors = {
    c.purple, c.blue, c.cyan, c.green, c.pink, c.orange,
  }

  local groups = {}

  for i, color in ipairs(heading_colors) do
    local background = mix(color, black, percent)
    groups["MarkviewHeading" .. i] = { fg = color, bg = background }
    groups["MarkviewHeadingIcon" .. i] = { fg = color_icon, bg = background }
  end

  return groups
end

return M
