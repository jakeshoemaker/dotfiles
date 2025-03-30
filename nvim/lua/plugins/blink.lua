return {
	-- First, add supermaven-nvim
	{
		"supermaven-inc/supermaven-nvim",
		config = function()
			require("supermaven-nvim").setup({
				-- Configure supermaven options as needed
				disable_inline_completion = true, -- disable inline completion for use with blink.cmp
			})
		end,
	},

	-- Add blink.compat to bridge between nvim-cmp sources and blink.cmp
	{
		"saghen/blink.compat",
		-- Use the latest release if you also use the latest release for blink.cmp
		version = "*",
		-- Lazy loading - will be loaded automatically when needed by blink.cmp
		lazy = true,
		-- Make sure to set opts so that lazy.nvim calls blink.compat's setup
		opts = {},
	},

	-- Finally, configure blink.cmp with supermaven as a source
	{
		"saghen/blink.cmp",
		-- Optionally specify a version if needed
		-- version = "0.*",
		dependencies = {
			"supermaven-inc/supermaven-nvim",
			"saghen/blink.compat",
			"rafamadriz/friendly-snippets",
			"onsails/lspkind.nvim",
			"echasnovski/mini.icons",
		},
		opts = {
			-- Completion menu settings
			completion = {
				documentation = {
					auto_show = true,
					window = { border = "rounded" },
				},
				ghost_text = { enabled = true },
				menu = {
					border = "rounded",
					draw = {
						columns = {
							{ "label", "label_description", gap = 1 },
							{ "kind_icon", "kind", gap = 1 },
							{ "source_name" },
						},
						components = {
							source_name = {
								text = function(ctx)
									return "[" .. ctx.source_name .. "]"
								end,
							},
							kind_icon = {
								ellipsis = false,
								text = function(ctx)
									local icon = ctx.kind_icon
									if vim.tbl_contains({ "Path" }, ctx.source_name) then
										local dev_icon = require("mini.icons").get("lsp", ctx.kind)
										if dev_icon then
											icon = dev_icon
										end
									else
										icon = require("lspkind").symbolic(ctx.kind, { mode = "symbol" })
									end
									return icon .. ctx.icon_gap
								end,
								highlight = function(ctx)
									local hl = ctx.kind_hl
									if vim.tbl_contains({ "Path" }, ctx.source_name) then
										local _, dev_hl = require("mini.icons").get("lsp", ctx.kind)
										if dev_hl then
											hl = dev_hl
										end
									end
									return hl
								end,
							},
						},
					},
				},
			},

			-- Keymaps
			keymap = {
				preset = "default",
				["<C-k>"] = { "select_prev", "fallback" },
				["<C-j>"] = { "select_next", "fallback" },
				["<C-u>"] = { "scroll_documentation_up", "fallback" },
				["<C-d>"] = { "scroll_documentation_down", "fallback" },
				["<Tab>"] = {
					function(cmp)
						if cmp.is_menu_visible() then
							return cmp.select_next()
						elseif vim.snippet.active() then
							return vim.snippet.jump(1)
						end
					end,
					"fallback",
				},
				["<S-Tab>"] = {
					function(cmp)
						if cmp.is_menu_visible() then
							return cmp.select_prev()
						elseif vim.snippet.active() then
							return vim.snippet.jump(-1)
						end
					end,
					"fallback",
				},
				["<C-c>"] = { "cancel" },
				["<CR>"] = { "accept", "fallback" },
			},

			-- Add supermaven as a completion source
			sources = {
				-- Include supermaven in the default sources
				default = {
					"supermaven",
					"lsp",
					"path",
					"snippets",
					"buffer",
				},

				-- Register the supermaven provider
				providers = {
					supermaven = {
						name = "supermaven", -- Display name ( should be same as cmp source)
						module = "blink.compat.source", -- Use blink.compat to connect to supermaven
						-- Adjust priority if needed (higher number = higher priority)
						score_offset = 100, -- Optional: can be adjusted to prioritize Supermaven suggestions

						-- Any provider-specific options can go here
						opts = {},
					},
				},
			},

			-- Optional: configure appearance
			appearance = {
				-- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				nerd_font_variant = "Nerd Font Mono",

				-- Optional: Add an icon for Supermaven
				kind_icons = {
					Supermaven = "󰚩", -- You can change this to any icon you prefer
				},
			},
		},
	},
}
