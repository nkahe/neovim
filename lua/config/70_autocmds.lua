
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    local filename = vim.fn.expand("%:t") ~= "" and vim.fn.expand("%:t") or "[No Name]"
    vim.o.titlestring = "Custom - " .. filename
  end,
})
