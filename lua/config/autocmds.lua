
-- Helper to set autogroup with prefix.
local function augroup(name)
  return vim.api.nvim_create_augroup("Custom_" .. name, { clear = true })
end

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

-- Make --NVIM_SESSION=<session_name> Neovim command line parameter to set
-- read session at start.
vim.api.nvim_create_autocmd("VimEnter", {
  group = augroup('start_with_session'),
  callback = function()
    local session = vim.env.NVIM_SESSION
    if not session or session == "" then
      return
    end

    -- don't override when files were passed
    if vim.fn.argc() > 0 then
      return
    end

    _G.Config.windowtitle = session

    vim.schedule(function()
      pcall(function()
        require("mini.sessions").read(session)
      end)
    end)

  end,
})

-- Command mode aliases.
local aliases = {
  ["~config"] = vim.fn.expand("~/.config"),
  ["~custom"] = vim.fn.expand("~/.config/nvim/custom"),
  ["~ndata"]  = vim.fn.expand("~/.local/share/nvim"),
  ["~notes"]  = vim.fn.expand("~/Nextcloud/notes"),
  ["~nvim"]   = vim.fn.expand("~/.config/nvim"),
  ["~share"]  = vim.fn.expand("~/.local/share"),
}

vim.api.nvim_create_autocmd("CmdlineLeave", {
  group = augroup("command_mode_aliases"),
  pattern = ":",
  callback = function()
    local cmd = vim.fn.getcmdline()

    for alias, target in pairs(aliases) do
      cmd = cmd:gsub(alias, target)
    end

    vim.fn.setcmdline(cmd)
  end,
})


-- Hot reloading. Watches for saves specifically in the `lua/config/keymaps.lua`
-- and `lua/config/options.lua`.
local config_path = vim.fn.stdpath("config") .. "/lua/config/"

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = config_path .. "*",
  group = augroup("hot_reload"),
  callback = function(args)
    local file = args.file
    if file:match("%.lua$") then
      vim.cmd("source " .. args.file)
      vim.notify("Sourced " .. vim.fn.fnamemodify(file, ":t"))
    end
  end,
})

-- Configs for diff-mode.
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*",
  group = augroup("diff_config"),
  callback = function()
    if vim.wo.diff then
      local map = vim.keymap.set
      -- These keys are mapped in Treesitter config. Restore default for diff buffers.
      map("n", "[c", "[c", { buffer = true, remap = true, desc = "Previous change"})
      map("n", "]c", "]c", { buffer = true, remap = true, desc = "Next change"})
      map("n", "\\o", "<Cmd>diffoff!<CR>", { buffer = true, desc = "Diff off! (tab)"})
      map("n", "\\u", "<Cmd>diffupdate<CR>", { buffer = true, desc = "Diff update"})
      map("n", "\\O", "<Cmd>diffoff<CR>", { buffer = true, desc = "Diff off (window)"})
    end
  end,
})

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

-- Set title for terminals and start in insert mode.
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

-- Set background color for terminal. Neovim doesn't have exclusive highlights
-- groups for it natively.
-- NOTE: For Snacks.terminal this doesn't work but it has similar setting added
-- in it's config.

-- Fallback if colors aren't defined.
vim.api.nvim_set_hl(0, "TermBackgroundFallback", { bg = "#121212" })
vim.api.nvim_set_hl(0, "NoBackground", { bg = "none" })

vim.api.nvim_create_autocmd({ "TermOpen", "WinEnter"  }, {
  group = augroup("set_terminal_background_color"),
  pattern = "*",
  callback = function()
    if vim.bo.buftype == "terminal" or vim.bo.filetype == "snacks_terminal" then
      local bg_group = vim.g.TermBackground and "TermBackground" or "TermBackgroundFallback"
      vim.opt_local.winhighlight = table.concat({
        "Normal:" .. bg_group,
        "CursorLine:NoBackground",
      }, ",")
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

-- Recognize some file types based on file name.
vim.filetype.add({
  group = augroup("set_filetype"),
  filename = {
    ["todo.txt"] = "todotxt",
  },
})

-- Disable colorcolumn for certain windows.
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

