vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("shoe")

vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("shoe-highlight-yank", { clear = true }),
	pattern = "*",
	callback = function()
		(vim.hl or vim.highlight).on_yank()
	end,
})

vim.api.nvim_create_autocmd("BufEnter", {
	group = vim.api.nvim_create_augroup("shoe-tabspaces", { clear = true }),
	pattern = "*.py",
	command = "setlocal tabstop=4 shiftwidth=4 expandtab",
})

for _, pattern in ipairs({ "*.js", "*.ts", "*.lua", "*.tsx", "*.json" }) do
	vim.api.nvim_create_autocmd("BufEnter", {
		group = "shoe-tabspaces",
		pattern = pattern,
		command = "setlocal tabstop=2 shiftwidth=2 expandtab",
	})
end
