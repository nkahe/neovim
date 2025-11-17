
-- NOTE: spell check is defined in autocmds.lua to work with LazyVim.

-- vim.opt.textwidth = 90     -- Set the soft wrap column

vim.cmd('setlocal wrap nospell')

vim.schedule(function()
  -- Use plugin to make define width of wrapped text.
  if vim.fn.exists(":Wrapwidth") == 2 then
    vim.opt_local.colorcolumn = ""
    vim.cmd("Wrapwidth 90")
    -- Color column doens't work with wrapped lines.
  else
    vim.notify("'Wrapwidth' is off", vim.log.levels.INFO)
  end
end)
-- Disable diagnostics by default.
vim.diagnostic.enable(false)
