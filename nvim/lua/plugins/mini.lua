return {
	{
		"echasnovski/mini.nvim",
		init = function()
			package.preload["nvim-web-devicons"] = function()
				require("mini.icons").mock_nvim_web_devicons()
				return package.loaded["nvim-web-devicons"]
			end
		end,
		config = function()
			require("mini.ai").setup()
			require("mini.icons").setup()
			require("mini.pairs").setup()
			local starter = require("mini.starter")
			starter.setup({
				items = {
					starter.sections.telescope(),
				},
				content_hooks = {
					starter.gen_hook.adding_bullet(),
					starter.gen_hook.aligning("center", "center"),
				},
			})

			require("mini.surround").setup()

			MiniIcons.mock_nvim_web_devicons()
		end,
	},
}
