local M = {}
local float_win = nil

local function open_centered_float()
  local buf = vim.api.nvim_get_current_buf()
  local ui = vim.api.nvim_list_uis()[1]

  local total_w = ui.width
  local total_h = ui.height

  local win_w = 100                         -- exact text area width
  local win_h = total_h - 4                 -- leave top/bottom breathing space

  -- center the 100-column window
  local col = math.floor((total_w - win_w) / 2)
  local row = math.floor((total_h - win_h) / 2)

  float_win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = win_w,
    height = win_h,
    col = col,
    row = row,
    style = "minimal",
    border = nil,        -- no line around window
  })

  -- disable UI noise
  vim.wo[float_win].number = false
  vim.wo[float_win].relativenumber = false
  vim.wo[float_win].signcolumn = "no"
  vim.wo[float_win].foldcolumn = "0"
  vim.wo[float_win].wrap = true

  -- ensure it blends with background
  vim.wo[float_win].winhighlight = "Normal:Normal,FloatBorder:Normal"
end

local function close_centered_float()
  if float_win and vim.api.nvim_win_is_valid(float_win) then
    vim.api.nvim_win_close(float_win, true)
  end
  float_win = nil
end

function M.toggle()
  if float_win and vim.api.nvim_win_is_valid(float_win) then
    close_centered_float()
  else
    open_centered_float()
  end
end

return M
