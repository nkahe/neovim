local M = {}

function M.get(_, colors, _)
  -- stylua: ignore
  return {
    WhichKey          = { fg = colors.blue       },
    WhichKeySeparator = { fg = colors.light_grey },
    WhichKeyDesc      = { fg = colors.blue       },
    WhichKeyGroup     = { fg = colors.green      },
    WhichKeyValue     = { fg = colors.green      },
  }
end

return M
