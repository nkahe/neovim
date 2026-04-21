local M = {}

function M.get(theme, colors, _)
local lighten = require("neoceanic.colors").change_hex_lightness
  -- stylua: ignore
  return {
    LazyButton = { bg = colors.one_bg, fg = lighten(colors.light_grey, vim.o.bg == "dark" and 10 or -20) },
    LazyH1            = { bg = colors.green,    fg = colors.black },
    LazyH2            = { fg = colors.red,      bold = true, underline = true },
    LazyReasonPlugin  = { fg = colors.red       },
    LazyValue         = { fg = colors.teal      },
    LazyDir           = { fg = theme.base05     },
    LazyUrl           = { fg = theme.base05     },
    LazyCommit        = { fg = colors.green     },
    LazyNoCond        = { fg = colors.red       },
    LazySpecial       = { fg = colors.blue      },
    LazyReasonFt      = { fg = colors.purple    },
    LazyOperator      = { fg = colors.white     },
    LazyReasonKeys    = { fg = colors.teal      },
    LazyTaskOutput    = { fg = colors.white     },
    LazyCommitIssue   = { fg = colors.pink      },
    LazyReasonEvent   = { fg = colors.yellow    },
    LazyReasonStart   = { fg = colors.white     },
    LazyReasonRuntime = { fg = colors.nord_blue },
    LazyReasonCmd     = { fg = colors.yellow    },
    LazyReasonSource  = { fg = colors.cyan      },
    LazyReasonImport  = { fg = colors.white     },
    LazyProgressDone  = { fg = colors.green     },
  }
end

return M
