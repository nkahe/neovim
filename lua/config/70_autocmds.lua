
-- Helper to set autogroup with prefix.
local function augroup(name)
  return vim.api.nvim_create_augroup("Custom_" .. name, { clear = true })
end

-- Set title. Prefix _G.Config.windowtitle is set in init.lua.
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

-- go to last loc when opening a buffer. From LazyVim.
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_loc"),
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
      return
    end
    vim.b[buf].lazyvim_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- close some filetypes with <q>. From Lazyvim.
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "PlenaryTestPopup",
    "checkhealth",
    "dbout",
    "gitsigns-blame",
    "grug-far",
    "help",
    "lspinfo",
    "neotest-output",
    "neotest-output-panel",
    "neotest-summary",
    "notify",
    "qf",
    "spectre_panel",
    "startuptime",
    "tsplayground",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set("n", "q", function()
        vim.cmd("close")
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
      end, {
        buffer = event.buf,
        silent = true,
        desc = "Quit buffer",
      })
    end)
  end,
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

-- Fix conceallevel for json files. From Lazyvim.
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = augroup("json_conceal"),
  pattern = { "json", "jsonc", "json5" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- Auto create dir when saving a file, in case some intermediate
-- directory does not exist. From Lazyvim.
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = augroup("auto_create_dir"),
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- Set black background color for terminal. Doesn't work always.
vim.api.nvim_create_autocmd("TermOpen", {
  group = augroup("terminal_background"),
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "TermBackground", { bg = "#121212" })
    vim.api.nvim_set_hl(0, "TermCursorLine", { bg = "none" })
    vim.opt_local.winhighlight = "Normal:TermBackground,CursorLine:TermCursorLine"
    -- vim.cmd("startinsert") -- mini.basics does this already?
  end,
})
