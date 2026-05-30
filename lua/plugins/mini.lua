-- https://nvim-mini.org/mini.nvim
return {
  {
  'nvim-mini/mini.nvim', version = false,
  event = 'VeryLazy',
  config = function()

    local set = vim.keymap.set

    require('mini.align').setup()

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
        windows = false,
        -- Create `<M-hjkl>` mappings for navigation in Insert and Command modes
        move_with_alt = true,
      },

    })
    vim.keymap.del({ 'n', 'x' }, "gp")
    -- vim.keymap.del("n", "gP")
    vim.keymap.del({ 'n', 'x' }, "gy")

    -- Mini.ai ----------------------------------------------------------------

    -- Entire buffer object.
    local function buffer(ai_type)
      local start_line, end_line = 1, vim.fn.line("$")
      if ai_type == "i" then
        -- Skip first and last blank lines for `i` textobject
        local first_nonblank, last_nonblank = vim.fn.nextnonblank(start_line), vim.fn.prevnonblank(end_line)
        -- Do nothing for buffer with all blanks
        if first_nonblank == 0 or last_nonblank == 0 then
          return { from = { line = start_line, col = 1 } }
        end
        start_line, end_line = first_nonblank, last_nonblank
      end

      local to_col = math.max(vim.fn.getline(end_line):len(), 1)
      return { from = { line = start_line, col = 1 }, to = { line = end_line, col = to_col } }
    end

    -- Extends the a & i text objects, this adds the ability to select
    -- arguments, function calls, text within quotes and brackets, and to
    -- repeat those selections to select an outer text object.
    -- This is based on LazyVim config.
    local ai = require('mini.ai')
    ai.setup({
      n_lines = 500,
      mappings = {
        around_next = "aN",
        inside_next = "iN",
        around_last = "",
        inside_last = "",
      },
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
        g = buffer,
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
        -- Nvim 0.12 has these by default.
        -- an = "around next",
        -- in_ = "inside next",
        -- al = "around last",
        -- il = "inside last",
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

    require('mini.misc').setup()

    -- Move text blocks easily.
   require('mini.move').setup()

    -- Close all windows showing Snacks picker list. Not used atm.
    local function close_snacks_picker()
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].filetype == "snacks_picker_list" then
          pcall(vim.api.nvim_win_close, win, true)
        end
      end
    end

    require('mini.operators').setup({
        -- Wach entry configures one operator.
        -- `prefix` defines keys mapped during `setup()`: in Normal mode
        -- to operate on textobject and line, in Visual - on selection.
        evaluate = { prefix = 'ö=' }, -- Evaluate text and replace with output
        exchange = { prefix = 'öx' }, -- Exchange text regions
        multiply = { prefix = 'öm' }, -- Multiply (duplicate) text
        replace  = { prefix = 'ör' }, -- Replace text with register
        sort     = { prefix = 'ös' }  -- Sort text
    })

    -- Split / join argumnets.
    require('mini.splitjoin').setup({
      mappings = { toggle = 'öa', split = '', join = '' }
    })

    require('mini.surround').setup({
      mappings = {
        add            = "ys", -- Add surrounding in  Normal and Visual modes
        delete         = "ds", -- Delete surrounding.
        find           = "gs", -- Find surrounding (to the right)
        find_left      = "gS", -- Find surrounding (to the left)
        highlight      = "gsh",-- Highlight surrounding
        replace        = "cs", -- Replace   surrounding
        update_n_lines = "",   -- Update `n_lines`
      },
    })

    if vim.g.vscode then
      return
    end

    -- Non VS Code compatible plugins ------------

      -- Mini.cmdline ---------------------------------------------------------

      require('mini.cmdline').setup({
      -- Autocompletion: show `:h 'wildmenu'` as you type
      autocomplete = { enable = false },  -- Blink is used instead.

      -- Autocorrection: adjust non-existing words (commands, options, etc.)
      autocorrect = {
        enable = false,
        func = nil,  -- Custom autocorrection rule
      },

      -- Autopeek: show command's target range in a floating window
      autopeek = {
        enable = true,
        n_context = 1,    -- Number of lines to show above and below range lines
        predicate = nil,  -- Custom rule of when to show peek window
        window = {        -- Window options
          config = {},    -- Floating window config
          statuscolumn = nil, -- Function to render statuscolumn
        },
      },
    })

    -- require('mini.diff').setup({})

    -- Extra 'mini.nvim' functionality.
    require('mini.extra').setup()

    -- Mini.hipatterns --------------------------------------------------------

     -- Highlight some patterns.
    local hipatterns = require('mini.hipatterns')
    local hi_words = MiniExtra.gen_highlighter.words
    hipatterns.setup({
      highlighters = {
        -- Highlight a fixed set of common words. Will be highlighted in any place.
        fixme = hi_words({ 'FIXME' }, 'MiniHipatternsFixme'),
        hack  = hi_words({ 'HACK' }, 'MiniHipatternsHack'),
        todo  = hi_words({ 'TODO' }, 'MiniHipatternsTodo'),
        note  = hi_words({ 'NOTE', 'HUOM' }, 'MiniHipatternsNote'),
        hex_color = hipatterns.gen_highlighter.hex_color(),
      },
    })

    -- Mini.map ---------------------------------------------------------------

    local map = require('mini.map')
    map.setup({
      -- Use Braille dots to encode text
      symbols = { encode = map.gen_encode_symbols.dot('4x2') },
      -- Show built-in search matches, 'mini.diff' hunks, and diagnostic entries
      integrations = {
        map.gen_integration.builtin_search(),
        map.gen_integration.diff(),
        map.gen_integration.diagnostic(),
      },
    })

    -- Map built-in navigation characters to force map refresh
    for _, key in ipairs({ 'n', 'N', '*', '#' }) do
      local rhs = key
        -- Also open enough folds when jumping to the next match
        .. 'zv'
        .. '<Cmd>lua MiniMap.refresh({}, { lines = false, scrollbar = false })<CR>'
      vim.keymap.set('n', key, rhs)
    end

    set('n', '<Leader>Mc', MiniMap.close, { desc = "Close" })
    set('n', '<Leader>Mf', MiniMap.toggle_focus, { desc = "Toggle focus" })
    set('n', '<Leader>Mo', MiniMap.open,  { desc = "Open" })
    set('n', '<Leader>Mr', MiniMap.refresh, { desc = "Refresh" })
    set('n', '<Leader>Ms', MiniMap.toggle_side, { desc = "Toggle side" })
    set('n', '<Leader>Mt', MiniMap.toggle, { desc = "Toggle" })
    set('n', '<Leader>uM', MiniMap.toggle, { desc = "Toggle minimap" })

    -- Keymap using mini.misc -------------------------------------------------

    -- Find project root and lcd
    set("n", "<Leader>fR", function()
        local buf = vim.api.nvim_get_current_buf()
        local root = require("mini.misc").find_root(buf)
        if root then
          vim.cmd("lcd " .. root)
          print("Changed CWD to: " .. root)
        else
          vim.cmd("lcd ..")
          print("Root not found, changed to: \n" .. vim.fn.getcwd())
        end
      end,
      { desc = "Find root and lcd" }
    )

    -- Mini.sessions ----------------------------------------------------------

    -- If plugins like filetrees are open when session is saved, they left empty
    -- residue window + buffer. This closes window and deletes the buffer.
    -- For neotree buf and ft is empty and name_
    -- "neo-tree filesystem [id]
    local function close_empty_windows()

      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        local ft = vim.bo[buf].filetype
        local name = vim.api.nvim_buf_get_name(buf)

        local is_neotree = name:match("neo%-tree ")
        local is_empty = (name == "" and ft == "")

        if (is_empty or is_neotree) and #vim.api.nvim_list_wins() > 1 then
          pcall(vim.api.nvim_win_close, win, true)
          vim.api.nvim_buf_delete(buf, { force = true })
        end
      end

    end

    require('mini.sessions').setup({
      -- Whether to write currently read session before leaving it
      autoread = false,
      autowrite = true,
      hooks = {
        -- -- Before successful action
        -- pre = { read = nil, write = nil, delete = nil },
        -- -- After successful action
        -- post = { read = nil, write = nil, delete = nil },

        -- Doesn't get executed if using automatic writing and quitting.
        pre = {
          read = function()
            local session_name = MiniSessions.get_latest()
            if session_name then
              -- or do something with it, e.g. update title or global var
              _G.Config.windowtitle = session_name
            end
          end,
          -- write = function()
          --   close_snacks_picker()
          -- end,
        },
        post = { read = function() close_empty_windows() end },
      },
    })

    local nmap_leader = function(suffix, rhs, desc)
      vim.keymap.set('n', '<Leader>' .. suffix, rhs, { desc = desc })
    end

    local session_new = 'MiniSessions.write(vim.fn.input("Session name: "))'
    nmap_leader('qd', '<Cmd>lua MiniSessions.select("delete")<CR>', 'Delete')
    nmap_leader('qn', '<Cmd>lua ' .. session_new .. '<CR>',         'New')
    nmap_leader('qs', '<Cmd>lua MiniSessions.select("read")<CR>',   'Select')
    nmap_leader('qw', '<Cmd>lua MiniSessions.write()<CR>', 'Write current')
    nmap_leader('qr', '<Cmd>lua MiniSessions.restart()<CR>', 'Restart')
    nmap_leader('qg', '<Cmd>lua MiniSessions.get_latest()<CR>', 'Get name of latest')


  end, -- config
},

-- whitespace in snacks.dashboard gets highlighted if not loaded with event.
{
  'echasnovski/mini.trailspace', event = 'BufReadPost', opts = {}
}
}
