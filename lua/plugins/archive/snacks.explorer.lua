-- Attemps to patch  descriptions.

    explorer = {
      enabled = true,
      config = function(_, opts)
          require("snacks").setup(opts)

          -- 🩵 monkeypatch explorer help descriptions
          vim.schedule(function()
            local exp = require("snacks.picker.source.explorer")
            if not exp then return end
            exp.help_keys = {
            ["l"] = "Open / Expand directory",
            ["h"] = "Close directory",
            ["a"] = "Add file or folder",
            ["d"] = "Delete file or folder",
            ["r"] = "Rename",
            ["y"] = "Yank path",
            ["q"] = "Quit",
            }
          end)
        end,
            keys["l"] = { "confirm", desc = "Open file / expand directory" }
            keys["h"] = { "explorer_close", desc = "Close directory" }
            keys["a"] = { "explorer_add", desc = "Add new file or folder" }
            keys["d"] = { "explorer_del", desc = "Delete file or folder" }
            keys["r"] = { "explorer_rename", desc = "Rename file or folder" }
            keys["c"] = { "explorer_copy", desc = "Copy file or folder" }
            keys["m"] = { "explorer_move", desc = "Move file or folder" }
            keys["o"] = { "explorer_open", desc = "Open with system app" }
            keys["P"] = { "toggle_preview", desc = "Toggle file preview" }
            keys["p"] = { "explorer_paste", desc = "Paste yanked file(s)" }
            keys["u"] = { "explorer_update", desc = "Refresh explorer" }
            keys["I"] = { "toggle_ignored", desc = "Toggle ignored files" }
            keys["H"] = { "toggle_hidden", desc = "Toggle hidden files" }
            keys["Z"] = { "explorer_close_all", desc = "Collapse all directories" }
            keys["]g"] = { "explorer_git_next", desc = "Next Git change" }
            keys["[g"] = { "explorer_git_prev", desc = "Previous Git change" }
            keys["]d"] = { "explorer_diagnostic_next", desc = "Next diagnostic" }
            keys["[d"] = { "explorer_diagnostic_prev", desc = "Previous diagnostic" }
          end)
        end,
 -- local M = require("snacks.picker.source.explorer").setup(opts)
 --      -- small post-setup hook to register descs
 --      vim.schedule(function()
 --        local map = require("snacks.keymap").set
 --        local descs = {
 --          l = "Open file / expand directory",
 --          h = "Close directory",
 --          a = "Add new file or folder",
 --          d = "Delete file or folder",
 --          r = "Rename file or folder",
 --          c = "Copy file or folder",
 --          m = "Move file or folder",
 --          o = "Open with system app",
 --          P = "Toggle file preview",
 --          p = "Paste yanked file(s)",
 --          u = "Refresh explorer",
 --          I = "Toggle ignored files",
 --          H = "Toggle hidden files",
 --          Z = "Collapse all directories",
 --          ["]g"] = "Next Git change",
 --          ["[g"] = "Previous Git change",
 --          ["]d"] = "Next diagnostic",
 --          ["[d"] = "Previous diagnostic",
 --        }
 --
 --        for lhs, desc in pairs(descs) do
 --          map("n", lhs, function()
 --            require("snacks.picker").action(lhs)
 --          end, { buffer = true, desc = desc })
 --        end
 --      end)
 --      return M
      -- end,
      -- win = {
        -- list = {
          -- help_keys = {
          -- ["l"] = "Open file / expand directory",
          -- ["h"] = "Close directory",
          -- ["a"] = "Add new file or folder",
          -- ["d"] = "Delete file or folder",
          -- ["r"] = "Rename file or folder",
          -- ["c"] = "Copy file or folder",
          -- ["m"] = "Move file or folder",
          -- ["o"] = "Open with system app",
          -- ["P"] = "Toggle file preview",
          -- ["p"] = "Paste yanked file(s)",
          -- ["u"] = "Refresh explorer",
          -- ["I"] = "Toggle ignored files",
          -- ["H"] = "Toggle hidden files",
          -- ["Z"] = "Collapse all directories",
          -- ["]g"] = "Next Git change",
          -- ["[g"] = "Previous Git change",
          -- ["]d"] = "Next diagnostic",
          -- ["[d"] = "Previous diagnostic",
              -- ["l"] = { "confirm", desc = "Open file / expand directory" },
              -- ["h"] = { "explorer_close", desc = "Close directory" },
              -- ["a"] = { "explorer_add", desc = "Add new file or folder" },
              -- ["d"] = { "explorer_del", desc = "Delete file or folder" },
              -- ["r"] = { "explorer_rename", desc = "Rename file or folder" },
              -- ["c"] = { "explorer_copy", desc = "Copy file or folder" },
              -- ["m"] = { "explorer_move", desc = "Move file or folder" },
              -- ["o"] = { "explorer_open", desc = "Open with system app" },
              -- ["P"] = { "toggle_preview", desc = "Toggle file preview" },
              -- ["y"] = { "explorer_yank", mode = { "n", "x" }, desc = "Yank (copy path)" },
              -- ["p"] = { "explorer_paste", desc = "Paste yanked file(s)" },
              -- ["u"] = { "explorer_update", desc = "Refresh explorer" },
              -- ["<c-c>"] = { "tcd", desc = "Set cwd" },
              -- ["<leader>/"] = { "picker_grep", desc = "Live grep here" },
              -- ["<c-t>"] = { "terminal", desc = "Open terminal here" },
              -- ["."] = { "explorer_focus", desc = "Refocus explorer root" },
              -- ["I"] = { "toggle_ignored", desc = "Toggle ignored files" },
              -- ["H"] = { "toggle_hidden", desc = "Toggle hidden files" },
              -- ["Z"] = { "explorer_close_all", desc = "Collapse all directories" },
              -- ["]g"] = { "explorer_git_next", desc = "Next Git change" },
              -- ["[g"] = { "explorer_git_prev", desc = "Previous Git change" },
              -- ["]d"] = { "explorer_diagnostic_next", desc = "Next diagnostic" },
              -- ["[d"] = { "explorer_diagnostic_prev", desc = "Previous diagnostic" },
              -- ["]w"] = { "explorer_warn_next", desc = "Next warning" },
              -- ["[w"] = { "explorer_warn_prev", desc = "Previous warning" },
              -- ["]e"] = { "explorer_error_next", desc = "Next error" },
              -- ["[e"] = { "explorer_error_prev", desc = "Previous error" },
          -- },
        -- },
      -- },
