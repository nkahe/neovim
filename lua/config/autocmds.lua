
-- Helper to set autogroup with prefix.
local function augroup(name)
  return vim.api.nvim_create_augroup("Custom_" .. name, { clear = true })
end

-- Make use of custom prefixes on window title which are set based on Neovim
-- config or session.
vim.api.nvim_create_autocmd({ "BufEnter", "TermClose" }, {
  group = augroup("set_window_title"),
  callback = function()
    -- This is set in TermOpen. 
    if vim.bo.buftype == "terminal" then
      return
    end

    local filename
    local prefix = (_G.Config and _G.Config.windowtitle) or "Neovim"

    -- Normal buffer
    filename = vim.fn.expand("%:t")
    if filename == "" then
      filename = "[No Name]"
    end

    local dirpath = vim.fn.expand("%:~:h")

    if dirpath == "" then
      vim.o.titlestring = string.format("%s - %s", prefix, filename)
    else
      vim.o.titlestring = string.format("%s - %s (%s)", prefix, filename, dirpath)
    end
  end,
})

-- Set black background color for terminal and start in insert mode.
-- Color doesn't work always.
vim.api.nvim_create_autocmd({ "TermOpen", "WinEnter" }, {
  group = augroup("set_terminal_settings"),
  pattern = "*",
  callback = function()
     if vim.bo.buftype == "terminal" then
      vim.cmd("startinsert")
      local prefix = (_G.Config and _G.Config.windowtitle) or "Neovim"
      vim.o.titlestring = prefix .. " - terminal"
    end
  end,
})

-- Adding "VimResized" didn't have an effect.
vim.api.nvim_create_autocmd({ "TermOpen", "WinEnter"  }, {
  group = augroup("set_terminal_background_color"),
  pattern = "*",
  callback = function()
      -- These custom groups are set in coloscheme config.
      -- vim.api.nvim_set_hl(0, "TermBackground", { bg = "#121212" })
      -- vim.api.nvim_set_hl(0, "TermCursorLine", { bg = "none" })
    if vim.bo.buftype == "terminal" or vim.bo.filetype == "snacks_terminal" then
      vim.opt_local.winhighlight = "Normal:TermBackground,CursorLine:TermCursorLine"
    end
  end,
})

-- When exiting terminal shell, just close window and don't print
-- [Process exited 130] and wait for a keypress.
vim.api.nvim_create_autocmd("TermClose", {
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

-- Recognize some file types based on file name.
vim.filetype.add({
  group = augroup("set_filetype"),
  filename = {
    ["todo.txt"] = "todotxt",
  },
})

-- Disable colorcolumn for floating windows.
vim.api.nvim_create_autocmd("WinEnter", {
  group = augroup("disable_colorcolumn_for_float"),
  callback = function()
    local cfg = vim.api.nvim_win_get_config(0)
    if cfg.relative ~= "" then
      -- This is a floating window
      vim.wo.colorcolumn = ""
    end
  end,
  desc = "Disable colorcolumn in floating windows",
})

-- show cursor line only in active window
vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
  group = augroup("cursorline_in_active"),
  callback = function()
    -- if vim.w.auto_cursorline then
      vim.wo.cursorline = true
      -- vim.w.auto_cursorline = nil
    -- end
  end,
})

vim.api.nvim_create_autocmd({ "InsertEnter", "WinLeave" }, {
  group = augroup("cursorline_in_inactive"),
  callback = function()
    -- if vim.wo.cursorline then
      -- vim.w.auto_cursorline = true
      vim.wo.cursorline = false
    -- end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup("maximize_help_vertically"),
  pattern = "help",
  callback = function()
    vim.cmd("wincmd _") -- maximize height
    -- vim.cmd("wincmd |") -- maximize width
  end,
})

-- Help pages: <CR> to open links in addition to C-]
vim.api.nvim_create_autocmd("FileType", {
  group = augroup('open_links_with_enter');
  pattern = { "help", "man" },
  callback = function()
    vim.api.nvim_buf_set_keymap(0, "n", "<CR>", "<C-]>", { silent = true })
  end,
})

-- Use relative line numbers only on active window.
-- vim.api.nvim_create_autocmd({"InsertEnter","WinLeave"},
--   { group = augroup("line_numbers"),
--     command = "set norelativenumber"
--   })
--
-- vim.api.nvim_create_autocmd({"InsertLeave","WinEnter"},
--   { group = augroup("line_numbers"),
--     callback = function()
--       local ft = vim.bo.filetype
--       local bt = vim.bo.buftype
--       -- No line numbers  for these.
--       if bt == "terminal" or ft:match("^snacks_picker") or
--         ft == "rip-substitute" then
--         return
--       end
--       vim.wo.relativenumber = true
--     end,
--   })

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

