-- Terminal Mappings
local function term_nav(dir)
  ---@param self snacks.terminal
  return function(self)
    return self:is_floating() and "<c-" .. dir .. ">" or vim.schedule(function()
      vim.cmd.wincmd(dir)
    end)
  end
end

return {
  "folke/snacks.nvim",
  enabled = true,
  priority = 1000,
  lazy = false,
  opts = {
    bigfile = { enabled = true },

    dashboard = require("plugins.snacks.dashboard"),

    -- Defaults:
    -- <leader>e	Explorer Snacks (root dir)
    -- <leader>E	Explorer Snacks (cwd)
    explorer = { enabled = false },

    indent = { enabled = true },

    input = { enabled = true },

    -- Notification style such as wrap is defined in snacks.styles -module.
    notifier = {
      enabled = true,
      -- Values: "compact", "minimal"
      style = "compact",
        -- Timeout for notifications longer so can actually read them.
      timeout = 6000,
      margin = { top = 1, right = 1, bottom = 1 },
      padding = true, -- add 1 cell of left/right padding to the notification window
      gap = 0, -- gap between notifications
    },

    picker = require("plugins.snacks.picker"),

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

    -- Highlights LSP reference words under cursor. Under keys there is keymaps
    -- to move next/previous reference.
    words = { enabled = true },

    zen = { enabled = true, toggles = { dim = false } },

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
    { "<C-p>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
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
    { "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep" },
    { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
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
    { "<leader>si", function() Snacks.picker.icons() end,  desc = "Icons" },
    { "<leader>sj", function() Snacks.picker.jumps() end,  desc = "Jumps" },
    { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
    { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
    { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
    { "<leader>sM", function() Snacks.picker.man() end,  desc = "Man Pages" },
    { "<leader>sp", function() Snacks.picker.lazy() end, desc = "Search for Plugin Spec" },
    { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
    { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume" },
    { "<leader>su", function() Snacks.picker.undo() end, desc = "Undo History" },
    { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },

    -- LSP
    { "grd", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
    { "grr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
    { "gri", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
    { "grt", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },

    -- Snacks defaults
    -- { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
    -- { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
    -- { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
    -- { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },

    { "gai", function() Snacks.picker.lsp_incoming_calls() end, desc = "C[a]lls Incoming" },
    { "gao", function() Snacks.picker.lsp_outgoing_calls() end, desc = "C[a]lls Outgoing" },
    { "<C-S-o>", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
    { "<leader>ss", function() require("plugins.local.symbols").pick() end, desc = "Symbols" },
    { "<leader>sS", function() require("plugins.local.symbols").pick_workspace() end, desc = "Workspace Symbols" },

    -- Other
    -- { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
    { "<leader>.",  function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
    { "<leader>S",  function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
    { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
    { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File" },
    { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse", mode = { "n", "v" } },
    { "<leader>n",  function() Snacks.notifier.show_history() end, desc = "Notification History" },
    { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },

    -- Terminal

    -- NOTE: Non-snacks terminal commands are in shared-keymaps file.
    -- Added: Quake style dropdown menu.
    -- { "`", function()
    --   Snacks.terminal.toggle(nil, {
    --     win = { position = "float", style = "terminal", border = "rounded",
    --       row = 0, width = 0.7, height = 0.8,
    --     },
    --   })
    -- end, desc = "Toggle floating terminal", mode = { "n", "t" } },

    { "`", function() Snacks.terminal.toggle(nil, { win = { position = "bottom" } }) end,
       desc = "Toggle terminal", mode = { "n", "t" }, },

    -- These have cliches with Neovide.
    { "<Leader>tt", function() Snacks.terminal.toggle() end, desc = "Toggle terminal" },
    -- { "<Leader>ts", function() Snacks.terminal() end, desc = "Open in horizontal split"},
    { "<leader>tf", function() local shell = vim.o.shell require("snacks.terminal").open(shell, {}) end,
      desc = "Open in floating window" },

    -- { "<Leader>tv", function() Snacks.terminal.open(vim.o.shell, { win = { position = "right" } }) end,
    --   desc = "Open terminal (vertical)", },
    -- map("n", "<leader>fT", function() Snacks.terminal() end, { desc = "Terminal (cwd)" })
    -- map("n", "<leader>ft", function() Snacks.terminal(nil, { cwd = LazyVim.root() }) end, { desc = "Terminal (Root Dir)" })
    -- map({"n","t"}, "<c-/>",function() Snacks.terminal(nil, { cwd = LazyVim.root() }) end, { desc = "Terminal (Root Dir)" })
    -- map({"n","t"}, "<c-_>",function() Snacks.terminal(nil, { cwd = LazyVim.root() }) end, { desc = "which_key_ignore" })

    -- snacks.words
    { "]]", function() Snacks.words.jump(vim.v.count1) end,  desc = "Next Reference", mode = { "n", "t" } },
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
        -- Make toggle terminal use custom terminal color. For terminals started
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

      end,
    })
  end,
}
