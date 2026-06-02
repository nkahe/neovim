local M = {}

function M.get(_, colors, _)
  return {
    NeoTreeTabInactive          = { fg = colors.light_grey,    bg = colors.darker_black },
    NeoTreeTabSeparatorInactive = { fg = colors.darker_black,  bg = colors.darker_black },
    NeoTreeGitConflict          = { fg = colors.light_grey },
    NeoTreeGitModified          = { fg = colors.light_grey },
    NeoTreeGitUntracked         = { fg = colors.light_grey },
    NeoTreeGitUnstaged          = { fg = colors.light_grey },
    NeoTreeIndentMarker         = { fg = colors.grey       },
    NeoTreeMessage              = { fg = colors.light_grey },
    NeoTreeNormal               = { bg = colors.darker_black },
    NeoTreeNormalNC             = { bg = colors.darker_black },
    NeoTreeTitleBar             = { bg = colors.darker_black }
  }
end

return M
