
return  {
    "OXY2DEV/markview.nvim",
    enabled = true,
    startWithIgnoreCase = false,
    lazy = false,  -- Do not lazy load this plugin as it is already lazy-loaded.
    -- Completion for `blink.cmp`
    -- dependencies = { "saghen/blink.cmp" },
    keys = {
      { "<Leader>um", "<cmd>Markview Toggle<CR>", mode = "n", desc = "Toggle markdown rendering" }
    },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function(event)
          -- NOTE: "toggle" with lowercase t.
          vim.keymap.set("n", "\\m", ("<cmd>Markview toggle<CR>"), {
            buffer = event.buf,
            desc = "Toggle Markview for buffer"
          })
        end
      })
    end,

    opts = {
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
        },
      },
    }
  }
