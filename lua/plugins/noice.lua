return {
  "folke/noice.nvim",
  enabled = true,
  event = "VeryLazy",
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    "MunifTanjim/nui.nvim",
    -- OPTIONAL:
    --   `nvim-notify` is only needed, if you want to use the notification view.
    --   If not available, we use `mini` as the fallback
    -- "rcarriga/nvim-notify",
  },
  opts = {
    notify = {
      enabled = true,
      timeout = 10000,
    },

    lsp ={
      signature = {
        enabled = true,
        auto_open = {
          -- Ctrl-k for hiding signature window doesn't work for me but moved
          -- the cursor to it.
          enabled = false,
          -- trigger = true, -- Automatically show signature help when typing a trigger character from the LSP
          -- luasnip = true, -- Will open signature help when jumping to Luasnip insert nodes
          -- throttle = 50, -- Debounce lsp signature help request by 50ms
        },
      },
    },
    -- mini = {
    --   timeout = 10000
    -- },
    routes = {
      -- hide "Search hit BOTTOM/TOP" warnings
      {
        filter = {
          -- "Search hit bottom" type of warnings.
          event = "msg_show",
          kind = "wmsg",
        },
        opts = { skip = true },
      },
    },

    cmdline = {
      format = {
        -- These disable hiding of matching command.
        conceal = false,
        -- search_down = false,
        -- search_up = false,
        -- filter = false,
        lua = false,
        help = false
      },
      view = "cmdline_popup", -- Use the popup view
    },

    views = {
      cmdline_popup = {
        position = {
          row = "96%", -- Position near the bottom (90% of screen height)
          col = "50%", -- Centered horizontally
        },
        size = {
          width = 95,
          height = "auto", -- Adjust height automatically
        },
        border = {
          style = "rounded", -- Optional: "none", "single", "double", "rounded"
          padding = { 0, 1 }, -- up/bottom, left/right
        },
      },
      notify = {
        position = {
          row = -2,  -- move 2 lines up from the bottom
          col = -2,  -- move 2 columns left from the right
        },
      },
    },

    presets = {
      long_message_to_split = true, -- long messages will be sent to a split
      lsp_doc_border = false, -- add a border to hover docs and signature help
    },

  }, --opts
}
