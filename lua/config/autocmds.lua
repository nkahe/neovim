
-- Helper to set autogroup with prefix.
local function augroup(name)
  return vim.api.nvim_create_augroup("Custom_" .. name, { clear = true })
end

-- Set variable for window title prefix to session name if session if set wither
-- by --NVIM_SESSION env variable or -S <session> command line parameter. Env
-- variable can be used to no full path to session file is needed.
vim.api.nvim_create_autocmd("VimEnter", {
  group = augroup('start_with_session'),
  callback = function()
    local session = vim.env.NVIM_SESSION

    if session ~= nil then
      vim.schedule(function()
        -- pcall(function() require("mini.sessions").read(session) end)
      end)
    else
      session = vim.v.this_session
      if session or session == "" then
        return
      end
    end

    -- don't override when files were passed
    -- if vim.fn.argc() > 0 then
    --   return
    -- end

    _G.Config.windowtitle = session
  end,
})

-- Set title for terminals and start in insert mode.
-- Adding "TermOpen" made exiting from Terminal mode in Sidekick to immediately
-- go back to terminal mode.
vim.api.nvim_create_autocmd({ "WinEnter" }, {
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

-- Command mode aliases.
local aliases = {
  ["~config"] = vim.fn.expand("~/.config"),
  ["~custom"] = vim.fn.expand("~/.config/nvim/custom"),
  ["~ndata" ] = vim.fn.expand("~/.local/share/nvim"),
  ["~notes" ] = vim.fn.expand("~/Nextcloud/notes"),
  [ "~nvim" ] = vim.fn.expand("~/.config/nvim"),
  ["~share" ] = vim.fn.expand("~/.local/share"),
  [ "~zsh"  ] = vim.fn.expand("~/.config"),
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

local function clear_cmdarea()
  vim.defer_fn(function()
    pcall(vim.api.nvim_echo, {}, false, {})
  end, 800)
end

local timer = vim.uv.new_timer()
local save_notification = false

-- Autosave normal buffers.
vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
  group = augroup("autosave"),

  callback = function(args)
    local buf = args.buf

    -- skip invalid/special and unnamed buffers
    if vim.bo[buf].buftype ~= "" or vim.api.nvim_buf_get_name(buf) == "" then
      return
    end

    -- not modified
    if not vim.bo[buf].modified then
      return
    end

    -- not writable
    if not vim.bo[buf].modifiable or vim.bo[buf].readonly then
      return
    end

    if not timer then
      return
    end

    timer:stop()

    timer:start(3000, 0, vim.schedule_wrap(function()
      -- write silently without changing current buffer
      local ok = pcall(vim.api.nvim_buf_call, buf, function()
        vim.cmd("silent! write")
      end)

      if ok and save_notification then
        local time = os.date("%H:%M")

        vim.api.nvim_echo({
          { "󰄳 ", "LazyProgressDone" },
          { "Autosaved at " .. time, "Comment" },
        }, false, {})

        clear_cmdarea()
      end
    end))

  end})

-- Hot reloading configs. Watches for saves specifically in the `lua/config/keymaps.lua`
-- and `lua/config/options.lua`.
local config_path = vim.fn.stdpath("config") .. "/lua/config/"

if vim.fn.isdirectory(config_path) == 1 then
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
end

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
      map("n", "\\o", "<Cmd>diffoff!<CR>",   { buffer = true, desc = "Diff off! (tab)"})
      map("n", "\\u", "<Cmd>diffupdate<CR>", { buffer = true, desc = "Diff update"})
      map("n", "\\O", "<Cmd>diffoff<CR>",    { buffer = true, desc = "Diff off (window)"})
    end
  end,
})


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

-- Set window title. Set title prefix which is based on Neovim config, session
-- or manually set (user-command).
vim.api.nvim_create_autocmd({ "BufEnter", "TermClose" }, {
  group = augroup("set_window_title"),
  callback = function()
    if vim.bo.buftype == "terminal" then   -- Set in TermOpen.
      return
    end
    local prefix = (_G.Config and _G.Config.windowtitle) or "Neovim"

    local filename = vim.fn.expand("%:t")  -- Normal buffer
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

-- Set background color for terminal. Neovim doesn't have exclusive highlights
-- groups for it natively.
-- NOTE: For Snacks.terminal this doesn't work but it has similar setting added
-- in it's config.

-- Fallback if colors aren't defined.
vim.api.nvim_set_hl(0, "TermBgFallback", { bg = "#121212" })
vim.api.nvim_set_hl(0, "NoBackground",   { bg = "none" })

vim.api.nvim_create_autocmd({ "TermOpen", "WinEnter"  }, {
  group = augroup("set_terminal_background_color"),
  pattern = "*",
  callback = function()
    if vim.bo.buftype == "terminal" or vim.bo.filetype == "snacks_terminal" then
      local bg_group = vim.g.TermBackground and "TermBackground" or "TermBgFallback"
      vim.opt_local.winhighlight = table.concat({
        "Normal:" .. bg_group,
        "CursorLine:NoBackground",
      }, ",")
    end
  end,
})

--
-- vim.api.nvim_create_autocmd({ "TermOpen", "WinEnter"  }, {
--   group = augroup("set_terminal_title"),
--   pattern = "*",
--   callback = function()
--       vim.api.nvim_buf_set_name(0, "terminal")
--   end,
-- })
--

-- For .lua and .vim files: ~ource current file . Lua specific are
-- keymaps are in after/ftplugin/.
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "lua", "vim" },
  callback = function()
    vim.keymap.set("n", "<Leader>fs", function()
      local file = vim.fn.expand("%:p")

      if vim.bo.filetype == "lua" then
        vim.cmd("luafile " .. vim.fn.fnameescape(file))
      else
        vim.cmd("source " .. vim.fn.fnameescape(file))
      end

      vim.notify("Sourced current file", vim.log.levels.INFO)
    end, { buffer = true, desc = "Source current file" })
  end,
})

-- Recognize some file types based on file name.
vim.filetype.add({
  group = augroup("set_filetype"),
  filename = {
    ["todo.txt"] = "todotxt",
  },
})

-- Refresh project tags for selected file types after save.
vim.api.nvim_create_autocmd("BufWritePost", {
  group = augroup("update_ctags"),
  pattern = { "*.vbs", "*.zsh" },
  callback = function(args)
    require("plugins.local.symbols").refresh_tags_for_project(args.buf)
  end,
})

-- Disable colorcolumn for certain windows.
vim.api.nvim_create_autocmd("WinEnter", {
  group = augroup("disable_colorcolumn"),
  callback = function()
    local cfg = vim.api.nvim_win_get_config(0)
    if cfg.relative ~= "" then  -- For floating windows
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
  -- Applies to Quickfix commands, not location list
  pattern = "[^l]*", -- Words starting with 'l.
  callback = function()
    vim.cmd("botright copen")
  end,
})

-- Open location list after search
vim.api.nvim_create_autocmd("QuickFixCmdPost", {
  group = augroup("open_locationlist_below"),
  pattern = "lgrep",
  callback = function()
    vim.cmd("lopen")
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
