
-- LSP magic happens here.

return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    'saghen/blink.cmp',
    {
      -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
      -- used for completion, annotations and signatures of Neovim apis.
      "folke/lazydev.nvim",
      ft = "lua",
      opts = {
        library = {
          "lazy.nvim",
          -- Load luvit types when the `vim.uv` word is found
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          { path = "snacks.nvim", words = { "Snacks" } },
        },
      },
    },
    { "mason-org/mason.nvim",
      opts = {
        -- Make different Nvim configs use same servers.
        install_root_dir = vim.fn.expand("~/.local/share/nvim/mason"),
      },
    },
    "mason-org/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    -- "nvim-mini/mini.nvim"  -- if want to use mini.completion.
    -- Autoformatting
    "stevearc/conform.nvim",
  },
  -- Server specific settings.
  opts = {
    servers = {
      bashls = true,
      lua_ls = true,
    }
  },
  config = function(_, opts)

    -- Don't use LSP if using Obsidian.nvim.
    -- if vim.g.obsidian then
    --   return
    -- end

    -- capabilities = function()
    --   local MiniCompletion = require("mini.completion")
    --   return MiniCompletion.get_lsp_capabilities()
    -- end

    -- local MiniCompletion = require("mini.completion")
    -- local capabilities = MiniCompletion.get_lsp_capabilities()

    local blink_capabilities = require('blink.cmp').get_lsp_capabilities()

    local servers_to_install = vim.tbl_filter(function(key)
      local t = opts.servers[key]
      if type(t) == "table" then
        return not t.manual_install
      else
        return t
      end
    end, vim.tbl_keys(opts.servers))

    require("mason").setup()
    local ensure_installed = {
      "stylua",
      "lua_ls",
    }

    vim.list_extend(ensure_installed, servers_to_install)
    require("mason-tool-installer").setup { ensure_installed = ensure_installed }

    -- Set global capabilities for all LSP servers
    vim.lsp.config("*", { capabilities = blink_capabilities, })

    -- Configure and enable each LSP server
    for name, config in pairs(opts.servers) do
      if config == true then
        config = {}
      end

      -- Only call vim.lsp.config if there are server-specific settings
      if next(config) ~= nil then
        -- Remove manual_install flag as it's not an LSP config field
        local lsp_config = vim.tbl_deep_extend("force", {}, config)
        lsp_config.manual_install = nil
        vim.lsp.config(name, lsp_config)
      end

      vim.lsp.enable(name)
    end

    --  This function gets run when an LSP attaches to a particular buffer.
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
      callback = function(event)
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
      end,
    })  -- vim.api.nvim_create_autocmd

  end -- config
}
