
-- Set tab title dynamically for Yakuake terminal.

-- Find out if we are running in Yakuake.
local function read_proc(cmd)
  local h = io.popen(cmd)
  if not h then return nil end
  local res = h:read("*l")
  h:close()
  return res
end

local function is_yakuake()
  local pid = vim.fn.getpid()
  while pid ~= 1 do
    local proc = read_proc("ps -p " .. pid .. " -o comm=")
    if proc == "yakuake" then return true end
    local ppid = read_proc("ps -p " .. pid .. " -o ppid=")
    if not ppid or ppid == "" then break end
    pid = tonumber(ppid)
  end
  return false
end

if not is_yakuake() then return end

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
