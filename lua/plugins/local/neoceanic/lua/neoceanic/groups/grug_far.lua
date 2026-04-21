local M = {}

function M.get(_, _, _)
  -- stylua: ignore
  return {
    GrugFarResultsMatch        = { link = "DiffChange" },
    GrugFarResultsMatchAdded   = { link = "DiffAdd"    },
    GrugFarResultsMatchRemoved = { link = "DiffDelete" },
  }
end

return M
