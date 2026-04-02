
-- Normal mode: execute current line
vim.keymap.set("n", "<leader>cx", function()
  local line = vim.api.nvim_get_current_line()
  local chunk, err = loadstring(line)
  if not chunk then
    vim.notify("Error: " .. err, vim.log.levels.ERROR)
  else
    chunk()
  end
end, { desc = "Execute current line as Lua" })

-- Visual mode: execute selected lines
vim.keymap.set("v", "<leader>cx", function()
  local start_line = vim.fn.line("v")
  local end_line = vim.fn.line(".")
  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end
  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  local chunk, err = loadstring(table.concat(lines, "\n"))
  if not chunk then
    vim.notify("Error: " .. err, vim.log.levels.ERROR)
  else
    chunk()
  end
end, { desc = "Execute selected Lua code" })

