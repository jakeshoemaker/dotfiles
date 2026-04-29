return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },
  -- Highlight todo, notes, etc in comments
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false }
  },
  {
    -- Adds git releated signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        vim.keymap.set('n', '[c', require('gitsigns').prev_hunk, { buffer = bufnr, desc = 'Go to Previous Hunk' })
        vim.keymap.set('n', ']c', require('gitsigns').next_hunk, { buffer = bufnr, desc = 'Go to Next Hunk' })
        vim.keymap.set('n', '<leader>ph', require('gitsigns').preview_hunk, { buffer = bufnr, desc = '[P]review [H]unk' })
      end,
    },
  },
  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help indent_blankline.txt`,
    main = "ibl",
    opts = {},
  },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },
  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    dependencies = {
      { 'nvim-treesitter/nvim-treesitter-textobjects', branch = 'main' },
    },
    build = ':TSUpdate',
    config = function()
      local parsers = {
        'bash',
        'c',
        'cpp',
        'go',
        'lua',
        'markdown',
        'markdown_inline',
        'ocaml',
        'php',
        'python',
        'ruby',
        'rust',
        'tsx',
        'typescript',
        'vimdoc',
        'vim',
      }

      require('nvim-treesitter').install(parsers)

      local ts_select = require('vim.treesitter._select')
      local ts_textobjects_select = require('nvim-treesitter-textobjects.select')

      local function select_parent()
        if vim.treesitter.get_parser(0, nil, { error = false }) then
          ts_select.select_parent(1)
        else
          pcall(vim.lsp.buf.selection_range, 1)
        end
      end

      local function select_child()
        if vim.treesitter.get_parser(0, nil, { error = false }) then
          ts_select.select_child(1)
        else
          pcall(vim.lsp.buf.selection_range, -1)
        end
      end

      local function select_scope()
        ts_textobjects_select.select_textobject('@local.scope', 'locals', 'v')
      end

      local treesitter_group = vim.api.nvim_create_augroup('shoe-treesitter', { clear = true })
      vim.api.nvim_create_autocmd('FileType', {
        group = treesitter_group,
        callback = function(ev)
          pcall(vim.treesitter.start, ev.buf)

          if not vim.tbl_contains({ 'python', 'php' }, vim.bo[ev.buf].filetype)
            and vim.treesitter.get_parser(ev.buf, nil, { error = false }) then
            vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })

      require('nvim-treesitter-textobjects').setup({
        select = {
          lookahead = true,
          keymaps = {
            ['aa'] = '@parameter.outer',
            ['ia'] = '@parameter.inner',
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@class.outer',
            ['ic'] = '@class.inner',
          },
        },
        move = {
          set_jumps = true,
          goto_next_start = {
            [']m'] = '@function.outer',
            [']]'] = '@class.outer',
          },
          goto_next_end = {
            [']M'] = '@function.outer',
            [']['] = '@class.outer',
          },
          goto_previous_start = {
            ['[m'] = '@function.outer',
            ['[['] = '@class.outer',
          },
          goto_previous_end = {
            ['[M'] = '@function.outer',
            ['[]'] = '@class.outer',
          },
        },
        swap = {
          swap_next = {
            ['<leader>a'] = '@parameter.inner',
          },
          swap_previous = {
            ['<leader>A'] = '@parameter.inner',
          },
        },
      })

      vim.keymap.set({ 'n', 'x' }, '<c-space>', function()
        if vim.api.nvim_get_mode().mode == 'n' then
          vim.cmd.normal({ 'v', bang = true })
        end
        select_parent()
      end, { desc = 'Treesitter incremental selection' })

      vim.keymap.set('x', '<M-space>', select_child, { desc = 'Treesitter decrement selection' })

      vim.keymap.set({ 'n', 'x' }, '<c-s>', function()
        if vim.api.nvim_get_mode().mode == 'n' then
          vim.cmd.normal({ 'v', bang = true })
        end
        select_scope()
      end, { desc = 'Treesitter scope selection' })
    end,
  }
}
