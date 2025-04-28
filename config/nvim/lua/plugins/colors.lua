-- local function is_dark_mode()
--   local handle = io.popen("defaults read -g AppleInterfaceStyle 2>/dev/null")
--   if handle then
--     local result = handle:read("*a")
--     handle:close()
--     return result:match("Dark") ~= nil
--   end
--   return false
-- end

return {
	{
		"dgox16/oldworld.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			styles = {
				booleans = { italic = true, bold = true },
			},
			integrations = {
				blink = true,
				gitsigns = true,
				treesitter = true,
				lazy = true,
				lsp = true,
				-- oil = true, -- not a  option yet
				telescope = true,
			},
			highlight_overrides = {},
		},
		config = function(_, opts)
			require("oldworld").setup(opts)

			vim.cmd("colorscheme oldworld")
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		lazy = false,
		config = function()
			require("lualine").setup({
				options = {
					theme = "oldworld", -- Use your theme
					section_separators = { left = "", right = "" },
					component_separators = { left = " ", right = " " },
					icons_enabled = true,
				},
				sections = {
					lualine_a = {
						{
							"mode",
							fmt = function(str)
								return str
							end,
						},
					},
					lualine_b = {
						{
							"branch",
							icon = "", -- Git branch icon
						},
						{
							"diff",
							symbols = {
								added = "+",
								modified = "~",
								removed = "-",
							},
						},
					},
					lualine_c = {
						{
							"filename",
							path = 1, -- Show relative path
							symbols = {
								modified = "[+]",
								readonly = "[-]",
							},
						},
					},
					lualine_x = {
						{
							"diagnostics",
							sources = { "nvim_diagnostic" },
							symbols = {
								error = " ",
								warn = " ",
								info = " ",
								hint = " ",
							},
						},
						"encoding",
						"fileformat",
						"filetype",
					},
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = {
						{
							"filename",
							path = 1, -- Show relative path
							symbols = {
								readonly = "[-]",
							},
						},
					},
					lualine_x = { "location" },
					lualine_y = {},
					lualine_z = {},
				},
				extensions = { "lazy", "mason", "oil", "quickfix" },
			})
		end,
	},
}
