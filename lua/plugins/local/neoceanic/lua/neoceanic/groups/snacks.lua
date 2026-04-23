local M = {}

function M.get(_, c, _)
  local border_c = c.grey_fg
    return {
      SnacksNotifierBorderDebug  = { fg = border_c },
      SnacksNotifierBorderError  = { fg = border_c },
      SnacksNotifierBorderInfo   = { fg = border_c },
      SnacksNotifierBorderWarn   = { fg = border_c },

      SnacksPickerListCursorline = { bg = c.one_bg },
      SnacksPickerCursorline     = { bg = c.one_bg },
      SnacksPickerDir            = { fg = c.nord_blue },

      SnacksIndent               = { fg = c.one_bg2 },
    }
  end

return M
