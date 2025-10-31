
-- Mason. Manages language servers.
return {
  "mason-org/mason.nvim",
  opts = {
    ensure_installed = { "shellcheck" },
    install_root_dir = vim.fn.expand("~/.local/share/nvim/mason"),
  },
}
