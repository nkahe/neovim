
-- Mofiqul/vscode.nvim: Neovim/Vim color scheme inspired by Dark+ and Light+
-- theme in Visual Studio Code - https://github.com/Mofiqul/vscode.nvim

return {
  "Mofiqul/vscode.nvim",
  enabled = false,
  lazy = false, -- make sure we load this during startup if it is your main colorscheme
  priority = 1000, -- make sure to load this before all the other start plugins
  opts = {
      color_overrides = {
        -- Make backgrounds slightly darker.
        vscBack = '#1f1f1f',            -- Normal & signcolumn bg
        vscCursorDarkDark = '#222222',  -- Cursorline, vertical ColorColumn
        -- vscPopupBack = '#1f1f1f',    -- Floating windowws, terminals etc.
      },

    group_overrides = {

      -- RenderMarkdown
      RenderMarkdownH1Bg = { bg = '#22263a' },
      RenderMarkdownH2Bg = { bg = '#2c272b' },
      RenderMarkdownH3Bg = { bg = '#242b2b' },
      RenderMarkdownH4Bg = { bg = '#172830' },

      -- Snacks

      -- By default Snacks Explorer tree and directory names are too dark.
      -- Make them same as other background.
      SnacksPickerTree = { fg = '#404040', bg = 'NONE', },
      SnacksPickerDirectory = { bg ='NONE' },
      SnacksPickerCol = { bg ='#252525' },

      -- Make input box less striking.
      SnacksPickerInputBorder = { fg = "#595959", bg = "NONE" },
      SnacksPickerInputTitle = { fg = "#919191", bg = "NONE" },
      SnacksPickerGitStatusUntracked = { fg = "#8b8b8b", bg = "NONE" },
      SnacksPickerPathHidden = { fg = "#8b8b8b", bg = "NONE" },

      SnacksNotifierMinimal = { bg = "#1b1b1b" },

      -- Noice
      NoiceCmdlinePopup = { bg = "#262626" },
      NoiceCmdlinePopupBorder = { fg = "#7f7f7f" },
      NoiceCmdlinePopupBorderSearch = { fg = "#b5b5b5" },
      NoiceCmdlinePrompt = { fg = "#ffffff" },
      NoiceCursor = { fg = "#ffffff" },

      -- New highlight groups used in autocmd to change terminal colors.
      TermBackground = { bg = "#121212" },
      TermCursorLine = { bg = "none" }
    }

  },
  config = function(_, opts)
    -- Documentation suggest calling it. Usings only opts gave difficulties
    -- on appling theme.
    require('vscode').setup(opts)
    -- In LazyVim this can be added to it's spec opts in lazy.lua.
    vim.cmd.colorscheme "vscode"
  end
    -- })
    -- opts = {
      -- NOTE: mini.hipatterns doesn't hilight these but still works.

}

    -- opts = function()
      -- local c = require("").get_colors()
      -- require("vscode").setup({
      --   transparent = true,
      --   italic_comments = true,
      --   underline_links = true,
      --   disable_nvimtree_bg = true,
      --   group_overrides = {
      --   },
      -- })

