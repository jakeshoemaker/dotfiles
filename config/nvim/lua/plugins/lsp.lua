-- In my nixos build I'm gonna move away from using mason.
-- With nix's declarative package management we can install language
-- tooling in the project folder, and then as needed install languages
-- and tools globally with home-manager. So now we won't need mason
-- to install language servers, instead we just use vanilla lspconfig
return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost" },
    cmd = { "LspInfo", "LspInstall", "LspUninstall", "Mason" },
    dependencies = {
      -- LSP installer plugins
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      -- Integrate blink w/ LSP
      "saghen/blink.cmp",
      "mfussenegger/nvim-lint",
      -- Progress indicator for LSP
      { "j-hui/fidget.nvim" },
    },
    config = function()
      local map_lsp_keybinds = require("shoe.keymaps").map_lsp_keybinds

      -- Default LSP handlers with rounded borders
      local default_handlers = {
        ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
        ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
      }

      local ts_ls_inlay_hints = {
        includeInlayEnumMemberValueHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayVariableTypeHintsWhenTypeMatchesName = true,
      }

      -- on_attach: call your custom keymap binding function
      local on_attach = function(_client, buffer_number)
        map_lsp_keybinds(buffer_number)
      end

      -- List your LSP servers here.
      local servers = {
        bashls = {},
        cssls = {},
        eslint = {
          autostart = false,
          cmd = { "vscode-eslint-language-server", "--stdio", "--max-old-space-size=12288" },
          settings = { format = false },
        },
        gleam = {},
        html = {},
        jsonls = {},
        lua_ls = {
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              workspace = {
                checkThirdParty = false,
                library = {
                  "${3rd}/luv/library",
                  unpack(vim.api.nvim_get_runtime_file("", true)),
                },
              },
              telemetry = { enabled = false },
            },
          },
        },
        marksman = {},
        ocamllsp = {
          manual_install = true,
          cmd = { "dune", "exec", "ocamllsp" },
          settings = {
            codelens = { enable = true },
            inlayHints = { enable = true },
            syntaxDocumentation = { enable = true },
          },
        },
        nixd = {},
        nil_ls = {},
        phpactor = {},
        pyright = {
          settings = {
            pyright = {
              -- use ruff's import organizer
              disableOrganizeImports = true,
            },
            python = {
              analysis = {
                -- Ignore all files to use ruff for linting
                ignore = { '*' },
              },
            },
          },
        },
        ruff = {
          init_options = {
            settings = {
              reportAny = false,
              reportExplicitAny = false,
            }
          }
        },
        sqlls = {},
        tailwindcss = {
          filetypes = { "typescriptreact", "javascriptreact", "html", "svelte" },
        },
        ts_ls = {
          on_attach = function(client, buffer_number)
            require("twoslash-queries").attach(client, buffer_number)
            return on_attach(client, buffer_number)
          end,
          settings = {
            maxTsServerMemory = 12288,
            typescript = { inlayHints = ts_ls_inlay_hints },
            javascript = { inlayHints = ts_ls_inlay_hints },
          },
        },
        yamlls = {},
        svelte = {},
        rust_analyzer = {
          check = { command = "clippy", features = "all" },
        },
      }

      local formatters = {
        prettierd = {},
        stylua = {},
      }

      -- Use blink.cmp to extend LSP capabilities.
      -- This replaces the cmp-nvim-lsp integration.
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      -- Setup each LSP server. We merge in any server-specific capabilities by passing
      -- the existing config.capabilities to blink.cmp.get_lsp_capabilities.
      for name, config in pairs(servers) do
        require("lspconfig")[name].setup({
          autostart = config.autostart,
          cmd = config.cmd,
          capabilities = capabilities,
          filetypes = config.filetypes,
          handlers = vim.tbl_deep_extend("force", {}, default_handlers, config.handlers or {}),
          on_attach = config.on_attach or on_attach,
          settings = config.settings,
          root_dir = config.root_dir,
        })
      end

      -- Configure borders for LspInfo UI and diagnostics
      require("lspconfig.ui.windows").default_options.border = "rounded"
      vim.diagnostic.config({ float = { border = "rounded" } })
    end,
  },
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    opts = {
      notify_on_error = false,
      default_format_opts = {
        async = true,
        timeout_ms = 500,
        lsp_format = "fallback",
      },
      format_after_save = {
        async = true,
        timeout_ms = 500,
        lsp_format = "fallback",
      },
      formatters_by_ft = {
        javascript = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        python = { "ruff_format" },
        rust = { "rustfmt" },
        lua = { "stylua" },
      },
      formatters = {
        ruff_format = {
          args = { "--line-length=88" },
        },
        rustfmt = {
          args = { "--edition=2021" },
        },
      },
    },
  },
}
