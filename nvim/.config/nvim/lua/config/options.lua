local opt = vim.opt

-- search settings
opt.smartcase = true
opt.ignorecase = true

-- sync vim clipboard & sys clipboard
opt.clipboard = 'unnamedplus'

opt.number = true
opt.relativenumber = true
opt.wrap = true

opt.splitbelow = true
opt.splitright = true

opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true

opt.termguicolors = true

opt.updatetime = 250
opt.timeout = true
opt.timeoutlen = 300

opt.completeopt = 'menuone,noselect'
opt.undofile = true
