local M = {}

-- Functions to Search symbols in file and workspace and goto definition using
-- LSP if available but fallback to ctags if not. Depends on mini.misc.

local function has_lsp_method(bufnr, method)
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  for _, client in ipairs(clients) do
    if client:supports_method(method) then
      return true
    end
  end
  return false
end

function M.pick()
  if has_lsp_method(0, "textDocument/documentSymbol") then
    Snacks.picker.lsp_symbols()
    return
  end
  M.pick_ctags_buffer()
end

function M.pick_workspace()
  if has_lsp_method(0, "workspace/symbol") then
    Snacks.picker.lsp_workspace_symbols()
    return
  end
  M.pick_ctags_project()
end

function M.goto_definition()
  if has_lsp_method(0, "textDocument/definition") then
    Snacks.picker.lsp_definitions()
    return
  end
  M.jump_to_tag_under_cursor()
end

local function project_root(bufnr)
  local ok_misc, misc = pcall(require, "mini.misc")
  if ok_misc and misc and misc.find_root then
    local root = misc.find_root(bufnr or 0)
    if root and root ~= "" then
      return root
    end
  end

  local name = vim.api.nvim_buf_get_name(bufnr or 0)
  if name ~= "" then
    local dir = vim.fn.fnamemodify(name, ":p:h")
    if dir ~= "" then
      return dir
    end
  end

  return vim.fn.getcwd()
end

function M.jump_to_tag_under_cursor()
  local symbol = vim.fn.expand("<cword>")
  if symbol == nil or symbol == "" then
    return
  end
  vim.cmd("tjump " .. vim.fn.fnameescape(symbol))
end

function M.jump_to_tag_entry(entry)
  if not entry or not entry.filename or entry.filename == "" then
    return
  end

  vim.cmd("edit " .. vim.fn.fnameescape(entry.filename))

  local lnum = tonumber(entry.cmd)
  if lnum then
    vim.api.nvim_win_set_cursor(0, { lnum, 0 })
    return
  end

  local cmd = entry.cmd or ""
  local pattern = cmd:match("^/(.*)/;\"$")
  if pattern and pattern ~= "" then
    vim.fn.search(pattern)
    return
  end

  if entry.name and entry.name ~= "" then
    vim.cmd("tjump " .. vim.fn.fnameescape(entry.name))
  end
end

function M.pick_ctags_buffer()
  local bufname = vim.api.nvim_buf_get_name(0)
  if bufname == "" then
    return
  end

  local current = vim.fn.fnamemodify(bufname, ":p")
  local tags = vim.fn.taglist(".*")
  local symbols = {}

  for _, tag in ipairs(tags) do
    local tagfile = tag.filename and vim.fn.fnamemodify(tag.filename, ":p") or ""
    if tagfile == current then
      table.insert(symbols, tag)
    end
  end

  if #symbols == 0 then
    vim.notify("No ctags symbols for this buffer. Save file to refresh tags.", vim.log.levels.INFO)
    return
  end

  table.sort(symbols, function(a, b)
    return (a.name or "") < (b.name or "")
  end)

  vim.ui.select(symbols, {
    prompt = "Symbols (ctags)",
    format_item = function(item)
      local kind = item.kind and item.kind ~= "" and (" [" .. item.kind .. "]") or ""
      return (item.name or "?") .. kind
    end,
  }, function(choice)
    if choice then
      M.jump_to_tag_entry(choice)
    end
  end)
end

function M.pick_ctags_project()
  local tags = vim.fn.taglist(".*")
  if #tags == 0 then
    vim.notify("No ctags symbols for project. Save file to refresh tags.", vim.log.levels.INFO)
    return
  end

  table.sort(tags, function(a, b)
    local an = a.name or ""
    local bn = b.name or ""
    if an == bn then
      return (a.filename or "") < (b.filename or "")
    end
    return an < bn
  end)

  local cwd = vim.fn.getcwd()
  vim.ui.select(tags, {
    prompt = "Workspace Symbols (ctags)",
    format_item = function(item)
      local kind = item.kind and item.kind ~= "" and (" [" .. item.kind .. "]") or ""
      local file = item.filename or "?"
      file = vim.fn.fnamemodify(file, ":.")
      if file == item.filename then
        file = vim.fn.fnamemodify(file, ":~")
      end
      if cwd ~= "" and file == "." then
        file = vim.fn.fnamemodify(item.filename or "?", ":t")
      end
      return (item.name or "?") .. kind .. "  " .. file
    end,
  }, function(choice)
    if choice then
      M.jump_to_tag_entry(choice)
    end
  end)
end

function M.refresh_tags_for_project(bufnr)
  if vim.fn.executable("ctags") ~= 1 then
    return
  end

  local root = project_root(bufnr)
  local tags_dir = root .. "/.ctags.d"
  local tags_file = tags_dir .. "/tags"
  vim.fn.mkdir(tags_dir, "p")

  -- Keep project-specific excludes/options in <project>/.ctags.d/*.ctags.
  vim.system({
    "ctags",
    "-R",
    "--tag-relative=never",
    "--langmap=Basic:+.vbs",
    "-f",
    tags_file,
    ".",
  }, { cwd = root }, function(obj)
    if obj.code ~= 0 then
      vim.schedule(function()
        vim.notify("ctags failed for project", vim.log.levels.WARN)
      end)
    end
  end)
end

return M
