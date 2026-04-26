
local M = {}

function M.get(_, colors, _)
  return {
    MiniTrailspace = { fg = colors.white, bg = colors.one_bg3 }
  }
end

return M
