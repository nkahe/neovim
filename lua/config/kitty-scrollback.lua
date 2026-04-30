
-- Used for scrollback buffer in Kitty terminal.
--
-- in kitty.conf needs:
-- scrollback_pager nvim -u NONE -R -M -c 'lua require("config/kitty-scrollback")(INPUT_LINE_NUMBER, CURSOR_LINE, CURSOR_COLUMN)'

-- Alternative to plugin.
return function(INPUT_LINE_NUMBER, CURSOR_LINE, CURSOR_COLUMN)
  vim.opt.encoding='utf-8'
  -- Prevent auto-centering on click
  vim.o.scrolloff      = 0
  vim.o.compatible     = false
  vim.o.number         = false
  vim.o.relativenumber = false
  vim.o.termguicolors  = true
  vim.o.showmode       = false
  vim.o.ruler          = false
  vim.o.showtabline    = 0
  vim.o.laststatus     = 0
  vim.o.cmdheight      = 0
  vim.o.showcmd        = false
  vim.o.scrollback     = 100000

  vim.o.ignorecase     = true      -- Ignore case during search
  vim.o.infercase      = true      -- Infer case in built-in completion 
  vim.o.smartcase      = true      -- Respect case if search pattern has upper case
  vim.o.smartindent    = true      -- Make indenting smart
  vim.o.spelloptions   = 'camel'   -- Treat camelCase word parts as separate words
  vim.o.iskeyword      = '@,48-57,_,192-255,-' -- Treat dash as `word` textobject part
  vim.o.swapfile       = false

  vim.api.nvim_set_hl(0, "Normal", { bg = "#010a0c" })

  -- Sync with system clipboard if we don't happen to run as root (doesn't work in 
  -- Wayland) or connected with SSH.
  local user = os.getenv("USER") or ""
  if user ~= "root" and not vim.env.SSH_TTY then
    --  Schedule the setting after `UiEnter` because it can increase startup-time.
    vim.schedule(function()
      vim.o.clipboard = "unnamedplus"
    end)
  end

  vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank()
      end
  })

  local term_buf = vim.api.nvim_create_buf(true, false)
  local term_io = vim.api.nvim_open_term(term_buf, {})
  -- Map 'q' to first yank the visual selection (if any), which makes the copy selection work, and then quit.
  local map = vim.api.nvim_buf_set_keymap
  map(term_buf, 'v', 'q', 'y<Cmd>qa!<CR>', {})
  -- Regular quit mapping for normal mode
  map(term_buf, 'n', 'q', '<Cmd>qa!<CR>', {})
  map(term_buf, 'n', 'i', '<Cmd>qa!<CR>', {})
  map(term_buf, 'n', '<C-c>', '<Cmd>qa!<CR>', {})
  local group = vim.api.nvim_create_augroup('kitty-scrollback', { clear = true })

  local setCursor = function()
    local max_line_nr = vim.api.nvim_buf_line_count(term_buf)
    local top_line = math.max(1, math.min(tonumber(INPUT_LINE_NUMBER) or 1, max_line_nr))
    local cursor_row = tonumber(CURSOR_LINE) or 0
    local cursor_line
    if cursor_row < 1 then
      cursor_line = top_line
    else
      -- Kitty provides CURSOR_LINE as the cursor row in the visible viewport.
      -- Convert it to an absolute scrollback line by offsetting from the top line.
      cursor_line = math.min(top_line + cursor_row - 1, max_line_nr)
    end
    local cursor_col = math.max(0, (tonumber(CURSOR_COLUMN) or 1))
    -- It seems that both the view (view.topline) and the cursor (nvim_win_set_cursor) must be set
    -- for scrolling and cursor positioning to work reliably with terminal buffers.
    vim.fn.winrestview({ topline = top_line })
    vim.api.nvim_win_set_cursor(0, { math.max(1, math.min(cursor_line, max_line_nr)), cursor_col })
  end

  vim.api.nvim_create_autocmd('ModeChanged', {
    group = group,
    buffer = term_buf,
    callback = function()
      local mode = vim.fn.mode()
      if mode == 't' then
        vim.cmd.stopinsert()
        vim.schedule(setCursor)
      end
    end,
  })

  vim.api.nvim_create_autocmd('VimEnter', {
    group = group,
    pattern = '*',
    once = true,
    callback = function(ev)
      local current_win = vim.fn.win_getid()
      -- Instead of sending lines individually, concatenate them.
      local main_lines = vim.api.nvim_buf_get_lines(ev.buf, 0, -2, false)
      local content = table.concat(main_lines, '\r\n')
      vim.api.nvim_chan_send(term_io, content .. '\r\n')

      -- Process the last line separately (without trailing \r\n)
      local last_line = vim.api.nvim_buf_get_lines(ev.buf, -2, -1, false)[1]
      if last_line then
        vim.api.nvim_chan_send(term_io, last_line)
      end
      vim.api.nvim_win_set_buf(current_win, term_buf)
      vim.api.nvim_buf_delete(ev.buf, { force = true } )
      -- Use vim.defer_fn to make sure the terminal has time to process the content and the buffer is ready.
      vim.defer_fn(setCursor, 10)
    end
  })
end
