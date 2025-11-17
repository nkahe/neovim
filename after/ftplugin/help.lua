
-- maximize height for help windows
vim.cmd("wincmd _")

-- optional: keep help at fixed height unless manually resized
vim.opt_local.winfixheight = true

-- Open links with Enter.
vim.api.nvim_buf_set_keymap(0, "n", "<CR>", "<C-]>", { silent = true })
