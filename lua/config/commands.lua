
-- User commands for command mode

local LazyConfig = require("lazy.core.config")
local LazyLoader = require("lazy.core.loader")
local create_cmd = vim.api.nvim_create_user_command

-- Set prefix used in autocmd with sets window titles.
create_cmd( 'Title', function(opts)
    _G.Config = _G.Config or {}
    _G.Config.windowtitle = opts.args
  vim.cmd("doautocmd BufEnter") -- Trigger autocmd that sets title.
  end,
  { nargs = 1 } -- Requires exactly one argument
)

-- Clear oldfiles eg. recent files.
vim.api.nvim_create_user_command("ClearRecent", function()
  vim.cmd([[
    rshada!
    let g:oldfiles = []
    wshada!
  ]])
  print("Cleared all recent files.")
end, {})

-- Trim oldfiles eg. entries with are not under cwd.
vim.api.nvim_create_user_command("TrimRecent", function()
  local cwd = vim.fn.getcwd()
  local oldfiles = vim.v.oldfiles or {}
  local keep = {}

  for _, path in ipairs(oldfiles) do
    if vim.startswith(path, cwd) then
      table.insert(keep, path)
    end
  end

  -- Save the filtered list to ShaDa
  vim.fn.writefile(keep, vim.fn.stdpath("state") .. "/shada.tmp")
  vim.cmd("rshada!")
  vim.g.oldfiles = keep
  vim.cmd("wshada!")
  print("Trimmed recent files to those under: " .. cwd)
end, {})

-- Copy path of gives file/dir to clipboard.
create_cmd('Cppath', function(opts)
  local target = opts.args

  if target == '' then  -- If no argument given, use current working directory
    target = vim.loop.cwd()
  else
    target = vim.fn.expand(target)  -- Expand things like % (current file) or ~
  end

  target = vim.fn.fnamemodify(target, ":p")  -- Convert to absolute path

  -- Check if it exists
  if vim.fn.filereadable(target) == 1 or vim.fn.isdirectory(target) == 1 then
    vim.fn.setreg('+', target)  -- copy to system clipboard
    print('Copied to clipboard: ' .. target)
  else
    vim.notify('Path does not exist: ' .. target, vim.log.levels.ERROR )
  end
end, {
  nargs = '?',       -- optional argument
  complete = 'file', -- tab-completion for files
})

vim.keymap.set("n", "<leader>fP", ":Cppath %<CR>", { desc = "Copy file's path" })

-- Change cwd to match current buffer's directory
create_cmd('Cdb', function()
  vim.cmd('cd ' .. vim.fn.expand('%:p:h'))
  vim.cmd('pwd')
end, { desc = "Change cwd to match current buffer's directory" })

-- Create a command :RecoverDiff to compare recovered buffer vs original file
vim.api.nvim_create_user_command('RecoverDiff', function()
  local bufname = vim.api.nvim_buf_get_name(0)
  if bufname == '' then
    print('No file associated with current buffer')
    return
  end

  -- Get recovered buffer name (usually already loaded after choosing "Recover")
  local original = vim.fn.fnamemodify(bufname, ':p')
  if vim.fn.filereadable(original) == 0 then
    print('Original file does not exist: ' .. original)
    return
  end

  -- Open the original file in a vertical diff split
  vim.cmd('vert diffsplit ' .. vim.fn.fnameescape(original))
  print('Comparing recovered buffer ↔ original file')
end, {})


local function smart_vdiff(file)
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.wo[win].diff then
      vim.api.nvim_set_current_win(win)
      vim.cmd("edit " .. vim.fn.fnameescape(file))
      return
    end
  end
  vim.cmd("vert diffsplit " .. vim.fn.fnameescape(file))
end

vim.api.nvim_create_user_command("Diff", function(opts)
  smart_vdiff(opts.args)
end, { nargs = 1, complete = "file" })

-- Trim trailing whitespace from the buffer
create_cmd('Trim', function()
  local save_cursor = vim.fn.getpos(".")
  -- Save view state for visual mode users
  local save_view = vim.fn.winsaveview()
  -- Perform the substitution to trim trailing whitespace
  vim.cmd([[keeppatterns %s/\v\s+$//e]])
  -- Restore cursor position and view state
  vim.fn.setpos(".", save_cursor)
  vim.fn.winrestview(save_view)
end, { desc = "Trim trailing whitespace from the buffer" })

local function source_config_files()
  local basepath = vim.fn.stdpath("config") .. "/lua/config"
  local files = vim.fn.globpath(basepath, "**/*.lua", false, true)
  table.sort(files)

  local sourced = {}
  for _, file in ipairs(files) do
    local name = vim.fn.fnamemodify(file, ":t")
    if name ~= "commands.lua" and name ~= "lazy.lua" then
      local ok, err = pcall(dofile, file)
      if not ok then
        return false, file, err
      end
      sourced[#sourced + 1] = name
    end
  end

  return true, sourced
end

local function reload_plugin(name)
  local plugin = LazyConfig.plugins[name]
  if not plugin then
    return false
  end
  LazyLoader.reload(plugin)
  return true
end

-- Reload <plugin> reloads a plugin. Without arguments reloads config files.
create_cmd("Reload", function(opts)
  if opts.args ~= "" then
    if reload_plugin(opts.args) then
      vim.notify(("Reloaded plugin: %s"):format(opts.args), vim.log.levels.INFO)
    else
      vim.notify(("No plugin matched: %s"):format(opts.args), vim.log.levels.WARN)
    end
  else
    local ok, result, err = source_config_files()
    if not ok then
      vim.notify(("Failed to source %s"):format(vim.fn.fnamemodify(result, ":t")), vim.log.levels.ERROR)
      if err then
        vim.notify(err, vim.log.levels.ERROR)
      end
      return
    end
    vim.notify("Sourced lua/config/*.lua", vim.log.levels.INFO)
  end
end, {
  nargs = "?",
  complete = function(arglead)
    local prefix = arglead or ""
    return vim.tbl_filter(function(name)
      return name:find(prefix, 1, true) == 1
    end, vim.tbl_keys(LazyConfig.plugins))
  end,
  desc = "Reload settings",
})

-- Accept some typos.
vim.keymap.set("ca", "W", "w")
vim.keymap.set("ca", "Wq", "wq")
vim.keymap.set("ca", "WQ", "wq")
vim.keymap.set("ca", "Qa", "qa")
vim.keymap.set("ca", "QA", "qa")
vim.keymap.set("ca", "X", "x")
