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
      require("mini.statusline").setup()
      require("mini.surround").setup()

      MiniIcons.mock_nvim_web_devicons()
    end,
  },
}
