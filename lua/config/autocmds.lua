
-- Helper to set autogroup with prefix.
local function augroup(name)
  return vim.api.nvim_create_augroup("Custom_" .. name, { clear = true })
end

-- Set title. Prefix is set in init.lua.
vim.api.nvim_create_autocmd("BufEnter", {
  group = augroup("window_title"),
  callback = function()
    local filename = vim.fn.expand("%:t") ~= "" and vim.fn.expand("%:t") or "[No Name]"
    local prefix = (_G.Config and _G.Config.windowtitle) or ""
    if prefix ~= "" then
      vim.o.titlestring = prefix .. " - " .. filename
    else
      vim.o.titlestring = filename
    end
  end,
})

-- Recognize some file types from file name.
vim.filetype.add({
  group = augroup("set_filetype"),
  filename = {
    ["todo.txt"] = "todotxt",
  },
})

-- Disable colorcolumn for floating windows.
vim.api.nvim_create_autocmd("WinEnter", {
  group = augroup("disable_colorcolumn"),
  callback = function()
    local cfg = vim.api.nvim_win_get_config(0)
    if cfg.relative ~= "" then
      -- This is a floating window
      vim.wo.colorcolumn = ""
    end
  end,
  desc = "Disable colorcolumn in floating windows",
})

-- Set black background color for terminal. Doesn't work always.
vim.api.nvim_create_autocmd("TermOpen", {
  group = augroup("terminal_background"),
  pattern = "*",
  callback = function()
    -- These custom groups are set in coloscheme config.
    -- vim.api.nvim_set_hl(0, "TermBackground", { bg = "#121212" })
    -- vim.api.nvim_set_hl(0, "TermCursorLine", { bg = "none" })
    vim.opt_local.winhighlight = "Normal:TermBackground,CursorLine:TermCursorLine"
    vim.cmd("startinsert")
  end,
})

-- show cursor line only in active window
vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
  group = augroup("cursorline_in_active"),
  callback = function()
    if vim.w.auto_cursorline then
      vim.wo.cursorline = true
      vim.w.auto_cursorline = nil
    end
  end,
})

vim.api.nvim_create_autocmd({ "InsertEnter", "WinLeave" }, {
  group = augroup("cursorline_in_inactive"),
  callback = function()
    if vim.wo.cursorline then
      vim.w.auto_cursorline = true
      vim.wo.cursorline = false
    end
  end,
})

-- Always open QuickFix windows below current window
vim.api.nvim_create_autocmd("QuickFixCmdPost", {
  group = augroup("open_quickfix_below"),
  pattern = "[^l]*", -- Applies to Quickfix commands, not location list
  callback = function()
    vim.cmd("botright copen")
  end,
})

-- Open location list after search
vim.api.nvim_create_autocmd("QuickFixCmdPost", {
  group = augroup("open_locationlist_below"),
  pattern = "lgrep",
  callback = function()
    vim.cmd("lopen") -- Open the location list
  end,
})

-- Disable relative numbers in Insert mode
-- This bugs: Makes cursor jump in Snacks input fields when mode changes.
-- vim.api.nvim_create_autocmd("InsertEnter", {
--     pattern = "*",
--     command = "set norelativenumber",
-- })
-- -- Enable relative numbers when leaving Insert mode
-- vim.api.nvim_create_autocmd("InsertLeave", {
--     pattern = "*",
--     command = "set relativenumber",
-- })

-- Dynamic tab title change for Yakuake --------------------------------------

-- Function to update the Yakuake terminal tab title
local function update_yakuake_title()

-- Title prefix can be set in init.lua.
local prefix = (_G.Config and _G.Config.windowtitle) or "Neovim"

  -- Get the current buffer name (just the file name, not the full path)
  local buffer_name = vim.fn.expand('%:t')

  if buffer_name == "" then
    -- if prefix ~= "" then
      buffer_name = prefix
    -- else
    --   buffer_name = "Neovim"
    -- end
  else
    -- if prefix ~= "" then
      buffer_name = buffer_name .. " - " .. prefix
    -- end
  end

  -- Set the Yakuake tab title using the session_id and buffer_name
  local qdbus_cmd = "qdbus org.kde.yakuake /yakuake/tabs setTabTitle %s \"%s\""
  vim.fn.system(string.format(qdbus_cmd, Session_id, buffer_name))
end

-- Get the current Yakuake session id using qdbus
Session_id = vim.fn.system("qdbus org.kde.yakuake /yakuake/sessions org.kde.yakuake.activeSessionId")

-- Trim any extra whitespace
Session_id = vim.fn.trim(Session_id)

-- If using Yakuake
if Session_id ~= "" then
  -- Autocmd to update Yakuake title on buffer changed
  vim.api.nvim_create_autocmd({"BufEnter", "BufWritePost"}, {
    callback = update_yakuake_title
  })
end
