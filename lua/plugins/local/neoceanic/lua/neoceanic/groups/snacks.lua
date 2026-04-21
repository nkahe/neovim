local M = {}

function M.get(_, colors, _)
  return {
    SnacksPickerListCursorline = { bg = colors.one_bg },
    SnacksPickerCursorline     = { bg = colors.one_bg },
    SnacksPickerDir            = { fg = colors.nord_blue },
    SnacksIndent               = { fg = colors.one_bg2 },
  }
end

return M
