local M = {}

function M.get(_, colors, _)
  -- stylua: ignore
  local mix_col = require("neoceanic.colors").mix

  -- Need to manually re-configure git-conflict.nvim to use these highlight groups.
  -- See: https://github.com/akinsho/git-conflict.nvim?tab=readme-ov-file#configuration
  return {
    GitConflictDiffAdd  = { bg = mix_col(colors.blue,  colors.black, 85) },
    GitConflictDiffText = { bg = mix_col(colors.green, colors.black, 85) },
  }
end

return M
