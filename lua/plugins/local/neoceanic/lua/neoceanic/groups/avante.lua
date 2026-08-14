
local M = {}

function M.get(_, colors, _)
  local lighten = require("neoceanic.utils").change_hex_lightness

  return {
    AvanteInlineHint         = { fg = colors.grey_fg2 },
    AvanteTitle              = { fg = colors.black2, bg = colors.nord_blue },
    AvanteReversedTitle      = { fg = colors.nord_blue, bg = colors.black2 },
    AvanteTaskCompleted      = { bg = lighten(colors.green, -40 ) },
    AvanteTaskFailed         = { fg = colors.red   },
    AvanteStateSpinnerSucceeded    = { bg = lighten(colors.green, -40 ) },
    AvanteStateSpinnerToolCalling  = { bg = lighten(colors.nord_blue, -30 ) },

    -- AvanteSubtitle           = { fg = colors.black2, bg = colors.nord_blue },
    -- AvanteReversedSubtitle   = { fg = colors.nord_blue,     bg = colors.black2 },
    -- AvanteThirdTitle         = { fg = colors.black2, bg = colors.white,    },
    -- AvanteReversedThirdTitle = { fg = colors.white },
  }
end

-- AvanteTitle                 Title
-- AvanteReversedTitle         Used for rounded border
-- AvanteSubtitle              Selected code title
-- AvanteReversedSubtitle      Used for rounded border
-- AvanteThirdTitle            Prompt title
-- AvanteReversedThirdTitle    Used for rounded border
-- AvanteConflictCurrent       Current conflict highlight          efault to Config.highlights.diff.current
-- AvanteConflictIncoming      Incoming conflict highlight         efault to Config.highlights.diff.incoming
-- AvanteConflictCurrentLabel  Current conflict label highlight    efault to shade of AvanteConflictCurrent
-- AvanteConflictIncomingLabel Incoming conflict label highlight   efault to shade of AvanteConflictIncoming
-- AvantePopupHint             Usage hints in popup menus
-- AvantePromptInput           The body highlight of the prompt input
-- AvantePromptInputBorder     The border highlight of the prompt input 	Default to NormalFloat

return M
