
-- Built-in Neovim behavior

-- stylua: ignore start
-- The next part (until `-- stylua: ignore end`) is aligned manually for easier
-- reading.

-- Settings in this section are applied when running under VSCode.

-- Editing ====================================================================
vim.o.autoindent    = true      -- Use auto indent
vim.o.autowrite     = true      -- Enable auto write
vim.o.expandtab     = true      -- Convert tabs to spaces
vim.o.formatoptions = 'rqnl1j'  -- Improve comment editing
vim.o.ignorecase    = true      -- Ignore case during search
vim.o.infercase     = true      -- Infer case in built-in completion 
vim.o.shiftwidth    = 2         -- Use this number of spaces for indentation
vim.o.smartcase     = true      -- Respect case if search pattern has upper case
vim.o.smartindent   = true      -- Make indenting smart
vim.o.spelloptions  = 'camel'   -- Treat camelCase word parts as separate words
vim.o.tabstop       = 2         -- Show tab as this number of spaces
vim.opt.timeoutlen = vim.g.vscode and 1000 or 300 -- Lower than default (1000) to quickly trigger which-key
-- vim.o.virtualedit   = 'block' -- Allow going past end of line in blockwise mode

vim.o.iskeyword = '@,48-57,_,192-255,-' -- Treat dash as `word` textobject part

-- Pattern for a start of numbered list (used in `gw`). This reads as
-- "Start of list item is: at least one special character (digit, -, +, *)
-- possibly followed by punctuation (. or `)`) followed by at least one space".
vim.o.formatlistpat = [[^\s*[0-9\-\+\*]\+[\.\)]*\s\+]]

-- Own additions
vim.o.confirm       = true      -- Confirm to save changes before exiting modified buffer
vim.o.gdefault      = true      -- Use global /g flag for :s by default.
vim.o.grepformat    = "%f:%l:%c:%m"
vim.o.grepprg       = "rg --vimgrep"
vim.o.inccommand    = "split"
vim.o.relativenumber = true     -- Use relative line numbers.
vim.o.report        = 50        -- Report only operations of atleast this many lines.
vim.o.scrolloff     = 8         -- Minimum number of screen lines to keep above and below the cursor.
vim.o.selectmode    = "key"     -- When to start Select mode.
vim.o.sidescrolloff = 8         -- Columns of context
vim.o.updatetime    = 300       -- Save swap file and trigger CursorHold
vim.o.virtualedit   = "block,onemore" -- Cursor can go paste last character and after block
vim.o.wildmode      = "longest:full,full" -- Command-line completion mode
-- vim.o.pumblend = 10  -- Transparency for pop-up menus.
-- vim.o.winblend = 10  -- Transparency for floating windows.
-- vim.opt.listchars = "tab:→ ,trail:·,extends:…,precedes:…,nbsp:␣"

-- UI
vim.o.breakindent    = true       -- Indent wrapped lines to match line start
vim.o.breakindentopt = 'list:-1'  -- Add padding for lists (if 'wrap' is set)
vim.o.cursorline     = true       -- Enable current line highlighting
vim.o.number         = true       -- Show line numbers
vim.o.pumheight      = 10         -- Make popup menu smaller
vim.o.shortmess      = 'CFOSWaco' -- Disable some built-in completion messages
vim.o.showbreak      = "↪ "       -- Show before wrapped lines.
vim.o.signcolumn     = 'yes'      -- Always show signcolumn (less flicker)
vim.o.splitbelow     = true       -- Horizontal splits will be below
vim.o.splitkeep      = 'screen'   -- Reduce scroll during window split
vim.o.splitright     = true       -- Vertical splits will be to the right
vim.o.winborder      = 'single'   -- Use border in floating windows

local user = os.getenv("USER") or ""

-- Sync with system clipboard if we don't happen to run as root (doesn't work in 
-- Wpayland) or connected with SSH.
if user ~= "root" and not vim.env.SSH_TTY then
  --  Schedule the setting after `UiEnter` because it can increase startup-time.
  vim.schedule(function()
    vim.o.clipboard = "unnamedplus"
  end)
end

if vim.g.vscode then return {} end

-- Non VSCode settings after this ---------------------------------------------

-- General ====================================================================

-- Mouse
vim.o.mouse = 'a'                  -- Enable mouse
vim.o.mousemoveevent = true        -- Enables mouse hover functionality.
vim.o.mousescroll = 'ver:5,hor:5' -- Customize mouse scroll

-- Disable "How-to disable mouse" from mouse context menu.
vim.cmd('silent! aunmenu PopUp.How-to\\ disable\\ mouse')
vim.cmd('silent! aunmenu PopUp.-2-')

vim.o.shada = "'100,<50,s10,:1000,/100,@100,h" -- Limit ShaDa file (for startup)

-- Enable all filetype plugins and syntax (if not enabled, for better startup)
vim.cmd('filetype plugin indent on')
if vim.fn.exists('syntax_on') ~= 1 then vim.cmd('syntax enable') end

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

vim.o.colorcolumn    = '80,+1'    -- Draw column on the right of maximum width
vim.o.cursorlineopt = 'screenline,number' -- Show cursor line per screen line
-- Folding. In Treesitter settings expr fold method is set if language supports
-- Treesitter.
vim.o.foldmethod     = 'indent' -- Fold based on indent level
vim.o.foldnestmax    = 10       -- Limit number of fold levels
vim.o.foldtext       = 'NONE'   -- Show text under fold with its highlighting
vim.o.foldlevel      = 99       -- Fold nothing by default; set to 0 or 1 to fold
vim.o.foldlevelstart = 99       -- Make sure folds are open by default.
vim.o.linebreak      = true       -- Wrap lines at 'breakat' (if 'wrap' is set)
vim.o.list           = true       -- Show helpful text indicators
vim.o.ruler          = false      -- Don't show default cursor coordinates
vim.o.showmode       = false      -- Don't show mode in command line
vim.o.smoothscroll   = true
vim.o.spell          = false      -- Spellcheck
vim.o.switchbuf      = 'usetab'   -- Use already opened buffers when switching
vim.o.title          = true       -- the title of the window will be set to the
                                  -- value of -- 'titlestring'
vim.o.undofile       = true       -- Enable persistent undo
vim.o.wrap           = false      -- Don't visually wrap lines

-- Special UI symbols. More is set via 'mini.basics' later.
vim.opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = "╌",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}

vim.o.listchars = 'extends:…,nbsp:␣,precedes:…,tab:» '

-- Built-in completion
vim.o.complete    = '.,w,b,kspell'                  -- Use less sources
vim.o.completeopt = 'menuone,noselect,fuzzy,nosort' -- Use custom behavior

vim.o.guifont = "FiraCode Nerd Font:h12"

-- Neovide GUI settings.
-- https://neovide.dev/index.html
if vim.g.neovide then
  -- Make Neovide animations a lot faster and less distracting.
  vim.g.neovide_cursor_animation_length = 0.03
  vim.g.neovide_cursor_trail_size = 0.08
end

-- Autocommands ===============================================================

-- Don't auto-wrap comments and don't insert comment leader after hitting 'o'.
-- Do on `FileType` to always override these changes from filetype plugins.
-- local f = function() vim.cmd('setlocal formatoptions-=c formatoptions-=o') end
-- _G.Config.new_autocmd('FileType', nil, f, "Proper 'formatoptions'")

local function augroup(name)
  return vim.api.nvim_create_augroup("Custom_" .. name, { clear = true })
end

vim.api.nvim_create_autocmd({ "FileType" }, {
  desc = "Proper 'formatoptions'",
  group = vim.api.nvim_create_augroup("Custom_formatoptions", { clear = true }),
  pattern = nil,
  callback = function()
    vim.cmd('setlocal formatoptions-=c formatoptions-=o')
  end
})

-- There are other autocommands created by 'mini.basics'. See 'plugin/30_mini.lua'.

-- Diagnostics ================================================================

local diagnostic_opts = {
  -- Show signs on top of any other sign, but only for warnings and errors
  signs = { priority = 9999, severity = { min = 'WARN', max = 'ERROR' } },

  -- Show all diagnostics as underline (for their messages type `<Leader>ld`)
  underline = { severity = { min = 'HINT', max = 'ERROR' } },

  -- Show more details immediately for errors on the current line
  virtual_lines = false,
  virtual_text = {
    current_line = true,
    severity = { min = 'ERROR', max = 'ERROR' },
  },

  -- Don't update diagnostics when typing
  update_in_insert = false,
}

-- safely apply diagnostics config
local function apply_diagnostics()
  if vim.g.have_nerd_font then  -- Set at start of the file.
    -- TODO: Apple these in snacks.statuscolumn?
    --https://github.com/folke/snacks.nvim/blob/main/docs/statuscolumn.md
    diagnostic_opts.signs.text = {
      [vim.diagnostic.severity.ERROR] = "󰅚 ",
      [vim.diagnostic.severity.WARN]  = "󰀪 ",
      [vim.diagnostic.severity.INFO]  = "󰋽 ",
      [vim.diagnostic.severity.HINT]  = "󰌶 ",
    }
  end
  vim.diagnostic.config(diagnostic_opts)
end

-- Apply diagnostics. Use MiniDeps or Lazy.nvim if available, else fallback.
-- Defer startup for speed.
local ok_mini, MiniDeps = pcall(require, "mini.deps")
if ok_mini and MiniDeps.later then
  MiniDeps.later(apply_diagnostics)
else
  local ok_lazy, _ = pcall(require, "lazy")
  if ok_lazy then
    vim.schedule(apply_diagnostics)
  else
    apply_diagnostics()
  end
end

-- Default:
-- MiniDeps.later(function() vim.diagnostic.config(diagnostic_opts) end)

-- stylua: ignore end
