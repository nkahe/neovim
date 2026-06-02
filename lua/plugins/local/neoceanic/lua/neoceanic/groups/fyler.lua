local M = {}

function M.get(_, c, _)
  return {
    FylerIndentMarker = { fg = c.grey },
  }
end

return M
