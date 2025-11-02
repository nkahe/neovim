
return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
    'saghen/blink.cmp',
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
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      -- "nvim-mini/mini.nvim"  -- So mini.completion is available.
      -- Autoformatting
      "stevearc/conform.nvim",
    },

    opts = {
      servers = {
        bashls = true,
        lua_ls = {
          cmd = { "lua-language-server" },
        }
      }
    },
    -- opts = {
    --   servers = { "bashls", "lua_ls" },
      -- on_attach = function(client, bufnr)
      --   vim.bo[bufnr].omnifunc = "v:lua.MiniCompletion.completefunc_lsp",
      --   vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "LSP Hover" })
      -- end
    -- },
    config = function(_, opts)

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

      -- local MiniCompletion = require("mini.completion")
      -- local capabilities = MiniCompletion.get_lsp_capabilities()

      -- Configure Mason LSP after it loads
      -- local mlsp = require("mason-lspconfig")
      -- mlsp.setup()  -- basic setup

      local blink_capabilities = require('blink.cmp').get_lsp_capabilities()

      vim.lsp.config("*", { capabilities = blink_capabilities })

      vim.lsp.enable({ "lua_ls", "bashls", "shellcheck" })

      -- Test: vim.api.

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

      local disable_semantic_tokens = {
        -- lua = true,
      }

      --  This function gets run when an LSP attaches to a particular buffer.
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
        callback = function(event)
          local bufnr = event.buf
          local client = assert(vim.lsp.get_client_by_id(event.data.client_id), "must have valid client")

          local settings = opts.servers[client.name]
          if type(settings) ~= "table" then
            settings = {}
          end

          -- Set keymap for current buffer.
          local map = function(mode, lhs, rhs, opts)
            opts.buffer = event.buf
            vim.keymap.set(mode, lhs, rhs, opts)
          end

          map("n", "<leader>cl", function() Snacks.picker.lsp_config() end, { desc = "Lsp Info" })
          -- Mapped with mini.basics.
          -- map("n", "gd", vim.lsp.buf.definition, { desc = "Goto Definition" })
          -- map("n", "gr", vim.lsp.buf.references, { desc = "References", nowait = true })
          -- map("n", "gI", vim.lsp.buf.implementation, { desc = "Goto Implementation" })
          -- -- TODO: mappings from g?
          map("n", "ct", vim.lsp.buf.type_definition, { desc = "Goto T[y]pe Definition" })
          -- map("n", "gD", vim.lsp.buf.declaration, { desc = "Goto Declaration" })
          -- map("n", "K", function() return vim.lsp.buf.hover() end, { desc = "Hover" })
          -- map("n", "gK", function() return vim.lsp.buf.signature_help() end, { desc = "Signature Help" })
          map("i", "<c-k>", function() return vim.lsp.buf.signature_help() end, { desc = "Signature Help" })
          map({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
          map({ "n", "x" }, "<leader>cc", vim.lsp.codelens.run, { desc = "Run Codelens" })
          map("n", "<leader>cC", vim.lsp.codelens.refresh, { desc = "Refresh & Display Codelens" })
          map("n", "<leader>cR", function() Snacks.rename.rename_file() end, { desc = "Rename File" })
          map("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename" })
          -- map("n", "<leader>cA", LazyVim.lsp.action.source, { desc = "Source Action" })
          map("n", "]]", function() Snacks.words.jump(vim.v.count1) end, {
            desc = "Next Reference",
            silent = true,
            callback = function() return Snacks.words.is_enabled() end,
          })
          map("n", "[[", function() Snacks.words.jump(-vim.v.count1) end, {
            desc = "Prev Reference",
            silent = true,
            callback = function() return Snacks.words.is_enabled() end,
          })
          map("n", "<a-n>", function() Snacks.words.jump(vim.v.count1, true) end, {
            desc = "Next Reference",
            silent = true,
            callback = function() return Snacks.words.is_enabled() end,
          })
          map("n", "<a-p>", function() Snacks.words.jump(-vim.v.count1, true) end, {
            desc = "Prev Reference",
            silent = true,
            callback = function() return Snacks.words.is_enabled() end,
          })

          -- vim.keymap.set("n", "gd", builtin.lsp_definitions, { buffer = 0 })
          -- vim.keymap.set("n", "gr", builtin.lsp_references, { buffer = 0 })
          -- vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = 0 })
          -- vim.keymap.set("n", "gT", vim.lsp.buf.type_definition, { buffer = 0 })
          -- vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = 0 })
          --
          -- vim.keymap.set("n", "<space>cr", vim.lsp.buf.rename, { buffer = 0 })
          -- vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, { buffer = 0 })
          -- vim.keymap.set("n", "<space>wd", builtin.lsp_document_symbols, { buffer = 0 })
          -- vim.keymap.set("n", "<space>ww", function()
          --   builtin.diagnostics { root_dir = true }
          -- end, { buffer = 0 })

          local filetype = vim.bo[bufnr].filetype
          if disable_semantic_tokens[filetype] then
            client.server_capabilities.semanticTokensProvider = nil
          end

          -- Override server capabilities
          if settings.server_capabilities then
            for k, v in pairs(settings.server_capabilities) do
              if v == vim.NIL then
                ---@diagnostic disable-next-line: cast-local-type
                v = nil
              end

              client.server_capabilities[k] = v
            end
          end
        end,
      })

    end -- config
  },

  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = { "bashls", "lua_ls", "shellcheck" },
      install_root_dir = vim.fn.expand("~/.local/share/nvim/mason"),
    },
  },

  -- {
  --   'echasnovski/mini.completion',
  --   version = false,
  --   event = 'LspAttach',
  --   config = function()
  --     -- Customize LSP completion behavior
  --     local process_items_opts = { kind_priority = { Text = -1, Snippet = 99 } }
  --
  --     require('mini.completion').setup({
  --       lsp_completion = {
  --         source_func = 'omnifunc',
  --         auto_setup = false,
  --         -- process_items = process_items,
  --       },
  --     })
  --
  --     -- Use your existing helper function for autocmd
  --     Config.new_autocmd('LspAttach', nil, function(ev)
  --       vim.bo[ev.buf].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp'
  --     end, "Set 'omnifunc'")
  --
  --     -- Add completion-related LSP capabilities
  --     -- vim.lsp.config('*', {
  --     --   capabilities = MiniCompletion.get_lsp_capabilities(),
  --     -- })
  --   end,
  -- },
  
}
