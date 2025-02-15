return {
  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("nightfox").setup({
        -- config go here!
      })

      vim.cmd("colorscheme carbonfox")
    end,
  }
}
