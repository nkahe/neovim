
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

-- Reload config files.
create_cmd("Reload", function(opts)
    local ok, result, err = source_config_files()
    if not ok then
      vim.notify(("Failed to source %s"):format(vim.fn.fnamemodify(result, ":t")), vim.log.levels.ERROR)
      if err then
        vim.notify(err, vim.log.levels.ERROR)
      end
      return
    end
    vim.notify("Sourced lua/config/*.lua", vim.log.levels.INFO)

end, {})

