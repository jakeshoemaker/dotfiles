-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- [[ set buffer specific tabstops ]]
local cmd = vim.cmd
cmd [[
  autocmd BufEnter *.py :setlocal tabstop=4 shiftwidth=4 expandtab
  autocmd BufEnter *.js :setlocal tabstop=2 shiftwidth=2 expandtab
  autocmd BufEnter *.ts :setlocal tabstop=2 shiftwidth=2 expandtab
  autocmd BufEnter *.lua :setlocal tabstop=2 shiftwidth=2 expandtab
  autocmd BufEnter *.tsx :setlocal tabstop=2 shiftwidth=2 expandtab
  autocmd BufEnter *.go :setlocal tabstop=4 shiftwidth=4 expandtab
]]

-- controls for moving in and out of a terminal
function _G.set_terminal_keymaps()
  local opts = { buffer = 0 }
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
  vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
end

vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
