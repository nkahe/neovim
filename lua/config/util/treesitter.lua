-- From LazyVim: lazyvim.util.treesitter.lua
-- Used in Treesitter config.

local M = {}

--- Checks whether Treesitter parser + query exist for given filetype/lang
---@param what string|number|nil Filetype name or buffer number
---@param query? string Optional query (like "textobjects")
---@return boolean
function M.have(what, query)
  what = what or vim.api.nvim_get_current_buf()
  local ft = type(what) == "number" and vim.bo[what].filetype or what
  local lang = vim.treesitter.language.get_lang(ft)
  if not lang then
    return false
  end

  local ok, parsers = pcall(require, "nvim-treesitter.parsers")
  if not ok then
    return false
  end

  local installed = parsers.get_installed and parsers.get_installed() or {}
  if not vim.tbl_contains(installed, lang) then
    return false
  end

  if query then
    local ok2, _ = pcall(vim.treesitter.query.get, lang, query)
    if not ok2 then
      return false
    end
  end

  return true
end

return M
