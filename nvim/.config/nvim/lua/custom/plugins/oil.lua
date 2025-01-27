local git_ignored = setmetatable({}, {
  __index = function(self, key)
    local proc = vim.system(
      { "git", "ls-files", "--ignored", "--exclude-standard", "--others", "--directory" },
      {
        cwd = key,
        text = true,
      }
    )
    local result = proc:wait()
    local ret = {}
    if result.code == 0 then
      for line in vim.gsplit(result.stdout, "\n", { plain = true, trimempty = true }) do
        -- Remove trailing slash
        line = line:gsub("/$", "")
        table.insert(ret, line)
      end
    end

    rawset(self, key, ret)
    return ret
  end,
})

local detail = false
return {
  {
    'stevearc/oil.nvim',
    dependencies = { { 'echasnovski/mini.icons', opts = {} } },
    lazy = false,
    priority = 1001,
    config = function()
      require('oil').setup({
        default_file_explorer = true,
        columns = {
          "icon",
        },
        skip_confirm_for_simple_edits = true,
        use_default_keymaps = true,
        view_options = {
          show_hidden = true,
          is_hidden_file = function(name, _)
            if vim.startswith(name, ".") then
              return true
            end
            local dir = require("oil").get_current_dir()
            if not dir then
              return false
            end

            return vim.list_contains(git_ignored[dir], name)
          end,
          natural_order = true,
        },
        preview = {
          max_width = 0.9,
          min_width = { 40, 0.4 },
          width = nil,
          max_height = 0.9,
          min_height = { 5, 0.1 },
          height = nil,
          border = "rounded",
          win_options = {
            winblend = 0,
          },
          update_on_cursor_moved = true,
        },
        keymaps = {
          ["gd"] = {
            desc = "Toggle file detail view",
            callback = function()
              detail = not detail
              if detail then
                require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
              else
                require("oil").set_columns({ "icon" })
              end
            end,
          },
        },
      })
      vim.keymap.set('n', '<leader>ef', ':Oil<CR>', { desc = 'Explore files using Oil.nvim' })
    end,
  }
}
