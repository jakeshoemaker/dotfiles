-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- move between splits
vim.keymap.set('n', '<C-k>', ':wincmd k<CR>', { silent = true })
vim.keymap.set('n', '<C-j>', ':wincmd j<CR>', { silent = true })
vim.keymap.set('n', '<C-h>', ':wincmd h<CR>', { silent = true })
vim.keymap.set('n', '<C-l>', ':wincmd l<CR>', { silent = true })

-- [[ Diagnostic keymaps ]]

-- open diagnostics in qf list
vim.keymap.set('n', '<leader>qf', ':lua vim.diagnostic.setqflist()<CR>', { silent = true })

vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })
