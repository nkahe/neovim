
-- Misc plugins

-- mini.nvim. https://nvim-mini.org/mini.nvim
return {
  'nvim-mini/mini.nvim', version = false,
  config = function()
    require('mini.basics').setup({
      -- Manage options in 'plugin/10_options.lua'
      options = {
        -- Basic options ('number', 'ignorecase', and many more)
        basic = false,
        -- Extra UI features ('winblend', 'listchars', 'pumheight', ...)
        extra_ui = true,
       -- Presets for window borders ('single', 'double', ...)
        -- Default 'auto' infers from 'winborder' option
        win_borders = 'auto',
      },
      mappings = {
        basic = true,
        -- Prefix for mappings that toggle common options ('wrap', 'spell', ...).
        -- Supply empty string to not create these mappings.
        -- Defined in keymaps file.
        option_toggle_prefix = '',
        -- Create `<C-hjkl>` mappings for window navigation
        windows = true,
        -- Create `<M-hjkl>` mappings for navigation in Insert and Command modes
        move_with_alt = true,
      },
    })
    require('mini.move').setup()
    require('mini.sessions').setup()
  end,
}
