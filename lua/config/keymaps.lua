
-- Keymaps used in only this configuration. Many from LazyVim.

local map = vim.keymap.set

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

-- These are remapped for switching buffers,
for _, mode in ipairs({ "n", "x", "o" }) do
  map(mode, "gH", "H", { desc = "Go to top of window" })
  map(mode, "gL", "L", { desc = "Go to bottom of window" })
end

map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })

map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Open Lazy" })

-- diagnostic
local diagnostic_goto = function(next, severity)
  return function()
    vim.diagnostic.jump({
      count = (next and 1 or -1) * vim.v.count1,
      severity = severity and vim.diagnostic.severity[severity] or nil,
      float = true,
    })
  end
end
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
map("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
map("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
map("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
map("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
map("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
map("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

-- new file
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

-- floating terminal
map("n", "<leader>ft", function() Snacks.terminal() end, { desc = "Terminal" })

vim.api.nvim_set_keymap( "v", "<LocalLeader>W", ":!fmt -w 80<CR>",
  { desc = "Wrap text to 80 char", noremap = true, silent = true }
)

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
