local palette = require("neoceanic.palette")
local colors = palette.colors
local hl = {}

local off_white = colors.white
local true_black = "#000000"
local b_section_bg = colors.one_bg2
local c_section_bg = colors.statusline_bg

-- Sections:

-- | A | B | C              X | Y | Z |

hl.normal = {
  a = { bg = colors.nord_blue, fg = true_black  },
  b = { bg = b_section_bg,     fg = colors.blue },
  c = { bg = c_section_bg,     fg = off_white   },
}

hl.insert = {
  a = { bg = colors.green, fg = colors.black },
  b = { bg = b_section_bg, fg = colors.green },
}

hl.command = {
  a = { bg = colors.teal, fg = colors.black },
  b = { bg = b_section_bg,  fg = colors.teal },
}

hl.visual = {
  a = { bg = colors.dark_purple, fg = colors.black  },
  b = { bg = b_section_bg,       fg = colors.purple },
}

hl.replace = {
  a = { bg = colors.red,   fg = colors.black },
  b = { bg = b_section_bg, fg = colors.red },
}

hl.terminal = {
  a = { bg = colors.teal,  fg = colors.black },
  b = { bg = b_section_bg, fg = colors.green1 },
}

hl.inactive = {
  a = { bg = c_section_bg, fg = colors.blue },
  b = { bg = c_section_bg, fg = colors.light_grey, gui = "bold" },
  c = { bg = c_section_bg, fg = colors.light_grey, },
}

-- if config.lualine_bold then
for _, mode in pairs(hl) do
  mode.a.gui = "bold"
  mode.z = vim.deepcopy(mode.a)
  mode.z.gui = nil
end
-- end

return hl
