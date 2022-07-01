" leader key
let mapleader = " "
" map edit vim rc
nnoremap <leader>rc :edit C:\\Users\\jshoemaker\\AppData\\Local\\nvim\\init.vim<CR>

call plug#begin()
" Time to get gruv-ey
Plug 'ellisonleao/gruvbox.nvim'
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
Plug 'arcticicestudio/nord-vim'

" Status bar
Plug 'nvim-lualine/lualine.nvim'
" Devicons 
Plug 'kyazdani42/nvim-web-devicons'

" Telescope
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-file-browser.nvim'
" Plug 'BurnSushi/ripgrep' -> install w/ scoop

" file explorer
" Plug 'preservim/nerdtree'
Plug 'kyazdani42/nvim-tree.lua'

" Omnisharp -> really only using this for certain things (until LSP fixes
" metadata errs)
Plug 'Omnisharp/omnisharp-vim'

" Native LSP
Plug 'neovim/nvim-lspconfig'
" LSP autocomplete
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'

" Treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': 'TSUpdate'}

" Toggle Terminal
Plug 'akinsho/toggleterm.nvim', {'tag' : 'v1.*'}

" Wiki (notes, ideas, etc)
Plug 'vimwiki/vimwiki'

call plug#end()

colorscheme gruvbox

" Remaps

" Telescope
" TODO: id love to trim the file path shown - maybe shorten it a little
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>


autocmd FileType cs nnoremap <leader>b :!dotnet build<cr>
" Omnisharp
let g:OmniSharp_server_path=$HOME . '\.omnisharp\OmniSharp.exe'
let g:OmniSharp_server_stdio = 1
let g:OmniSharp_loglevel = 'debug'
let g:OmniSharp_highlighting = 0
" go to implementation / definition
" nnoremap gi <buffer><cmd>OmniSharpGotoImplementation<cr>
autocmd FileType cs nnoremap gd :OmniSharpGotoDefinition<cr>
autocmd FileType cs nnoremap pd :OmniSharpPreviewDefinition<cr>
autocmd FileType cs nnoremap pi :OmniSharpPreviewImplementation<cr>
"autocmd FileType cs nnoremap <leader>

" Setups
lua << EOF

-- treesitter
require('nvim-treesitter.install').compilers = { "gcc" }
require('nvim-treesitter.configs').setup {
    ensure_installed = { "c_sharp", "lua", "javascript" },
    sync_install = false,
    ignore_install = { "javascript" },
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
}

-- devicons 
require('nvim-web-devicons').setup()
require('lualine').setup{ options = { theme = 'auto' }}

-- autocomplte capabilities to pass into lsp-config
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

-- C#
local util = require('lspconfig').util
local pid = vim.fn.getpid()
local bin = 'C:\\Users\\jshoemaker\\.omnisharp\\OmniSharp.exe'
require('lspconfig').omnisharp.setup {
    capabilities = capabilities,
    on_attach = function()
      -- go to definition
    -- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {buffer=0}) --> broke rn, waiting for metadata error to stop
    -- go to type definition
    vim.keymap.set('n', 'gD', vim.lsp.buf.type_definition, {buffer=0})
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, {buffer=0})
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {buffer=0})
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
    cmd = { bin, "--languageserver", "--hostPID", tostring(pid) },
    root_dir = util.root_pattern('*.sln'),
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
  -- completion = cmp.config.window.bordered(),
  -- documentation = cmp.config.window.bordered(),
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

require('telescope').setup {}
require('telescope').load_extension "file_browser"

vim.api.nvim_set_keymap("n", "<leader>fb", ":Telescope file_browser", { noremap = true })

-- file explorer
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    adaptive_size = true,
    side = "right",
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
vim.api.nvim_set_keymap("n", "<C-n>", ":NvimTreeToggle <cr>", { noremap = true })

-- terminal toggle setup
require("toggleterm").setup {}
vim.api.nvim_set_keymap('n', '<leader>sh', ':ToggleTerm<cr>', { noremap = true })
vim.api.nvim_set_keymap('t', '<esc>', [[<C-\><C-n>]], { noremap = true })
vim.api.nvim_set_keymap('t', 'jk', [[<C-\><C-n>]], { noremap = true })
vim.api.nvim_set_keymap('t', '<C-h>', [[<C-\><C-n><C-W>h]], { noremap = true })
vim.api.nvim_set_keymap('t', '<C-j>', [[<C-\><C-n><C-W>j]], { noremap = true })
vim.api.nvim_set_keymap('t', '<C-k>', [[<C-\><C-n><C-W>k]], { noremap = true })
vim.api.nvim_set_keymap('t', '<C-l>', [[<C-\><C-n><C-W>l]], { noremap = true })


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
