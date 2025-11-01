
-- Mason. Manages language servers.
return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
        -- used for completion, annotations and signatures of Neovim apis.
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
          library = {
            -- Load luvit types when the `vim.uv` word is found
            -- See the configuration section for more details
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      "nvim-mini/mini.nvim"  -- So mini.completion is available.
    },
    -- opts = {
    --   servers = { "bashls", "lua_ls" },
      -- on_attach = function(client, bufnr)
      --   vim.bo[bufnr].omnifunc = "v:lua.MiniCompletion.completefunc_lsp",
      --   vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "LSP Hover" })
      -- end
    -- },
    config = function()

      -- Don't enable LSP if using Obsidian.nvim.
      if vim.g.obsidian then
        return
      end

      -- require('lspconfig').lua_ls.setup({
      --   settings = {
      --     Lua = {
      --       runtime = {
      --         -- Tell the language server you're using LuaJIT in Neovim
      --         version = 'LuaJIT',
      --       },
      --       diagnostics = {
      --         -- Recognize the `vim` global
      --         globals = { 'vim' },
      --       },
      --       workspace = {
      --         -- Make the server aware of Neovim runtime files
      --         library = vim.api.nvim_get_runtime_file("", true),
      --         checkThirdParty = false,
      --       },
      --       telemetry = { enable = false },
      --     },
      --   },
      -- })

      -- capabilities = function()
      --   local MiniCompletion = require("mini.completion")
      --   return MiniCompletion.get_lsp_capabilities()
      -- end

      local MiniCompletion = require("mini.completion")
      local capabilities = MiniCompletion.get_lsp_capabilities()

      -- Configure Mason LSP after it loads
      -- local mlsp = require("mason-lspconfig")
      -- mlsp.setup()  -- basic setup

      vim.lsp.config("*", { capabilities = capabilities })

      vim.lsp.enable({ "lua_ls", "bashls", "shellcheck" })

      -- Testaa: vim.api.

      -- manually setup servers listed in opts.servers
      -- for _, server in ipairs(opts.servers) do
      --   if lspconfig[server] and not vim.tbl_isempty(vim.lsp.get_active_clients({ name = server })) then
      --     -- already active, skip
      --   else
      --     lspconfig[server].setup({
      --       capabilities = type(opts.capabilities) == "function" and opts.capabilities() or opts.capabilities,
      --       on_attach = opts.on_attach,
      --     })
      --   end
      -- end
    end
  },
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = { "bashls", "lua_ls", "shellcheck" },
      install_root_dir = vim.fn.expand("~/.local/share/nvim/mason"),
    },
  },

  {
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
      -- vim.lsp.config('*', {
      --   capabilities = MiniCompletion.get_lsp_capabilities(),
      -- })
    end,
  },
}
