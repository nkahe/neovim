
local options = {

  -- NOTE: After changing theme, run:
  -- lua require("base46").compile()
  -- lua require("base46").load_all_highlights()

  base46 = {
    theme = "oceanic-next", -- default theme
    hl_add = {
      NoiceCmdlinePopupBorder       = { fg = "teal" },
      NoiceCmdlinePopupBorderSearch = { fg = "teal" },
      SnacksPickerListCursorline    = { bg = "one_bg" },
      SnacksPickerCursorline        = { bg = "one_bg" },
      SnacksPickerDir = { fg = "nord_blue" },
      SnacksIndent    = { fg = "one_bg2" },
      -- Custom group used in autocmd and in snacks.terminal config.
      TermBackground  = { bg = "#0b1216" },
    },
    hl_override = {
      Comment   = { fg = "light_grey" },
      -- Make text in search hilights easier to read.
      IncSearch = { fg = "#000000" },
      Search    = { fg = "#000000" },
      WhichKeyDesc = { fg = "blue" },
      -- Treesitter
      -- Use lighter grey.
      ["@comment"] = { fg = "light_grey", },
      -- Use similar color as original Sublime Text Oceanic-Next instead
      -- of Base46 definition which is linked to red.
      ["@punctuation.delimiter"] = { fg = 'base08' },
      ["@punctuation.bracket"]   = { fg = 'base08' },
      ["@constructor"] = { fg = 'base08' },
    },
    integrations = { "blink", "flash", "git", "git-conflict", "lsp", "mason",
      "neogit", "semantic_tokens", "syntax", "treesitter", "trouble", "whichkey"
    },
-- NOTE: changed_themes allows only custom hex colors
    changed_themes = {
      ["oceanic-next"] = {
        base_30 = {
          black  = "#192830", -- Make little darker.
          black2 = "#203038",
          -- Make lighter, used in comments.
          light_grey = "#738490" 
        },
        base_16 = {
          base00 = "#192830",
        },
        -- These weren't enough.
        NoiceCmdlinePopupBorder       = { fg = "#50a4a4" },
        NoiceCmdlinePopupBorderSearch = { fg = "#50a4a4" },
        SnacksPickerListCursorLine    = { bg = "#2e3e47" },
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

-- For reference

-- M.base_30 = {
--   white = "#D8DEE9", -- confirmed
--   darker_black = "#122027",
--   black = "#1B2B34", --  nvim bg
--   black2 = "#21313a",
--   one_bg = "#25353e",
--   one_bg2 = "#2e3e47",
--   one_bg3 = "#36464f",
--   grey = "#43535c",
--   grey_fg = "#4d5d66",
--   grey_fg2 = "#576770",
--   light_grey = "#5f6f78",
--   red = "#EC5F67",
--   baby_pink = "#ff7d85",
--   pink = "#ffafb7",
--   line = "#2a3a43", -- for lines like vertsplit
--   green = "#99C794",
--   vibrant_green = "#b9e75b",
--   nord_blue = "#598cbf",
--   blue = "#6699CC",
--   yellow = "#FAC863",
--   sun = "#ffd06b",
--   purple = "#C594C5",
--   dark_purple = "#ac7bac",
--   teal = "#50a4a4",
--   orange = "#F99157",
--   cyan = "#62B3B2",
--   statusline_bg = "#1f2f38",
--   lightbg = "#2c3c45",
--   pmenu_bg = "#15bf84",
--   folder_bg = "#598cbf",
-- }

-- Base16 colors taken from:
-- M.base_16 = {
--   base00 = "#1B2B34",
--   base01 = "#343D46",
--   base02 = "#4F5B66",
--   base03 = "#65737e",
--   base04 = "#A7ADBa",
--   base05 = "#C0C5Ce",
--   base06 = "#CDD3De",
--   base07 = "#D8DEE9",
--   base08 = "#6cbdbc",
--   base09 = "#FAC863",
--   base0A = "#F99157",
--   base0B = "#99C794",
--   base0C = "#5aaeae",
--   base0D = "#6699CC",
--   base0E = "#C594C5",
--   base0F = "#EC5F67",
-- }

