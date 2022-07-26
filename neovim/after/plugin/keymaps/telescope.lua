local map = require("jshoe.helpers.keymap")
local nnoremap = map.nnoremap

nnoremap("<C-p>", ":Telescope")

-- find words
nnoremap("<leader>fw", function()
    require('telescope.builtin').grep_string({ search = vim.fn.input("Grep for > ")})
end)

-- find files
nnoremap("<leader>ff", function()
    require('telescope.builtin').find_files()
end)

-- git status
nnoremap("<leader>gs", function()
    require('telescope.builtin').git_status()
end)

-- git files
nnoremap("<leader>fg", function()
    require('telescope.builtin').git_files()
end)
