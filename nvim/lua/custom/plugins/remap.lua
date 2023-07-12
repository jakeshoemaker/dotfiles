-- move highlighted text up/down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- preserve yank
vim.keymap.set('x', '<leader>p', '\'_dP')

return {}
