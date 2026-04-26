
  -- From LazyVim with some commented changes.
  return {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons", -- optional, but recommended
    },
    lazy = false,   -- neo-tree will lazily load itself
    cmd = "Neotree",
    enabled = true,
    keys = {
      {
        "<leader>e", function()
          local buf = vim.api.nvim_get_current_buf()
          -- Use root definition from Mini.misc instead of LazyVim.
          local root = require("mini.misc").find_root(buf) or vim.loop.cwd()
          require("neo-tree.command").execute({ toggle = true, dir = root })
        end, desc = "Explorer NeoTree (root)",

        -- local root = require("mini.misc").find_root(buf)
      },
      -- Lazyvim default
      -- { "<leader>e", "<leader>fe", desc = "Explorer NeoTree (Root Dir)", remap = true },
      {
        "<leader>E", function()
          require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
        end,
        desc = "Explorer NeoTree (cwd)",
      },
      { "<leader>fe", "<leader>e", desc = "Explorer NeoTree (root)", remap = true },
      { "<leader>fE", "<leader>E", desc = "Explorer NeoTree (cwd)", remap = true },
      {
        "<leader>ge", function()
          require("neo-tree.command").execute({ source = "git_status", toggle = true })
        end,
        desc = "Git Explorer (NeoTree)",
      },
      {
        "<leader>be", function()
          require("neo-tree.command").execute({ source = "buffers", toggle = true })
        end,
        desc = "Buffer Explorer",
      },
    },
    deactivate = function() vim.cmd([[Neotree close]]) end,
    -- init = function()
    -- FIX: use `autocmd` for lazy-loading neo-tree instead of directly requiring it,
    -- because `cwd` is not set up properly.
    --   vim.api.nvim_create_autocmd("BufEnter", {
    --     group = vim.api.nvim_create_augroup("Neotree_start_directory", { clear = true }),
    --     desc = "Start Neo-tree with directory",
    --     once = true,
    --     callback = function()
    --       if package.loaded["neo-tree"] then
    --         return
    --       else
    --         local stats = vim.uv.fs_stat(vim.fn.argv(0))
    --         if stats and stats.type == "directory" then
    --           require("neo-tree")
    --         end
    --       end
    --     end,
    --   })
    -- end,
    opts = {
      sources = { "filesystem", "buffers", "git_status" },
      source_selector = {
        winbar = true,
        content_layout = "center",
      },
      open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = {
          enabled = true,
          leave_dirs_open = false, -- Optional: Determines whether to close other directories when following
        },
        -- filtered_items = {
        --   hide_dotfiles = false, -- Adjust other filtering options as needed
        --   hide_by_name = { ".git", "node_modules" }, -- Example filters
        -- },
        use_libuv_file_watcher = true,
        search_command = "fd --follow", -- Follow symlinks while searching
        hijack_netrw_behavior = "open_default", -- Relevant for symlink resolution
      },

      window = {
        mappings = {
          -- Neovim default search. Jump to name without doing resursive search.
          ["/"] = { function()
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("/", true, false, true), "n", true)
          end },
          -- This is recursive search mapped by default to /.
          ["F"] = "fuzzy_finder",
          ["l"] = "open",
          ["h"] = "close_node",
          ["Y"] = {
            function(state)
              local node = state.tree:get_node()
              local path = node:get_id()
              vim.fn.setreg("+", path, "c")
            end,
            desc = "Copy Path to Clipboard",
          },
          -- ["O"] = {
          --   function(state)
          --     require("lazy.util").open(state.tree:get_node().path, { system = true })
          --   end,
          --   desc = "Open with System Application",
          -- },
          ["M-p"] = { "toggle_preview", config = { use_float = false } },
        },
      },
      default_component_configs = {
        indent = {
          with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
          expander_collapsed = "",
          expander_expanded = "",
          expander_highlight = "NeoTreeExpander",
          symlink_target = { enabled = true },
        },
        git_status = {
          symbols = {
            -- unstaged = "󰄱",
            -- staged = "󰱒",
            -- added     = "✚",
            -- deleted   = "✖",
            -- modified  = "",
            -- renamed   = "󰁕",
            -- -- Status type
            -- untracked = "",
            -- ignored   = "",
            -- unstaged  = "󰄱",
            -- staged    = "",
            -- conflict  = "",
          },
        },
      },
    },

    config = function(_, opts)
      local function on_move(data)
        Snacks.rename.on_rename_file(data.source, data.destination)
      end

      local events = require("neo-tree.events")
      opts.event_handlers = opts.event_handlers or {}
      vim.list_extend(opts.event_handlers, {
        { event = events.FILE_MOVED, handler = on_move },
        { event = events.FILE_RENAMED, handler = on_move },
      })
      require("neo-tree").setup(opts)
    end,
  }
