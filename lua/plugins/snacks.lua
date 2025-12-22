
-- if true then return {} end

-- Terminal Mappings
local function term_nav(dir)
  ---@param self snacks.terminal
  return function(self)
    return self:is_floating() and "<c-" .. dir .. ">" or vim.schedule(function()
      vim.cmd.wincmd(dir)
    end)
  end
end

return
  {
  "folke/snacks.nvim",
  enabled = true,
  priority = 1000,
  lazy = false,
  opts = {
    bigfile = { enabled = true },
    dashboard = {
      enabled = true,
      preset = {
        keys = {
          -- Same as in Lazyvim but change session manager to mini.sessions.
          { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
          { icon = " ", key = "s", desc = "Load latest session",
            action = function()
              local MiniSessions = require("mini.sessions")
              local latest = MiniSessions.get_latest()
              if latest then
                _G.Config.windowtitle = latest
                MiniSessions.read(latest)
              else
                vim.notify("No sessions found", vim.log.levels.WARN)
              end
            end
          },
          -- Defaults
          -- { icon = " ", key = "s", desc = "Restore last session", action = function() require("persistence").load({ last = true }) end },
          -- { icon = " ", key = "S", desc = "Select session", action = function() require("persistence").select() end },
          { icon = " ", key = "S", desc = "Select session", action = function()
              require("mini.sessions").select("read")
            end, },
          { icon = "󰒲 ", key = "l", desc = "Open Lazy", action = ":Lazy" },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1,
            action = function(project_dir)
              local Sessions = require("mini.sessions")

              -- turn /home/.../foo -> "foo"
              local name = vim.fs.basename(project_dir)

              -- if a session for that name exists, load it.
              local detected = Sessions.detected
              if detected[name] then
                _G.Config.windowtitle = name
                Sessions.read(name)
                return
              end

              -- fallback: just open the directory and pick a file.
              vim.cmd("cd " .. vim.fn.fnameescape(project_dir))
              require("snacks").dashboard.pick("files")
            end,
          },
        },
      },
    },

    -- Defaults:
    -- <leader>e	Explorer Snacks (root dir)
    -- <leader>E	Explorer Snacks (cwd)
    explorer = {
      enabled = false,
    },

    indent = { enabled = true },

    input = { enabled = true },

    -- Notification style such as wrap is defined in snacks.styles -module.
    notifier = {
      enabled = true,
      style = "minimal",
        -- Timeout for notifications longer so can actually read them.
      timeout = 6000,
      margin = { top = 1, right = 1, bottom = 1 },
      padding = true, -- add 1 cell of left/right padding to the notification window
      gap = 0, -- gap between notifications
    },

    picker = {
      enabled = true,
      explorer = {
        layout = {
          -- Doesn't work for input.
          hidden = { "preview", "input" },
        },
      },
      layout = {
        preset = "ivy",
        preview = false
      },
      sources = {
        files = {
          hidden = true
        },
        explorer = {
          diagnostics = false
        },
      },
      win = {
        input = {
          keys = {
            -- Change nicer descriptions.

            -- to close the picker on ESC instead of going to normal mode,
            -- add the following keymap to your config
            -- ["<Esc>"] = { "close", mode = { "n", "i" } },
              ["/"] = { "toggle_focus", desc = "Toggle focus" },
              ["<C-Down>"] = { "history_forward", mode = { "i", "n" }, desc = "History forward" },
              ["<C-Up>"] = { "history_back", mode = { "i", "n" }, desc = "History back" },
              ["<C-c>"] = { "cancel", mode = "i", desc = "Cancel" },
              ["<C-w>"] = { "<c-s-w>", mode = { "i" }, expr = true, desc = "Delete word" },
              ["<CR>"] = { "confirm", mode = { "n", "i" }, desc = "Confirm" },
              ["<Down>"] = { "list_down", mode = { "i", "n" }, desc = "List down" },
              ["<Esc>"] = { "cancel", desc = "Cancel" },
              ["<S-CR>"] = { { "pick_win", "jump" }, mode = { "n", "i" }, desc = "Pick win / jump" },
              ["<S-Tab>"] = { "select_and_prev", mode = { "i", "n" }, desc = "Select and prev" },
              ["<Tab>"] = { "select_and_next", mode = { "i", "n" }, desc = "Select and next" },
              ["<Up>"] = { "list_up", mode = { "i", "n" }, desc = "List up" },
              ["<a-d>"] = { "inspect", mode = { "n", "i" }, desc = "Inspect" },
              ["<a-f>"] = { "toggle_follow", mode = { "i", "n" }, desc = "Toggle follow" },
              ["<a-h>"] = { "toggle_hidden", mode = { "i", "n" }, desc = "Toggle hidden" },
              ["<a-i>"] = { "toggle_ignored", mode = { "i", "n" }, desc = "Toggle ignored" },
              ["<a-r>"] = { "toggle_regex", mode = { "i", "n" }, desc = "Toggle regex" },
              ["<a-m>"] = { "toggle_maximize", mode = { "i", "n" }, desc = "Toggle maximize" },
              ["<a-p>"] = { "toggle_preview", mode = { "i", "n" }, desc = "Toggle preview" },
              ["<a-w>"] = { "cycle_win", mode = { "i", "n" }, desc = "Cycle win" },
              ["<c-a>"] = { "select_all", mode = { "n", "i" }, desc = "Select all" },
              ["<c-b>"] = { "preview_scroll_up", mode = { "i", "n" }, desc = "Scroll preview up" },
              ["<c-d>"] = { "list_scroll_down", mode = { "i", "n" }, desc = "Scroll list down" },
              ["<c-f>"] = { "preview_scroll_down", mode = { "i", "n" }, desc = "Scroll preview down" },
              ["<c-g>"] = { "toggle_live", mode = { "i", "n" }, desc = "Toggle live" },
              ["<c-j>"] = { "list_down", mode = { "i", "n" }, desc = "List down" },
              ["<c-k>"] = { "list_up", mode = { "i", "n" }, desc = "List up" },
              ["<c-n>"] = { "list_down", mode = { "i", "n" }, desc = "List down" },
              ["<c-p>"] = { "list_up", mode = { "i", "n" }, desc = "List up" },
              ["<c-q>"] = { "qflist", mode = { "i", "n" }, desc = "Send to quickfix" },
              ["<c-s>"] = { "edit_split", mode = { "i", "n" }, desc = "Edit split" },
              ["<c-t>"] = { "tab", mode = { "n", "i" }, desc = "Tab" },
              ["<c-u>"] = { "list_scroll_up", mode = { "i", "n" }, desc = "Scroll list up" },
              ["<c-v>"] = { "edit_vsplit", mode = { "i", "n" }, desc = "Edit vsplit" },
              ["<c-r>#"] = { "insert_alt", mode = "i", desc = "Insert alt" },
              ["<c-r>%"] = { "insert_filename", mode = "i", desc = "Insert filename" },
              ["<c-r><c-a>"] = { "insert_cWORD", mode = "i", desc = "Insert cWORD" },
              ["<c-r><c-f>"] = { "insert_file", mode = "i", desc = "Insert file" },
              ["<c-r><c-l>"] = { "insert_line", mode = "i", desc = "Insert line" },
              ["<c-r><c-p>"] = { "insert_file_full", mode = "i", desc = "Insert file full" },
              ["<c-r><c-w>"] = { "insert_cword", mode = "i", desc = "Insert cword" },
              ["<c-w>H"] = { "layout_left", desc = "Layout left" },
              ["<c-w>J"] = { "layout_bottom", desc = "Layout bottom" },
              ["<c-w>K"] = { "layout_top", desc = "Layout top" },
              ["<c-w>L"] = { "layout_right", desc = "Layout right" },
              ["?"] = { "toggle_help_input", desc = "Toggle help input" },
              ["G"] = { "list_bottom", desc = "List bottom" },
              ["gg"] = { "list_top", desc = "List top" },
              ["j"] = { "list_down", desc = "List down" },
              ["k"] = { "list_up", desc = "List up" },
              ["q"] = { "cancel", desc = "Cancel" },
          },
        },
        list = {
            keys = {
              -- Change nicer descriptions.
              ["/"] = { "toggle_focus", desc = "Toggle focus between list and input" },
              ["<2-LeftMouse>"] = { "confirm", desc = "Open or confirm selection" },
              ["<CR>"] = { "confirm", desc = "Open or confirm selection" },
              ["<Down>"] = { "list_down", desc = "Move down" },
              ["<Esc>"] = { "cancel", desc = "Close / cancel" },
              ["<S-CR>"] = { { "pick_win", "jump" }, desc = "Pick window / jump" },
              ["<S-Tab>"] = { "select_and_prev", mode = { "n", "x" }, desc = "Select & move up" },
              ["<Tab>"] = { "select_and_next", mode = { "n", "x" }, desc = "Select & move down" },
              ["<Up>" ] = { "list_up", desc = "Move up" },
              ["<a-d>"] = { "inspect", desc = "Inspect item" },
              ["<a-f>"] = { "toggle_follow", desc = "Toggle follow" },
              ["<a-h>"] = { "toggle_hidden", desc = "Toggle hidden files" },
              ["<a-i>"] = { "toggle_ignored", desc = "Toggle ignored files" },
              ["<a-m>"] = { "toggle_maximize", desc = "Toggle maximize" },
              ["<a-p>"] = { "toggle_preview", desc = "Toggle preview" },
              ["<a-w>"] = { "cycle_win", desc = "Cycle window" },
              ["<c-a>"] = { "select_all", desc = "Select all" },
              ["<c-b>"] = { "preview_scroll_up",  desc = "Scroll preview up" },
              ["<c-d>"] = { "list_scroll_down", desc = "Scroll list down" },
              ["<c-f>"] = { "preview_scroll_down", desc = "Scroll preview down" },
              ["<c-j>"] = { "list_down", desc = "Move down" },
              ["<c-k>"] = { "list_up", desc = "Move up" },
              ["<c-n>"] = { "list_down", desc = "Next item" },
              ["<c-p>"] = { "list_up", desc = "Previous item" },
              ["<c-q>"] = { "qflist", desc = "Send to quickfix" },
              ["<c-g>"] = { "print_path", desc = "Print path" },
              ["<c-s>"] = { "edit_split", desc = "Open in split" },
              ["<c-t>"] = { "tab", desc = "Open in tab" },
              ["<c-u>"] = { "list_scroll_up", desc = "Scroll up" },
              ["<c-v>"] = { "edit_vsplit", desc = "Open in vertical split" },
              ["<c-w>H"] = { "layout_left", desc = "Move layout left" },
              ["<c-w>J"] = { "layout_bottom", desc = "Move layout bottom" },
              ["<c-w>K"] = { "layout_top", desc = "Move layout top" },
              ["<c-w>L"] = { "layout_right", desc = "Move layout right" },
              ["?"] = { "toggle_help_list", desc = "Toggle help list" },
              ["G"] = { "list_bottom", desc = "Go to bottom" },
              ["gg"] = { "list_top", desc = "Go to top" },
              ["i"] = { "focus_input", desc = "Focus search input" },
              ["j"] = { "list_down", desc = "Move down" },
              ["k"] = { "list_up", desc = "Move up" },
              ["q"] = { "cancel", desc = "Cancel / close" },
              ["zb"] = { "list_scroll_bottom", desc = "Scroll to bottom" },
              ["zt"] = { "list_scroll_top", desc = "Scroll to top" },
              ["zz"] = { "list_scroll_center", desc = "Scroll to center" },
            }
        },
        preview = {
          wo = {
            wrap = true,
            linebreak = true,
            list = false
          }
        }
      }
    },

    quickfile = { enabled = true },

    scope = { enabled = true },

    scratch = { enabled = true },

    scroll = { enabled = true },

    statuscolumn = { enabled = true },

    terminal = {
      enabled = true,
      win = {
        keys = {
          nav_h = { "<C-h>", term_nav("h"), desc = "Go to Left Window",  expr = true, mode = "t" },
          nav_j = { "<C-j>", term_nav("j"), desc = "Go to Lower Window", expr = true, mode = "t" },
          nav_k = { "<C-k>", term_nav("k"), desc = "Go to Upper Window", expr = true, mode = "t" },
          nav_l = { "<C-l>", term_nav("l"), desc = "Go to Right Window", expr = true, mode = "t" },
        },
      },
    },

    words = { enabled = true },

    zen = {
      enabled = true,
      toggles = {
        dim = false,
      }
    },

    styles = {
      notification = {
        border = true,
        zindex = 100,
        ft = "markdown",
        wo = {
          winblend = 5,
          wrap = true,
          conceallevel = 2,
          colorcolumn = "",
        },
        bo = { filetype = "snacks_notif" },
      },
        -- Can result large notifications.
        -- wo = { wrap = true } -- Wrap notificationsjj
      notification_history = {
        border = true,
        zindex = 100,
        -- Make window bigger 
        width = 0.8,
        height = 0.8,
        minimal = false,
        title = " Notification History ",
        title_pos = "center",
        ft = "markdown",
        bo = { filetype = "snacks_notif_history", modifiable = false },
        wo = {
          winhighlight = "Normal:SnacksNotifierHistory",
          wrap = true,
        },
        keys = { q = "close" },
      },
        scratch = {
          -- Make window bigger.
          width = 0.6,
          height = 0.6,
          -- width = 100,
          -- height = 30,
        }
    }

  }, -- opts

  keys = {
    -- Lazyvim defaults with nicer descriptions and some additions.
    -- Top Pickers & Explorer
    { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
    { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },

    { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
    { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
    { "<leader>n", function() Snacks.picker.notifications() end, desc = "Notification History" },
    -- { "<leader>e", function() Snacks.explorer() end, desc = "File Explorer" },
    -- find
    { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
    { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
    { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
    { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
    { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
    -- git
    { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
    { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
    { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
    { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
    { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
    { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
    { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
    -- Grep
    { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
    { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
    { "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep" },
    { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
    -- search
    { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
    { '<leader>s/', function() Snacks.picker.search_history() end, desc = "Search History" },
    { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
    { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
    { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
    { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
    { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
    { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
    { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
    -- { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
      -- Added: Make <CR> to copy picked color settings to clipboard.
      { "<leader>sH", function()
        Snacks.picker.highlights({
          -- Bind <CR> to the confirm action
          actions = { ["<CR>"] = "confirm" },

          confirm = function(picker, item)
            local sel = item or picker:current()
            if not sel then
              vim.notify("no item", vim.log.levels.WARN)
              return
            end

            local value = sel.text or sel.label or sel.value
            vim.notify("picked: " .. vim.inspect(value))

            if value then
              vim.fn.setreg('*', value)
            end

            picker:close()
          end,
        })
      end, desc = "Highlights" },
    { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
    { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
    { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
    { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
    { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
    { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
    { "<leader>sp", function() Snacks.picker.lazy() end, desc = "Search for Plugin Spec" },
    { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
    { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume" },
    { "<leader>su", function() Snacks.picker.undo() end, desc = "Undo History" },
    { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
    -- LSP
    { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
    { "grd", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
    { "grr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
    { "gri", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
    { "grt", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
    -- Defaults
    -- { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
    -- { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
    -- { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
    -- { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
    -- { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
    { "gai", function() Snacks.picker.lsp_incoming_calls() end, desc = "C[a]lls Incoming" },
    { "gao", function() Snacks.picker.lsp_outgoing_calls() end, desc = "C[a]lls Outgoing" },
    { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
    { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
    -- Other
    { "<leader>uz", function() Snacks.zen() end, desc = "Toggle Zen Mode" },
    { "<leader>uZ", function() Snacks.zen.zoom() end, desc = "Toggle Zoom" },
    { "<leader>.",  function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
    { "<leader>S",  function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
    { "<leader>n",  function() Snacks.notifier.show_history() end, desc = "Notification History" },
    { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
    { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File" },
    { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse", mode = { "n", "v" } },
    -- { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
    { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },

    -- Terminal

    -- Added: Quake style dropdown menu.
    { "`", function()
      Snacks.terminal.toggle(nil, {
        win = { position = "float", style = "terminal", border = "rounded",
          row = 0, width = 0.7, height = 0.8,
        },
      })
    end, desc = "Toggle floating terminal", mode = { "n", "t" } },
    -- These have cliches with Neovide.
    -- { "<Leader>tt", function() Snacks.terminal.toggle() end, desc = "Toggle terminal" },
    { "<Leader>ts", function() Snacks.terminal() end, desc = "Open in horizontal split"},
    { "<leader>tf", function() local shell = vim.o.shell require("snacks.terminal").open(shell, {}) end,
      desc = "Open in floating window" },

    -- { "<Leader>tv", function() Snacks.terminal.open(vim.o.shell, { win = { position = "right" } }) end,
    --   desc = "Open terminal (vertical)", },

    -- map("n", "<leader>fT", function() Snacks.terminal() end, { desc = "Terminal (cwd)" })
    -- map("n", "<leader>ft", function() Snacks.terminal(nil, { cwd = LazyVim.root() }) end, { desc = "Terminal (Root Dir)" })
    -- map({"n","t"}, "<c-/>",function() Snacks.terminal(nil, { cwd = LazyVim.root() }) end, { desc = "Terminal (Root Dir)" })
    -- map({"n","t"}, "<c-_>",function() Snacks.terminal(nil, { cwd = LazyVim.root() }) end, { desc = "which_key_ignore" })

    { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
    { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
    {
      "<leader>N",
      desc = "Neovim News",
      function()
        Snacks.win({
          file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
          width = 0.6,
          height = 0.6,
          window = {
            spell = false,
            wrap = false,
            signcolumn = "yes",
            statuscolumn = " ",
            conceallevel = 3,
          },
        })
      end,
    }
  }, -- keys

  init = function()

    -- From LazyVim but make toggle terminal use custom terminal colors.
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        -- Setup some globals for debugging (lazy-loaded)
        _G.dd = function(...)
          Snacks.debug.inspect(...)
        end
        _G.bt = function()
          Snacks.debug.backtrace()
        end

        -- Override print to use snacks for `:=` command
        if vim.fn.has("nvim-0.11") == 1 then
          vim._print = function(_, ...)
            dd(...)
          end
        else
          vim.print = _G.dd
        end

          vim.api.nvim_set_hl(0, "TermBackgroundFallback", { bg = "#121212" })
          vim.api.nvim_set_hl(0, "NoBackground", { bg = "none" })
        -- Make toggle terminal use custom terminal color. For termnals started
        -- without Snacks similar setting is in autocmds.lua.
        if Snacks and Snacks.terminal then
          local toggle_original = Snacks.terminal.toggle
          Snacks.terminal.toggle = function(...)
            toggle_original(...)
            local buf = vim.api.nvim_get_current_buf()
            if vim.bo[buf].buftype == "terminal" then
                local bg_group = vim.g.TermBackground and "TermBackground" or "TermBackgroundFallback"
                vim.opt_local.winhighlight = table.concat({
                  "Normal:" .. bg_group,
                  "CursorLine:NoBackground",
                }, ",")
            end
          end
        end

        -- Create some toggle mappings. 
        Snacks.toggle.diagnostics():map("<leader>ud")
        Snacks.toggle.dim():map("<leader>uD")
        Snacks.toggle.indent():map("<leader>ug")
        Snacks.toggle.inlay_hints():map("<leader>uh")
        Snacks.toggle.line_number():map("<leader>ul")
        Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
        Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>uc")
        Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
        Snacks.toggle.option("showtabline", { off = 0, on = vim.o.showtabline > 0 and vim.o.showtabline or 2, name = "Tabline" }):map("<leader>uA")
        Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
        Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
        Snacks.toggle.profiler():map("<leader>ðpp")
        Snacks.toggle.profiler_highlights():map("<leader>ðph")
        Snacks.toggle.scroll():map("<leader>uS")
        Snacks.toggle.treesitter():map("<leader>uT")
      end,
    })
  end,
}
