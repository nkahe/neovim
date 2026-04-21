local M = {}

function M.get(_, colors, _)
  -- stylua: ignore
  return {
      NoiceCmdlinePopupBorder       = { fg = colors.teal },
      NoiceCmdlinePopupBorderSearch = { fg = colors.teal },
  }
end

return M
