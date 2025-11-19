local options = {

  -- NOTE: After changing theme, run:
  -- lua require("base46").compile()
  -- lua require("base46").load_all_highlights()
  base46 = {
    theme = "oceanic-next", -- default theme
    hl_add = {
      -- Needed to add atleast these.
      NoiceCmdlinePopupBorder = { fg = "teal" },
      NoiceCmdlinePopupBorderSearch = { fg = "teal" },
      SnacksPickerListCursorne = { bg = "one_bg2" },
      SnacksPickerDir = { fg = "nord_blue" },
      TermBackground = { bg = "#0b1216" },
      TermCursorLine = { bg = "none" }
    },
    hl_override = {
      Comment = { fg = "teal" },
      ["@comment"] = { fg = "teal", },
      IncSearch = { fg = "black", bg = 'teal' },
      WhichKeyDesc = { fg = "blue" },
    },
    integrations = {
      -- Needed to add atleast these.
      NoiceCmdlinePopupBorder = { fg = "teal" },
      NoiceCmdlinePopupBorderSearch = { fg = "teal" },
      SnacksPickerListCursorLine = { bg = "one_bg2" },
      SnacksPickerDir = { fg = "nord_blue" },
  },
-- NOTE: changed_themes allows only custom hex colors
    changed_themes = {
      ["oceanic-next"] = {
        base_30 = {
          black = "#192830",
          black2 = "#203038",
        },
        base_16 = {
          base00 = "#192830",
        },
        -- These weren't enough.
        NoiceCmdlinePopupBorder = { fg = "#50a4a4" },
        NoiceCmdlinePopupBorderSearch = { fg = "#50a4a4" },
        SnacksPickerListCursorLine = { bg = "#2e3e47" },
        SnacksPickerDir = { fg = "#598cbf" },
      },
    },
    transparency = false,
    theme_toggle = { "oceanic-next", "oceanic_light" },
  },

  ui = {
    cmp = {
      icons_left = false, -- only for non-atom styles!
      style = "default", -- default/flat_light/flat_dark/atom/atom_colored
      abbr_maxwidth = 60,
      -- for tailwind, css lsp etc
      format_colors = { lsp = true, icon = "󱓻" },
    },

    telescope = { style = "borderless" }, -- borderless / bordered

    statusline = {
      enabled = true,
      theme = "default", -- default/vscode/vscode_colored/minimal
      -- default/round/block/arrow separators work only for default statusline theme
      -- round and block will work for minimal theme only
      separator_style = "default",
      order = nil,
      modules = nil,
    },

    -- lazyload it when there are 1+ buffers
    tabufline = {
      enabled = true,
      lazyload = true,
      order = { "treeOffset", "buffers", "tabs", "btns" },
      modules = nil,
      bufwidth = 21,
    },
  },

  lsp = { signature = true },

  cheatsheet = {
    theme = "grid", -- simple/grid
    excluded_groups = { "terminal (t)", "autopairs", "Nvim", "Opens" }, -- can add group name or with mode
  },

}

local status, chadrc = pcall(require, "chadrc")
return vim.tbl_deep_extend("force", options, status and chadrc or {})
