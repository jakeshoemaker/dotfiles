vim.api.nvim_create_autocmd({ "BufEnter" }, {
  pattern = { "*.php" },
  group = group,
  callback = function()
    vim.bo.autoindent = true
    vim.bo.expandtab = true
    vim.bo.tabstop = 4
    vim.bo.shiftwidth = 4
    vim.cmd('echo "PHP aucmd triggered!"')
  end,
})
