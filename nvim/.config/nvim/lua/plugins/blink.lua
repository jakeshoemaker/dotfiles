return {
	{
		"saghen/blink.cmp",
		version = "1.*",
		dependencies = {
			"rafamadriz/friendly-snippets",
			"onsails/lspkind.nvim",
			"echasnovski/mini.icons",
		},
		opts = {
			enabled = function()
				local ft = vim.bo.filetype
				if ft == "vimwiki" or ft == "markdown" or ft:match("^markdown%.") then
					return false
				end
				return true
			end,
			completion = {
				documentation = {
					auto_show = true,
					window = { border = "rounded" },
				},
				ghost_text = { enabled = true },
				menu = {
					auto_show = true,
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
			sources = {
				default = {
					"lsp",
					"path",
					"snippets",
					"buffer",
				},
			},
			appearance = {
				nerd_font_variant = "Nerd Font Mono",
			},
		},
	},
}
