local builtin = require('telescope.builtin')

return {
  {
    'tpope/vim-rails',
    dependencies = {
      'tpope/vim-projectionist',
      'tpope/vim-bundler',
      'tpope/vim-dispatch',
    },
    ft = { 'ruby', 'eruby', 'rake', 'haml' },
    config = function()
      vim.keymap.set('n', '<leader>rm', function()
        builtin.find_files({ cwd = 'app/models' })
      end, { desc = 'find ruby model' })

      vim.keymap.set('n', '<leader>rc', function()
        builtin.find_files({ cwd = 'app/controllers' })
      end, { desc = 'find ruby controller' })

      vim.keymap.set('n', '<leader>rr', function()
        builtin.find_files({
          search_dirs = {
            "app",
            "config",
            "db",
            "lib",
            "spec",
            "test"
          }
        })
      end, { desc = 'find in rails project' })
    end,
  },
}
