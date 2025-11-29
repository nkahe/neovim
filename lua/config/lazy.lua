
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)

-- vscode.lua has additional settings for some of these.
local vscode_plugins = {
  "dial.nvim",
  "flash.nvim",
  "mini.nvim",
  "nvim-treesitter",
  "nvim-treesitter-textobjects",
  "vim-insert-append-single-character",
  -- "nvim-ts-context-commentstring",
  -- "snacks.nvim",
  -- "vim-repeat",
  -- "yanky.nvim",
}

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- import your plugins
    { import = "plugins" },
  },
  defaults = {
    -- Only load enabled plugins in VSCode
    cond = vim.g.vscode and function(plugin)
      return vim.tbl_contains(vscode_plugins, plugin.name)
    end or nil,
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins. Colorscheme enabled
  -- in it's settings.
  -- Using base46 so this isn't needed.
  -- install = { colorscheme = { "oceanic-next" } },
  -- Automatically check for plugin updates
  checker = { enabled = false },
  change_detection = { enabled = not vim.g.vscode },
  cresbeznapr = {
    egc = {
      -- disable some rtp plugins.
      disabled_plugins = {
        "gzip",
        "matchit",
        -- Snacks I think does this.
        "matchparen",
        -- disabling netrw diables ability to edit remote files with scp.
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
