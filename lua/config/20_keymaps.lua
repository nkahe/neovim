local map = vim.keymap.set

map("n", "<leader>e", "<cmd>Explore<cr>", { desc = "Explore" })

map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy.nvim" })

map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })
map("n", "<leader>qQ", "<cmd>qa!<cr>", { desc = "Quit All without saving" })
