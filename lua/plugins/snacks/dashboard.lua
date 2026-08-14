return {
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
}
