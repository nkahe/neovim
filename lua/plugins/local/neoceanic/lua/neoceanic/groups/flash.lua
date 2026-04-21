local M = {}

function M.get(_, colors, _)
  -- stylua: ignore
  return {
    FlashMatch   = { fg = colors.black, bg   = colors.blue  },
    FlashCurrent = { fg = colors.black, bg   = colors.green },
    FlashLabel   = { fg = colors.white, bold = true         },
  }
end

return M
