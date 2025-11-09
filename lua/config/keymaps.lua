
-- Keymaps. Many are from LazyVim.

local map = vim.keymap.set

local nmap = function(lhs, rhs, desc)
  -- See `:h vim.keymap.set()`
  vim.keymap.set('n', lhs, rhs, { desc = desc })
end

local nmap_leader = function(suffix, rhs, desc)
  vim.keymap.set('n', '<Leader>' .. suffix, rhs, { desc = desc })
end
local xmap_leader = function(suffix, rhs, desc)
  vim.keymap.set('x', '<Leader>' .. suffix, rhs, { desc = desc })
end

-- Clear search with <esc>
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and Clear hlsearch" })

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
map( "n", "<leader>ur",
  "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
  { desc = "Redraw / Clear hlsearch / Diff Update" }
)

--keywordprg
map("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg" })

-- buffers
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>bd", function() Snacks.bufdelete() end, { desc = "Delete Buffer" })
map("n", "<leader>bo", function() Snacks.bufdelete.other() end, { desc = "Delete Other Buffers" })
map("n", "<leader>bD", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })

map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })

map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Open Lazy" })

-- new file
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

-- floating terminal
map("n", "<leader>ft", function() Snacks.terminal() end, { desc = "Terminal" })

-- C-g to show full path of a file instead of truncated one. LazyVim has similar.
vim.keymap.set("n", "<C-g>", function()
  local file = vim.fn.expand("%:p") or "[No Name]"
  local line = vim.fn.line(".")
  local col = vim.fn.col(".")
  local total = vim.fn.line("$")
  local percent = math.floor((line / total) * 100)
  vim.api.nvim_echo({
    { string.format("%s  line %d of %d --%d%%-- col %d", file, line, total, percent, col), "Normal" }
  }, false, {})
end, { desc = "Show full file path and cursor position" })

vim.api.nvim_set_keymap( "v", "<LocalLeader>W", ":!fmt -w 80<CR>",
  { desc = "Wrap text to 80 char", noremap = true, silent = true }
)

-- '"lua/config/keymaps.lua" line 51 of 147 --34%-- col 1

-- from mini.basics toggle buffer local options.
local toggle_prefix = [[\]]
local map_toggle = function(lhs, rhs, desc)
  map('n', toggle_prefix .. lhs, rhs, { desc = desc })
end
map_toggle('c', '<Cmd>setlocal cursorline! cursorline?<CR>',          "Toggle 'cursorline'")
map_toggle('C', '<Cmd>setlocal cursorcolumn! cursorcolumn?<CR>',      "Toggle 'cursorcolumn'")
map_toggle('i', '<Cmd>setlocal ignorecase! ignorecase?<CR>',          "Toggle 'ignorecase'")
map_toggle('l', '<Cmd>setlocal list! list?<CR>',                      "Toggle 'list'")
map_toggle('n', '<Cmd>setlocal number! number?<CR>',                  "Toggle 'number'")
map_toggle('r', '<Cmd>setlocal relativenumber! relativenumber?<CR>',  "Toggle 'relativenumber'")
map_toggle('s', '<Cmd>setlocal spell! spell?<CR>',                    "Toggle 'spell'")
map_toggle('w', '<Cmd>setlocal wrap! wrap?<CR>',                      "Toggle 'wrap'")

Snacks.toggle.option("showtabline", { off = 0, on = vim.o.showtabline > 0 and vim.o.showtabline or 2, name = "Tabline" }):map("<leader>uA")
Snacks.toggle.scroll():map("<leader>uS")
Snacks.toggle.profiler():map("<leader>dpp")
Snacks.toggle.profiler_highlights():map("<leader>dph")

-- location list.
map("n", "<leader>xl", function()
  local success, err = pcall(vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 and vim.cmd.lclose or vim.cmd.lopen)
  if not success and err then
    vim.notify(err, vim.log.levels.ERROR)
  end
end, { desc = "Location List" })

-- quickfix list
map("n", "<leader>xq", function()
 local success, err = pcall(vim.fn.getqflist({ winid = 0 }).winid ~= 0 and vim.cmd.cclose or vim.cmd.copen)
  if not success and err then
    vim.notify(err, vim.log.levels.ERROR)
  end
end, { desc = "Quickfix List" })

-- map_toggle('d', '<Cmd>lua print(MiniBasics.toggle_diagnostic())<CR>',                                      'Toggle diagnostic')
-- map_toggle('h', '<Cmd>let v:hlsearch = 1 - v:hlsearch | echo (v:hlsearch ? "  " : "no") . "hlsearch"<CR>', 'Toggle search highlight')

-- sessions
local session_new = 'MiniSessions.write(vim.fn.input("Session name: "))'
nmap_leader('qd', '<Cmd>lua MiniSessions.select("delete")<CR>', 'Delete')
nmap_leader('qn', '<Cmd>lua ' .. session_new .. '<CR>',         'New')
nmap_leader('qr', '<Cmd>lua MiniSessions.select("read")<CR>',   'Read')
nmap_leader('qw', '<Cmd>lua MiniSessions.write()<CR>',          'Write current')

-- Play last recorded macro.
map({ "n", "x" }, "Q", function()
  if vim.fn.mode() == "V" then
    return ':normal! @' .. vim.fn.reg_recorded() .. '<CR>'
  else
    return 'Q'
  end
end, { expr = true, silent = true, desc = "Play last macro" })

local function close_snacks_picker()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == "snacks_picker_list" then
      pcall(vim.api.nvim_win_close, win, true)
    end
  end
end

-- quit
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })
map("n", "<leader>qQ", "<cmd>qa!<cr>", { desc = "Quit All without saving" })

-- highlights under cursor
map("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })
map("n", "<leader>uI", function() vim.treesitter.inspect_tree() vim.api.nvim_input("I") end, { desc = "Inspect Tree" })

-- tabs
map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
map("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- lua
-- map({"n", "x"}, "<localleader>r", function() Snacks.debug.run() end, { desc = "Run Lua", ft = "lua" })
