
-- Obsidian.nvim https://github.com/obsidian-nvim/obsidian.nvim

-- Workspaces / Vaults.
local notes_dir = vim.fn.expand('~/Nextcloud/notes')
local localnotes_dir = vim.fn.expand('~/Documents/local_notes')

return {
  "obsidian-nvim/obsidian.nvim",
  version = "*",  -- recommended, use latest release instead of latest commit
  lazy = true,
  cmd = "Obsidian",
  ft = "markdown",
  -- ft = "markdown",
  -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
  -- event = {
  --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
  --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
  --   -- refer to `:h file-pattern` for more examples
  --   "BufReadPre " .. vim.fn.expand("~/Nextcloud/notes/**/*.md"),
  --   "BufNewFile " .. vim.fn.expand("~/Nextcloud/notes/**/*.md"),
  -- },
  -- ft = "markdown",
  event = {
    -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
    -- refer to `:h file-pattern` for more examples
    "BufReadPre " .. notes_dir .. "/*.md",
    "BufNewFile " .. notes_dir .. "/*.md",
    "BufNewFile " .. localnotes_dir .. "/*.md",
  },
  dependencies = { "nvim-lua/plenary.nvim", "folke/snacks.nvim"  },
  keys = {
    { "<Leader>sO", "<cmd>Obsidian search<CR>",       desc = "Obsidian search" },
    { "<Leader>ob", "<cmd>Obsidian backlinks<CR>",    desc = "Search backlinks" },
    { "<Leader>of", "<cmd>Obsidian follow_link<CR>",  desc = "Follow link" },
    { "<Leader>on", "<cmd>Obsidian new<CR>",          desc = "New note" },
    { "<Leader>oo", "<cmd>Obsidian open<CR>",         desc = "Open in Obsidian app" },
    { "<Leader>or", "<cmd>Obsidian rename<CR>",       desc = "Rename note" },
    { "<Leader>op", "<cmd>Obsidian paste_img<CR>",    desc = "Paste image" },
    { "<Leader>os", "<cmd>Obsidian search<CR>",       desc = "Search note" },
    { "<Leader>ot", "<cmd>Obsidian toc<CR>",          desc = "Search toc" },
    { "<Leader>oq", "<cmd>Obsidian quick_switch<CR>", desc = "Quick switch to note" },
    "BufReadPre " .. localnotes_dir .. "/*.md",
    { "<Leader>ow", "<cmd>Obsidian workspace<CR>",    desc = "Change workspace" },

   { "<Leader>oe", "<cmd>Obsidian extract_note<CR>", mode = "x",
      desc = "Extract note" },
   { "<Leader>ol", "<cmd>Obsidian link<CR>", mode = "x",
      desc = "Link selection to note" },
   { "<Leader>on", "<cmd>Obsidian link_new<CR>", mode = "x",
      desc = "Link new note to selection" },
  },
  init = function()
    -- Used in autocmd.
    -- Switch automatically to correct Obsidian workspace. (doesn't work if
    -- placed to config -function).

    -- Switch automatically to correct Obsidian workspace if .md file is part
    -- of known workspace. Track the last workspace to avoid redundant switches.
    local last_workspace = nil

    local function get_workspace_for_path(filepath)
      local workspaces = {
        { name = "notes", path = notes_dir },
        { name = "local", path = localnotes_dir },
      }

      for _, ws in ipairs(workspaces) do
        if filepath:find(vim.fn.escape(ws.path, ".*"), 1, true) == 1 then
          return ws.name
        end
      end
      return nil
    end

    vim.api.nvim_create_autocmd("BufEnter", {
      pattern = "*.md",
      callback = function()
        local filepath = vim.fn.expand("%:p")
        local workspace = get_workspace_for_path(filepath)
        if workspace and workspace ~= last_workspace then
          vim.cmd("Obsidian workspace " .. workspace)
          last_workspace = workspace
        end
      end,
    })

  end,
  ---@module 'obsidian'
  ---@type obsidian.config
  opts = {
    legacy_commands = false,
    ---@class obsidian.config.PickerOpts
    ---
    ---@field name obsidian.config.Picker|?
    picker = { name = 'snacks.pick' },
    workspaces = {
      {
        name = "notes",
        path = notes_dir,
      },
      {
        name = "local",
        path = localnotes_dir,
      },
    },
    "use_alias_only",
    checkbox = {
      order = { " ", "x"}
    },
    -- Both this plugin and render-markdown offer rendering of markdown files.
    -- It's not recommended to have both enabled so let's disable it.
    ui = {
      enable = false,
    }
  },
}
