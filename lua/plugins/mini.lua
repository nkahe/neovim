
-- Misc plugins

-- mini.nvim. https://nvim-mini.org/mini.nvim
return {
  'nvim-mini/mini.nvim', version = false,
  event = 'VeryLazy',
  config = function()
    -- Set some basic settings.
    require('mini.basics').setup({
      -- Manage options in 'plugin/10_options.lua'
      options = {
        -- Basic options ('number', 'ignorecase', and many more)
        basic = false,
        -- Extra UI features ('winblend', 'listchars', 'pumheight', ...)
        extra_ui = false,
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

    -- Extra 'mini.nvim' functionality.
    require('mini.extra').setup()

    -- Extend and create a/i textobjects.
    local ai = require('mini.ai')
    ai.setup({
      -- 'mini.ai' can be extended with custom textobjects.
      custom_textobjects = {
        -- Make `aB` / `iB` act on around/inside whole *b*uffer
        B = MiniExtra.gen_ai_spec.buffer(),
        -- For more complicated textobjects that require structural awareness,
        -- use tree-sitter. This example makes `aF`/`iF` mean around/inside function
        -- definition (not call). See `:h MiniAi.gen_spec.treesitter()` for details.
        F = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }),
      },

      -- 'mini.ai' by default mostly mimics built-in search behavior: first try
      -- to find textobject covering cursor, then try to find to the right.
      -- Although this works in most cases, some are confusing. It is more robust to
      -- always try to search only covering textobject and explicitly ask to search
      -- for next (`an`/`in`) or last (`an`/`il`).
      -- Try this. If you don't like it - delete next line and this comment.
      search_method = 'cover',
    })

    -- Highlight some patterns.
    local hipatterns = require('mini.hipatterns')
    local hi_words = MiniExtra.gen_highlighter.words
    hipatterns.setup({
      highlighters = {
        -- Highlight a fixed set of common words. Will be highlighted in any place,
        -- not like "only in comments".
        fixme = hi_words({ 'FIXME', 'Fixme', 'fixme' }, 'MiniHipatternsFixme'),
        hack = hi_words({ 'HACK', 'Hack', 'hack' }, 'MiniHipatternsHack'),
        todo = hi_words({ 'TODO', 'Todo', 'todo' }, 'MiniHipatternsTodo'),
        note = hi_words({ 'NOTE', 'Note', 'note' }, 'MiniHipatternsNote'),

        -- Highlight hex color string (#aabbcc) with that color as a background
        hex_color = hipatterns.gen_highlighter.hex_color(),
      },
    })

    -- Move text blocks easily.
    require('mini.move').setup()

    -- Close all windows showing Snacks picker list
    local function close_snacks_picker()
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].filetype == "snacks_picker_list" then
          pcall(vim.api.nvim_win_close, win, true)
        end
      end
    end

    -- If plugins like Snacks.explorer are open when session is saved, they
    -- left empty windows. Close them after restoring session.
    local function close_empty_windows()
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.api.nvim_buf_get_name(buf) == "" and vim.bo[buf].filetype == "" then
          if #vim.api.nvim_list_wins() > 1 then pcall(vim.api.nvim_win_close, win, true) end
        end
      end
    end


    require('mini.sessions').setup({
      -- Whether to write currently read session before leaving it
      autowrite = true,
      hooks = {
        -- Doesn't get executed if using automatic writing and quitting.
        -- pre = {
        --   write = function()
        --     close_snacks_picker()
        --   end,
        -- },
        post = {
          read = function()
            close_empty_windows()
          end,
        },

      },
    })
  end,
}
