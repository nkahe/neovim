local M = {}

function M.get(_, colors, _)
  return {
    DiffviewDiffAdd  = { fg = colors.green, bg = colors.one_bg },
    DiffviewDiffText = { fg = colors.green, bg = colors.one_bg },
  }
end

return M
