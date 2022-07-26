" leader key
let mapleader = " "
" map edit vim rc
nnoremap <leader>rc :edit $MYVIMRC<CR>

" dont have a cleaner solution for this 
" dotnet build 
autocmd FileType cs nnoremap <leader>b :!dotnet build<CR>

call plug#begin()
" Themes 
Plug 'catppuccin/nvim', {'as': 'catppuccin'}
Plug 'ellisonleao/gruvbox.nvim'
Plug 'sainnhe/everforest'
Plug 'folke/tokyonight.nvim'

" Status bar
Plug 'nvim-lualine/lualine.nvim'
" Devicons 
Plug 'kyazdani42/nvim-web-devicons'
Plug 'kyazdani42/nvim-tree.lua'

" Telescope
Plug 'nvim-lua/plenary.nvim'
Plug 'BurntSushi/ripgrep'
Plug 'nvim-telescope/telescope.nvim'

" Native LSP
Plug 'neovim/nvim-lspconfig'
" LSP autocomplete
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
" Debug these later - git err 
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'

" CSharp things LSP cant provide yet (rip)
Plug 'Omnisharp/omnisharp-vim'

" Treesitter (syntax highlight)
Plug 'nvim-treesitter/nvim-treesitter', {'do': 'TSUpdate'}

" Notes 
Plug 'vimwiki/vimwiki'

" Terminal popup
Plug 'akinsho/toggleterm.nvim', {'tag': 'v1.*'}

call plug#end()

" disable omnisharp highlighting
let g:OmniSharp_highlighting = 0

" Set colorscheme
" let g:catppuccin_flavour = "macchiato" " dusk, latte, frappe, macchiato, mochaolorscheme
" colorscheme catppuccin
set background=dark "
augroup user_colors
    autocmd!
    autocmd ColorScheme * highlight Normal ctermbg=NONE guibg=NONE
augroup END

colorscheme tokyonight


" Telescope mappings to find files
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>


" Not sure if thisll work but from Github:
let g:OmniSharp_server_use_mono = 0
let g:OmniSharp_server_path = '/home/jakes/.local/omnisharp/OmniSharp'
" OmniSharp bindings
" go to definition
nnoremap gi <buffer><cmd>OmniSharpGotoImplementation<CR>
autocmd FileType cs nmap <silent> gd :OmniSharpGotoDefinition<CR>

" LSP CONFIG
lua << EOF

-- devicons 
require('nvim-web-devicons').setup()
require'nvim-web-devicons'.get_icons()
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    adaptive_size = true,
    side = left,
    mappings = {
      list = {
        { key = "u", action = "dir_up" },
      },
    },
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})
vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<cr>", { noremap = true })

-- quick and dirty - clean up!!
-- plugin and using highlight groups
local gruvbox = {
    fg = '#928374',
    bg = '#1F2223',
    black ='#1B1B1B',
    skyblue = '#458588',
    cyan = '#83a597',
    green = '#689d6a',
    oceanblue = '#1d2021',
    magenta = '#fb4934',
    orange = '#fabd2f',
    red = '#cc241d',
    violet = '#b16286',
    white = '#ebdbb2',
    yellow = '#d79921',
}
require('lualine').setup{
    options = { theme = 'tokyonight' }
}


-- autocomplte capabilities to pass into lsp-config
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

-- TYPESCRIPT
require'lspconfig'.tsserver.setup{
  capabilities = capabilities,
  on_attach = function()
  -- show hover insights
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, {buffer=0}) 
  -- go to definition ( CTRL-T to go back to original spot ) ( CTRL-O back a jump )
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {buffer=0})
  -- go to type definition 
  vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, {buffer=0})
  -- go to type implementation
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {buffer=0})
  -- diagnostics next & previous & list
  vim.keymap.set('n', '<leader>dj', vim.diagnostic.goto_next, {buffer=0})
  vim.keymap.set('n', '<leader>dk', vim.diagnostic.goto_prev, {buffer=0})
  vim.keymap.set('n', '<leader>dl', '<cmd>Telescope diagnostics<cr>', {buffer=0})
  -- rename a variable (LSP fixes it for you)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, {buffer=0})
  -- code actions under cursor
  vim.keymap.set('n', '<leader>c', vim.lsp.buf.code_action, {buffer=0})
  end,
}

-- LSP Settings
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<leader>c', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<leader>fm', vim.lsp.buf.formatting, bufopts)
  vim.keymap.set('n', '<leader>dj', vim.diagnostic.goto_next, bufopts)
  vim.keymap.set('n', '<leader>dk', vim.diagnostic.goto_prev, bufopts)
  vim.keymap.set('n', '<leader>dl', '<cmd>Telescope diagnostics<cr>', bufopts) 
  vim.keymap.set('n', '<leader>cb', '<cmd>%Telescope lsp_range_code_actions<cr>', bufopts)
end

require('lspconfig')['rust_analyzer'].setup {
    on_attach = on_attach,
    settings = {
        ["rust-analyzer"] = {
            assist = {
                importGranularity = "module",
                importPrefix = "self",
            },
            cargo = {
                loadOutDirsFromCheck = true
            },
            procMacro = {
                enable = true
            },
        }
    },
}
-- C#
local util = require('lspconfig').util
local pid = vim.fn.getpid()
local omnisharp_bin = '/home/jakes/.local/omnisharp/OmniSharp'
require'lspconfig'.omnisharp.setup{
  capabilities = capabilities,
  on_attach = function()
  -- hover diagnostics
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, {buffer=0}) 
  -- unfortunately LSP def / implementation doesnt work with those (waiting for fix)
  -- in the mean time , using Omnisharp-vim
  -- go to definition
  -- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {buffer=0})
  -- go to type definition
  -- vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, {buffer=0})
  -- go to type implementation
  -- vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {buffer=0})
  -- diagnostics
  vim.keymap.set('n', '<leader>dj', vim.diagnostic.goto_next, {buffer=0})
  vim.keymap.set('n', '<leader>dk', vim.diagnostic.goto_prev, {buffer=0})
  vim.keymap.set('n', '<leader>dl', '<cmd>Telescope diagnostics<cr>', {buffer=0})
  -- rename a variable (LSP fixes it for you)
  vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, {buffer=0})
  -- find usings
  vim.keymap.set('n', '<leader>fu', '<cmd>Telescope lsp_references<cr>')
  -- code actions under cursor
  vim.keymap.set('n', '<leader>c', vim.lsp.buf.code_action, {buffer=0})
  -- code actions for the buffer
  vim.keymap.set('n', '<leader>cb', '<cmd>%Telescope lsp_range_code_actions<cr>')
  end,
  cmd = { omnisharp_bin, "--languageserver", "--hostPID", tostring(pid) },
  root_dir = util.root_pattern('*.sln'), 
}



-- Treesitter syntax highlighting
require'nvim-treesitter.configs'.setup {
    ensure_installed = {"c_sharp", "javascript", "rust"},
    sync_install = false,
    ignore_install = { "javascript" },
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
}


-- LSP Autocompletion
vim.opt.completeopt={'menu', 'menuone', 'noselect'}

-- setup nvim-cmp
local cmp = require'cmp'

cmp.setup({
snippet = {
  -- REQUIRED - you must specify a snippet engine
  expand = function(args)
    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
  end,
},
window = {
  completion = cmp.config.window.bordered(),
  documentation = cmp.config.window.bordered(),
},
mapping = cmp.mapping.preset.insert({
  ['<C-b>'] = cmp.mapping.scroll_docs(-4),
  ['<C-f>'] = cmp.mapping.scroll_docs(4),
  ['<C-Space>'] = cmp.mapping.complete(),
  ['<C-e>'] = cmp.mapping.abort(),
  ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  ['<Tab>'] = cmp.mapping.select_next_item(),
  ['<S-Tab>'] = cmp.mapping.select_prev_item()
}),
sources = cmp.config.sources({
  { name = 'nvim_lsp' },
  { name = 'luasnip' }, -- For luasnip users.
}, {
  { name = 'buffer' },
})
})

-- toggle term
require('toggleterm').setup{}
vim.keymap.set('n', '<leader>sh', ':ToggleTerm<cr>',{ noremap=true, silent=true, buffer=bufnr })
vim.keymap.set('t', '<esc>', [[<C-\><C-n>]],{ noremap=true, silent=true, buffer=bufnr })
EOF

" SETS
set nocompatible            " disable compatibility to old-time vi 
set showmatch               " show matching 
set ignorecase              " case insensitive 
set mouse=v                 " middle-click paste with 
set hlsearch                " highlight search 
set incsearch               " incremental search
set tabstop=4               " number of columns occupied by a tab 
set softtabstop=4           " see multiple spaces as tabstops so <BS> does the right thing
set expandtab               " converts tabs to white space
set shiftwidth=4            " width for autoindents
set autoindent              " indent a new line the same amount as the line just typed
set number                  " add line numbers
set wildmode=longest,list   " get bash-like tab completions
set cc=80                   " set an 80 column border for good coding style
filetype plugin indent on   "allow auto-indenting depending on file type
syntax on                   " syntax highlighting
set mouse=a                 " enable mouse click
set clipboard=unnamedplus   " using system clipboard
filetype plugin on
set cursorline              " highlight current cursorline
set ttyfast                 " Speed up scrolling in Vim
set noswapfile              " disable creating swap file
set nohlsearch              " no highlight search
set hidden                  " keep buffers open
set noerrorbells            " no noises
set nowrap                  " dont wrap text
set noswapfile              " no swap file
set nobackup                " let a plugin deal with backup
set undodir=~/.vim/undodir  " set undodir
set undofile                " undo file
set scrolloff=8             " scroll starts before i reach bottom
set signcolumn=yes          " column to display errs
