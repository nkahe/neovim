-- User commands for command mode

local create_cmd = vim.api.nvim_create_user_command

-- Expand alias when command line starts with that.
local function cabbrev(alias, expansion)
  vim.cmd(string.format(
    [[cnoreabbrev <expr> %s ((getcmdtype() == ':' && getcmdline() ==# '%s') ? '%s' : '%s')]],
    alias, alias, expansion, alias
  ))
end

cabbrev("reload", "Lazy reload")
cabbrev("check",  "Lazy check")
cabbrev("install", "Lazy install")
cabbrev("W", "w")
cabbrev("X", "x")
cabbrev("Wq", "wq")
cabbrev("WQ", "wq")
cabbrev("Qa", "qa")
cabbrev("QA", "qa")


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
    print('Yanked: ' .. target)
  else
    vim.notify('Path does not exist: ' .. target, vim.log.levels.ERROR )
  end
end, {
  nargs = '?',       -- optional argument
  complete = 'file', -- tab-completion for files
})

vim.keymap.set("n", "yp", ":Cppath %<CR>", { desc = "File's path" })


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

