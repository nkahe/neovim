
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

    -- Extends the a & i text objects, this adds the ability to select
    -- arguments, function calls, text within quotes and brackets, and to
    -- repeat those selections to select an outer text object.
    -- This is based on LazyVim config.
    local ai = require('mini.ai')
    ai.setup({
      n_lines = 500,
      custom_textobjects = {
        o = ai.gen_spec.treesitter({ -- code block
          a = { "@block.outer", "@conditional.outer", "@loop.outer" },
          i = { "@block.inner", "@conditional.inner", "@loop.inner" },
        }),
        f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function
        c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }), -- class
        t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tags
        d = { "%f[%d]%d+" }, -- digits
        e = { -- Word with case
          { "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
          "^().*()$",
        },
        u = ai.gen_spec.function_call(), -- u for "Usage"
        U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
      },
      -- From MiniMax -config:
      -- 'mini.ai' by default mostly mimics built-in search behavior: first try
      -- to find textobject covering cursor, then try to find to the right.
      -- Although this works in most cases, some are confusing. It is more robust to
      -- always try to search only covering textobject and explicitly ask to search
      -- for next (`an`/`in`) or last (`an`/`il`).
      search_method = 'cover',
    })

    -- defer WhichKey registration until it's loaded
    local function register_ai_with_whichkey()
      local ok, wk = pcall(require, "which-key")
      if not ok then
        return
      end

      local objects = {
        { " ", desc = "whitespace" },
        { '"', desc = '" string' },
        { "'", desc = "' string" },
        { "(", desc = "() block" },
        { ")", desc = "() block with ws" },
        { "<", desc = "<> block" },
        { ">", desc = "<> block with ws" },
        { "?", desc = "user prompt" },
        { "U", desc = "use/call without dot" },
        { "[", desc = "[] block" },
        { "]", desc = "[] block with ws" },
        { "_", desc = "underscore" },
        { "`", desc = "` string" },
        { "a", desc = "argument" },
        { "b", desc = ")]} block" },
        { "c", desc = "class" },
        { "d", desc = "digit(s)" },
        { "e", desc = "CamelCase / snake_case" },
        { "f", desc = "function" },
        { "g", desc = "entire file" },
        { "i", desc = "indent" },
        { "o", desc = "block, conditional, loop" },
        { "q", desc = "quote `\"'" },
        { "t", desc = "tag" },
        { "u", desc = "use/call" },
        { "{", desc = "{} block" },
        { "}", desc = "{} with ws" },
      }

      local mappings = {
        a = "around",
        i = "inside",
        an = "around next",
        in_ = "inside next",
        al = "around last",
        il = "inside last",
      }

      local specs = { mode = { "o", "x" } }
      for prefix, group in pairs(mappings) do
        specs[#specs + 1] = { prefix, group = group }
        for _, obj in ipairs(objects) do
          local desc = obj.desc
          if prefix:sub(1, 1) == "i" then
            desc = desc:gsub(" with ws", "")
          end
          specs[#specs + 1] = { prefix .. obj[1], desc = desc }
        end
      end

      wk.add(specs, { notify = false })
    end

    -- Run once WhichKey is loaded
    if package.loaded["which-key"] then
      vim.schedule(register_ai_with_whichkey)
    else
      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyLoad",
        callback = function(event)
          if event.data == "which-key.nvim" then
            vim.schedule(register_ai_with_whichkey)
          end
        end,
      })
    end

    -- Highlight some patterns.
    local hipatterns = require('mini.hipatterns')
    local hi_words = MiniExtra.gen_highlighter.words
    hipatterns.setup({
      highlighters = {
        -- Highlight a fixed set of common words. Will be highlighted in any place,
        -- not like "only in comments".
        fixme = hi_words({ 'FIXME:', 'Fixme:', 'fixme:' }, 'MiniHipatternsFixme'),
        hack = hi_words({ 'HACK:', 'Hack:', 'hack:' }, 'MiniHipatternsHack'),
        todo = hi_words({ 'TODO:', 'Todo:', 'todo:' }, 'MiniHipatternsTodo'),
        note = hi_words({ 'NOTE:', 'Note:', 'note:' }, 'MiniHipatternsNote'),
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
