
-- When exiting terminal shell, just delete buffer and don't print
-- [Process exited 130] and wait for a keypress.
vim.api.nvim_create_autocmd("TermClose", {
  group = augroup("close_terminal_buffer"),
  callback = function(args)
    if vim.api.nvim_buf_is_valid(args.buf) then
      vim.schedule(function()
        pcall(vim.api.nvim_buf_delete, args.buf, { force = true })
      end)
    end
  end,
})

-- When exiting terminal shell, just close window and don't print
-- [Process exited 130] and wait for a keypress.
vim.api.nvim_create_autocmd("TermClose", {
  group = augroup("close_terminal_window"),
  callback = function(args)
    local win = vim.fn.bufwinid(args.buf)
    if win ~= -1 then
      local ok, _ = pcall(vim.api.nvim_win_close, win, true)
      if not ok then
        -- fallback: maybe it was already gone
      end
    end
  end,
})

-- Compile and apply Base46 theme when changes are saved.
local ok, base46 = pcall(require, "base46")
if ok then
  vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = "nvconfig.lua",
    group = augroup('compile_base46_theme'),
    callback = function()
      base46.compile()
      base46.load_all_highlights()
      vim.notify("Theme compiled and loaded", vim.log.INFO)
    end,
  })
end

