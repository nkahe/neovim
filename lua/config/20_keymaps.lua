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

map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Open Lazy" })

-- mini.sessions
local session_new = 'MiniSessions.write(vim.fn.input("Session name: "))'
nmap_leader('qd', '<Cmd>lua MiniSessions.select("delete")<CR>', 'Delete')
nmap_leader('qn', '<Cmd>lua ' .. session_new .. '<CR>',         'New')
nmap_leader('qr', '<Cmd>lua MiniSessions.select("read")<CR>',   'Read')
nmap_leader('qw', '<Cmd>lua MiniSessions.write()<CR>',          'Write current')

map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })
map("n", "<leader>qQ", "<cmd>qa!<cr>", { desc = "Quit All without saving" })

-- from mini.basics toggle buffer local options.
local toggle_prefix = [[\]]
local map_toggle = function(lhs, rhs, desc) map('n', toggle_prefix .. lhs, rhs, { desc = desc }) end
map_toggle('c', '<Cmd>setlocal cursorline! cursorline?<CR>',                                               "Toggle 'cursorline'")
map_toggle('C', '<Cmd>setlocal cursorcolumn! cursorcolumn?<CR>',                                           "Toggle 'cursorcolumn'")
map_toggle('i', '<Cmd>setlocal ignorecase! ignorecase?<CR>',                                               "Toggle 'ignorecase'")
map_toggle('l', '<Cmd>setlocal list! list?<CR>',                                                           "Toggle 'list'")
map_toggle('n', '<Cmd>setlocal number! number?<CR>',                                                       "Toggle 'number'")
map_toggle('r', '<Cmd>setlocal relativenumber! relativenumber?<CR>',                                       "Toggle 'relativenumber'")
map_toggle('s', '<Cmd>setlocal spell! spell?<CR>',                                                         "Toggle 'spell'")
map_toggle('w', '<Cmd>setlocal wrap! wrap?<CR>',                                                           "Toggle 'wrap'")

-- map_toggle('d', '<Cmd>lua print(MiniBasics.toggle_diagnostic())<CR>',                                      'Toggle diagnostic')
-- map_toggle('h', '<Cmd>let v:hlsearch = 1 - v:hlsearch | echo (v:hlsearch ? "  " : "no") . "hlsearch"<CR>', 'Toggle search highlight')
