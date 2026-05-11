local map = vim.keymap.set
-- Clipboard operators

map({'n', 'v'}, "cp", '"+p', { desc = "Paste from clipboard" })
map({'n', 'v'}, "gp", '"+p', { desc = "Paste from clipboard" })
map({'n', 'v'}, "cP", '"+P', { desc = "Paste from clipboard" })
map({'n', 'v'}, "gP", '"+P', { desc = "Paste from clipboard" })

map({'n', 'v'}, "cd", '"+d', { desc = "Delete to clipboard" })
map({'n', 'v'}, "cD", '"+D', { desc = "Delete end of line to clipboard" })
map({'n', 'v'}, "cy", '"+y', { desc = "Yank to clipboard" })
map({'n', 'v'}, "gy", '"+y', { desc = "Yank to clipboard" })
map({'x'}, "<C-c>", '"+y',   { desc = "Yank to clipboard" })
-- Mapping cY doesn't work.
map({'n'}, 'gY', '"+y$', { desc = "Yank end of line to clipboard" , noremap = false})


-- C-g to show full path of a file instead of truncated one.
vim.keymap.set("n", "<C-g>", function()
  local file = vim.fn.expand("%:p") or "[No Name]"
  local line = vim.fn.line(".")
  local col = vim.fn.col(".")
  local total = vim.fn.line("$")
  local percent = math.floor((line / total) * 100)
  vim.api.nvim_echo({
    { string.format("%s  line %d of %d --%d%%-- col %d", file, line, total, percent, col), "Normal" }
  }, false, {})
end, { desc = "Show full file path and cursor position" })

