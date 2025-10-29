
-- Misc plugins

-- mini.nvim. https://nvim-mini.org/mini.nvim
return {
  'nvim-mini/mini.nvim', version = false,
  config = function()
    require('mini.basics').setup({
      -- Manage options in 'plugin/10_options.lua'
      options = { basic = false },
      -- Extra UI features ('winblend', 'listchars', 'pumheight', ...)
      extra_ui = true,
      mappings = {
        -- Create `<C-hjkl>` mappings for window navigation
        windows = true,
        -- Create `<M-hjkl>` mappings for navigation in Insert and Command modes
        move_with_alt = true,
      },
    })
  end,
}
