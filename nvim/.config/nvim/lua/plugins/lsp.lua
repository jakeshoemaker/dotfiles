return {
	-- Mason: install LSP servers, formatters, and linters declaratively.
	{
		"williamboman/mason.nvim",
		cmd = { "Mason", "MasonInstall", "MasonUpdate", "MasonUninstall" },
		build = ":MasonUpdate",
		opts = {
			ui = { border = "rounded" },
		},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		event = "VeryLazy",
		dependencies = { "williamboman/mason.nvim" },
		opts = {
			ensure_installed = {
				-- LSP servers
				"bash-language-server",
				"css-lsp",
				"eslint-lsp",
				"html-lsp",
				"json-lsp",
				"lua-language-server",
				"marksman",
				"pyright",
				"ruff",
				"rust-analyzer",
				"sqlls",
				"svelte-language-server",
				"tailwindcss-language-server",
				"typescript-language-server",
				"yaml-language-server",
				-- Formatters / linters
				"prettierd",
				"stylua",
			},
			run_on_start = true,
			auto_update = false,
		},
	},

	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPost", "BufNewFile" },
		cmd = { "LspInfo", "LspInstall", "LspUninstall" },
		dependencies = {
			"williamboman/mason.nvim",
			"saghen/blink.cmp",
			{ "j-hui/fidget.nvim", opts = {} },
		},
		config = function()
			local map_lsp_keybinds = require("shoe.keymaps").map_lsp_keybinds

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

			local on_attach = function(_client, buffer_number)
				map_lsp_keybinds(buffer_number)
			end

			local capabilities = require("blink.cmp").get_lsp_capabilities()

			-- Per-server config (nvim 0.11+ API).
			local servers = {
				bashls = {},
				cssls = {},
				eslint = {
					settings = { format = false },
				},
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
				marksman = {
					filetypes = { "markdown" },
				},
				pyright = {
					settings = {
						pyright = {
							-- use ruff's import organizer
							disableOrganizeImports = true,
						},
						python = {
							analysis = {
								ignore = { "*" },
							},
						},
					},
				},
				ruff = {
					-- Match pyright's default position encoding to avoid mismatch warnings.
					capabilities = vim.tbl_deep_extend("force", capabilities, {
						general = { positionEncodings = { "utf-16" } },
					}),
					init_options = {
						settings = {
							reportAny = false,
							reportExplicitAny = false,
						},
					},
				},
				sqlls = {},
				tailwindcss = {
					filetypes = { "typescriptreact", "javascriptreact", "html", "svelte" },
				},
				ts_ls = {
					on_attach = function(client, buffer_number)
						local ok, twoslash = pcall(require, "twoslash-queries")
						if ok then
							twoslash.attach(client, buffer_number)
						end
						return on_attach(client, buffer_number)
					end,
					settings = {
						maxTsServerMemory = 12288,
						typescript = { inlayHints = ts_ls_inlay_hints },
						javascript = { inlayHints = ts_ls_inlay_hints },
					},
				},
				yamlls = {
					filetypes = { "yaml" },
				},
				svelte = {},
			}

			-- Only enable rust_analyzer when the rust toolchain is available; it
			-- needs to call `rustc --print sysroot` and errors out otherwise.
			if vim.fn.executable("rustc") == 1 then
				servers.rust_analyzer = {
					settings = {
						["rust-analyzer"] = {
							check = { command = "clippy" },
						},
					},
				}
			end

			-- Register configs and enable servers via the new vim.lsp.config / vim.lsp.enable API.
			for name, config in pairs(servers) do
				vim.lsp.config(
					name,
					vim.tbl_deep_extend("force", {
						capabilities = capabilities,
						on_attach = on_attach,
					}, config)
				)
			end

			vim.lsp.enable(vim.tbl_keys(servers))

			-- Diagnostics + UI
			vim.diagnostic.config({
				float = { border = "rounded" },
				severity_sort = true,
				signs = true,
				underline = true,
				update_in_insert = false,
				virtual_text = { prefix = "●", spacing = 2 },
			})
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
				javascript = { "prettierd", "prettier", stop_after_first = true },
				typescript = { "prettierd", "prettier", stop_after_first = true },
				typescriptreact = { "prettierd", "prettier", stop_after_first = true },
				javascriptreact = { "prettierd", "prettier", stop_after_first = true },
				json = { "prettierd", "prettier", stop_after_first = true },
				css = { "prettierd", "prettier", stop_after_first = true },
				html = { "prettierd", "prettier", stop_after_first = true },
				markdown = { "prettierd", "prettier", stop_after_first = true },
				yaml = { "prettierd", "prettier", stop_after_first = true },
				python = { "ruff_format" },
				rust = { "rustfmt" },
				lua = { "stylua" },
			},
			formatters = {
				rustfmt = {
					args = { "--edition=2021" },
				},
			},
		},
	},
}
