local M = {}

function M.get(_, c, _)
  local true_black = "#000000"
  local mix = require("neoceanic.colors").mix

  return {
    MiniDiffSignAdd    = { fg = mix(c.green,  c.black, 50) },
    MiniDiffSignChange = { fg = mix(c.yellow, c.black, 40) },
    MiniDiffSignDelete = { fg = mix(c.baby_pink, c.black, 40) },
    -- MiniDiffOverAdd
    -- MiniDiffOverChange
    -- MiniDiffOverChangeBuf
    -- MiniDiffOverContext
    -- MiniDiffOverContextBuf
    -- MiniDiffOverDelete

    MiniIndentscopeSymbol = { fg = c.grey_fg2 },


    MiniMapNormal = { fg = c.light_grey },
    MiniMapSymbolCount = { fg = c.blue },
    MiniMapSymbolLine = { fg = c.light_grey },
    MiniMapSymbolView = { fg = c.grey_fg },

    MiniStatuslineModeNormal  = { bg = c.nord_blue,   fg = true_black  },
    MiniStatuslineModeVisual  = { bg = c.dark_purple, fg = c.black  },
    MiniStatuslineModeInsert  = { bg = c.green,  fg = c.black },
    MiniStatuslineModeReplace = { bg = c.red,    fg = c.black },
    MiniStatuslineModeCommand = { bg = c.orange, fg = c.black },
    MiniStatuslineModeOther   = { bg = c.teal,   fg = c.black },
    MiniStatuslineDevinfo     = { fg = c.blue  },
    MiniStatuslineFilename    = { fg = c.white },
    MiniStatuslineFileinfo    = { fg = c.light_grey },
    MiniStatuslineInactive    = { fg = c.light_grey },

    MiniTrailspace = { fg = c.white, bg = c.one_bg3 }
  }
end

return M
