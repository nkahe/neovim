local map = vim.keymap.set


map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Open Lazy" })

map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })
map("n", "<leader>qQ", "<cmd>qa!<cr>", { desc = "Quit All without saving" })
