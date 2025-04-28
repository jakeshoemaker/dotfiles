vim.api.nvim_create_autocmd("FileType", {
  pattern = "ruby",
  callback = function()
    vim.bo.indentkeys = vim.bo.indentkeys:gsub(",\\.", "") -- indent messing up on dot

    vim.opt_local.autoindent = true
    vim.opt_local.smartindent = true

    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end,
})
