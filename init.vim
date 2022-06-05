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

" leader key
let mapleader = " "

call plug#begin()
" Themes 
Plug 'catppuccin/nvim', {'as': 'catppuccin'}

" Telescope
Plug 'nvim-lua/plenary.nvim'
Plug 'BurntSushi/ripgrep'
Plug 'nvim-telescope/telescope.nvim'

" NerdTree (FileNav)
Plug 'preservim/nerdtree'

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

call plug#end()


" Set colorscheme
let g:catppuccin_flavour = "dusk" " latte, frappe, macchiato, mocha
colorscheme catppuccin
" highlight Normal guibg=none

" Telescope mappings to find files
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" Toggles for file explorer
nnoremap <C-n> :NERDTreeToggle<cr>
" Start NERDTree and put the cursor back in the other window.
" autocmd VimEnter * NERDTree | wincmd p

" LSP CONFIG
lua << EOF
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
  vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, {buffer=0})
  -- code actions
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {buffer=0})
  end,
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
}),
sources = cmp.config.sources({
  { name = 'nvim_lsp' },
  { name = 'luasnip' }, -- For luasnip users.
}, {
  { name = 'buffer' },
})
})

EOF
