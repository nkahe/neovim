local M = {}

function M.get(_, colors, _)
  -- stylua: ignore
  return {
    WhichKey          = { fg = colors.teal       },
    WhichKeySeparator = { fg = colors.light_grey },
    WhichKeyDesc      = { fg = colors.cyan       },
    WhichKeyGroup     = { fg = colors.blue       },
    WhichKeyValue     = { fg = colors.green      },
  }
end

return M
