local M = {}

function M.get(_, c, _)

  -- stylua: ignore

  local mix = require("neoceanic.colors").mix
  local black = c.black
  local percent = 90
  -- local percent = 65
  local color_icon = c.white
  local heading_colors = {
    c.heading, c.blue, c.cyan, c.green, c.pink, c.orange,
  }

  -- local heading_colors = {
  --   c.red, c.orange, c.yellow, c.green, c.blue, c.purple
  -- }

  -- ["@markup.heading.1.markdown"] = { fg = colors.red },
  -- ["@markup.heading.2.markdown"] = { fg = colors.orange },
  -- ["@markup.heading.3.markdown"] = { fg = colors.yellow },
  -- ["@markup.heading.4.markdown"] = { fg = colors.green },
  -- ["@markup.heading.5.markdown"] = { fg = colors.blue },
  -- ["@markup.heading.6.markdown"] = { fg = colors.purple },

  local groups = {}

  for i, color in ipairs(heading_colors) do
    local background = mix(color, black, percent)
    groups["MarkviewHeading" .. i] = { fg = color, bg = background }
    groups["MarkviewHeadingIcon" .. i] = { fg = color_icon, bg = background }
  end

  return groups
end

return M
