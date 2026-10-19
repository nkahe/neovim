
return {
  'echasnovski/mini.completion',
  version = false,
  event = 'LspAttach',
  config = function()
    -- Customize LSP completion behavior
    local process_items_opts = { kind_priority = { Text = -1, Snippet = 99 } }

    require('mini.completion').setup({
      lsp_completion = {
        source_func = 'omnifunc',
        auto_setup = false,
        -- process_items = process_items,
      },
    })

    -- Use your existing helper function for autocmd
    Config.new_autocmd('LspAttach', nil, function(ev)
      vim.bo[ev.buf].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp'
    end, "Set 'omnifunc'")

    -- Add completion-related LSP capabilities
    vim.lsp.config('*', {
      capabilities = MiniCompletion.get_lsp_capabilities(),
    })
  end,
},
