return  {
  "OXY2DEV/markview.nvim",
  enabled = true,
  startWithIgnoreCase = false,
  lazy = false,  -- Do not lazy load this plugin as it is already lazy-loaded.
  -- Completion for `blink.cmp`
  -- dependencies = { "saghen/blink.cmp" },
  init = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "markdown","norg", "rmd", "org", "vimwiki", "Avante" },
      callback = function(event)
        -- NOTE: "toggle" with lowercase t.
        vim.keymap.set("n", "\\m", ("<cmd>Markview toggle<CR>"), {
          buffer = event.buf,
          desc = "Toggle Markview for buffer"
        })
        vim.keymap.set("n", { "<Leader>um" }, "<cmd>Markview Toggle<CR>",
          { desc = "Toggle markdown rendering" })
      end
    })
  end,
  opts = {
    -- Add Avante.
    preview = {
      filetypes = { "markdown", "norg", "rmd", "org", "vimwiki", "Avante" },
      ignorebuftypes = {},
      modes = { "n", "i", "c" },       -- where preview is active
      hybrid_modes = { "n", "i" },     -- where cursor-area is unrendered
      linewise_hybrid_mode = true,
      edit_range = { 0, 0 },           -- only current line
    },
    markdown = {
      code_blocks = { sign = false, style = "block" },
      headings = {
        heading_1 = {
          style = "label",
          icon = "I ",
          icon_hl = "MarkviewHeadingIcon1",
          -- border = "=",
          -- border_hl = "MarkviewHeading1",
          padding_left = " ",
          padding_right = "       ",
          sign = ""
        },
        heading_2 = {
          style = "label",
          icon = "II ",
          icon_hl = "MarkviewHeadingIcon2",
          padding_left = " ",
          padding_right = "      ",
          sign = ""
        },
        heading_3 = {
          style = "label",
          icon = "III ",
          icon_hl = "MarkviewHeadingIcon3",
          padding_left = " ",
          padding_right = "     ",
          sign = ""
        },
        heading_4 = {
          style = "label",
          icon = "IV ",
          icon_hl = "MarkviewHeadingIcon4",
          padding_left = " ",
          padding_right = "      ",
          sign = ""
        },
        heading_5 = {
          style = "label",
          icon = "V ",
          icon_hl = "MarkviewHeadingIcon5",
          padding_left = " ",
          padding_right = "       ",
          sign = ""
        },
        heading_6 = {
          style = "label",
          icon = "VI ",
          icon_hl = "MarkviewHeadingIcon6",
          padding_left = " ",
          padding_right = "      ",
          sign = ""
        },
        shift_width = 0,
      }, -- headings

      -- Prevent lines starting with <number>. or ) being changed to 1. or 1).
      list_items = {
        marker_dot = {
          enable = false, -- disables n. rendering
        },
        marker_parenthesis = {
          enable = false, -- disables n) rendering
        },
      },
    }, -- markdown
  } -- opts
}
