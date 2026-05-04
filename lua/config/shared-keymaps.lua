
-- These keymaps are shared between Neovim configurations. keymaps.lua in
-- Lazyvim setup.

local map = vim.keymap.set

-- NOTE: For mappings "{ noremap = true }" is the default so no need to add that.

-- Registers ----------------------------------------------

-- Deleting without yanking

map({'n', 'v'}, "<leader>d", '"_d', { desc = "Delete without yanking"})
-- map("x", "<Leader>p", '"_dP', { desc = "Paste" }
-- AltGr + d in nordic layout
map({'n', 'v'}, "ð", '"_d', { desc = "Delete without yanking" })
-- AltGr-S-d in nordic keyboard.
map({'n', 'v'}, "Ð", '"_D', { desc = "Delete to end of line without yanking" })

-- Make commands that delete single characters not to yank to registers.
map({'n', 'v'}, "<Del>", '"_x', { desc = "which_key_ignore" })
map({'n', 'v'}, "<BS>", '"_X',  { desc = "which_key_ignore" })
map({'n', 'v'}, "x", '"_x', { desc = "Delete characters" })
map({'n', 'v'}, "X", '"_X', { desc = "Delete characters before cursor" })
map({'n', 'v'}, "s", '"_s', { desc = "Substitute characters" })
map({'n', 'v'}, "S", '"_S', { desc = "Substitute characters before cursor" })

-- GUI style copy/paste.
map('i', '<C-v>', '<C-o>"+P')
map('x', '<C-c>', '"+y')
-- Paste from primary (select) clipboard.
map({'n', 'v'}, '<S-Insert>', '"*P', { desc = "Paste selection" })
map('t', '<S-Insert>', '<C-\\><C-n>"*Pi')
map('i', '<S-Insert>', '<C-o>"*P')
map('c', '<S-Insert>', '<C-R>*')

-- Paste linewise before/after current line
map('n', '[p', '<Cmd>exe "put! " . v:register<CR>', { desc = 'Paste Above' })
map('n', ']p', '<Cmd>exe "put "  . v:register<CR>', { desc = 'Paste Below' })

-- Copy file name to clipboard
vim.keymap.set("n", "<leader>fN", function()
  local filename = vim.fn.expand("%:t")
  if filename == "" then
    vim.notify("No file associated with this buffer", vim.log.levels.ERROR)
    return
  end
  vim.fn.setreg("+", filename)
  vim.notify("Copied filename: " .. filename)
end, { desc = "Copy file name" })

-- For GUI only is in section at end part of file.

-- Misc ---------------------------------------------------

-- If making search while text is selected, insert selected text to search
-- while doing escaping if needed.
vim.keymap.set("x", "/", function()
  vim.cmd("normal! y")
  local text = vim.fn.getreg('"')
  local escaped = vim.fn.escape(text, '/\\.^$*[]')
  vim.api.nvim_feedkeys("/" .. escaped, "n", false)
end, { noremap = true, desc = "Search selected text"  })

vim.keymap.set("n", "<leader>fv", function()
  vim.api.nvim_feedkeys(
    vim.api.nvim_replace_termcodes(":%s/\\V", true, false, true),
    "n", false
  )
end, { desc = "Very nomagic substitute" })

-- Easier to type.
-- map("", "gh", '^', { desc = "To the first non-blank character of the line" })
-- map("", "gl", '$', { desc = "To the end of the line" })

-- Focus previous / next buffer
map({"n", "i"}, "<M-Right>", "<cmd>bnext<CR>", { silent = true })
map({"n", "i"}, "<M-Left>", "<cmd>bprevious<CR>", { silent = true })
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })

-- Search word under cursor and change it. n to go next and . to repeat.
vim.keymap.set("n", "c*", "g*Ncgn", { noremap = true })

-- Avoid accidentally pressing these.
map({ "x", "n" }, "<S-Down>",  "j")
map({ "x", "n" }, "<S-Up>",    "k")
map({ "x", "n" }, "<S-Right>", "l")
map({ "x", "n" }, "<S-Left>", "h")

--------------------------------------------------------------------------------
-- No VSCode compatible mappings after this
--------------------------------------------------------------------------------

if vim.g.vscode then return end

-- Center screen when searching or jumping.
for _, key in ipairs({ "n", "N", "G", "gg" }) do
  map("n", key, function() vim.cmd("normal! " .. key .. "zz") end)
end

map( "n", "<leader>fd", "<cmd>diffthis<CR>", { desc = "Diff this file" })

map( "v", "<LocalLeader>W", "<md>!fmt -w 80<CR>",
  { desc = "Wrap text to 80 char", noremap = true, silent = true }
)

-- Alt mappings can sometimes trigger with <esc> when using in terminal.

-- Moving lines also with arrow keys.
map("n", "<A-Down>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
map("n", "<A-Up>",   "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
map("i", "<A-Down>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-Up>",   "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<A-Down>", "<cmd>m '>+1<cr>gv=gv", { silent = true, desc = "Move down" })
map("v", "<A-Up>",   "<cmd>m '<-2<cr>gv=gv", { silent = true, desc = "Move up" })

map("n", "<M-l>", "<cmd>bnext<CR>", { silent = true })
map("n", "<M-h>", "<cmd>bprevious<CR>", { silent = true })

-- Expand to parent / child. Same shortcut as in Kakoune and Helix.
map({ 'x', 'o' }, '<M-o>', 'an', { remap = true })
map({ 'x', 'o' }, '<M-i>', 'in', { remap = true })

-- Add common shortcuts from GUI apps.
map("i", '<C-BS>', '<C-w>', { silent = true })
map("i", '<C-Del>', '<C-o>dw', { silent = true })

-- Terminal ------------------------------------------------

-- More terminal related bindings are defined in snacks.lua. These don't
-- use snacks because it gives me cliches with Neovide.
map("n", "<Leader>tb", "<CMD>terminal<CR>", { desc = "Open in new buffer" })

-- map("n", "<Leader>ts", function() vim.cmd("25split | terminal")  end,
--   { desc = "Open in split" })

map("n", "<Leader>tv", function() vim.cmd("vsplit | terminal")  end,
  { desc = "◨ Open in vertical split" })

map("n", "<Leader>ts", function() vim.cmd("split | terminal")  end,
  { desc = "◨ Open in horizontal split" })

-- Tap C-\ twice to exit terminal mode to normal mode. Default C-\ C-n. No
-- common <esc><esc> because <esc> is interpreted by shell's vi input mode.
map('t', [[<C-\><C-\>]], [[<C-\><C-n>]], { silent = true })
map('t', [[<C-q>]], [[<C-\><C-n>]], { silent = true })

-- Not all terminals support this keypress.
-- map("t", "<C-`>", "<cmd>close<cr>", { desc = "Hide Terminal" })

-- GUI --------------------------------------------------

-- Neovide
if vim.g.neovide then
  -- Clipboard commands similar to terminals.

  -- Paste main clipboard
  map({'n', 'v'}, '<C-S-v>', '"+P', { desc = "Paste from clipboard" })
  map('i', '<C-S-v>', '<C-o>"+P')
  map('t', '<C-S-v>', '<C-\\><C-n>"+Pi')
  map('c', '<C-S-v>', '<C-R>+')

  -- Copy
  map('v', '<C-S-c>', '"+y')

  local scale_factor = 1.05

  local zoom = function(factor)
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * factor
  end

  vim.keymap.set('n', '<C-+>', function() zoom(scale_factor) end)
  vim.keymap.set('n', '<C-->', function() zoom(1/scale_factor) end)
end
