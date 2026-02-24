return {
  { 'tpope/vim-dadbod' },
  'kristijanhusak/vim-dadbod-ui',
  dependencies = {
    { 'tpope/vim-dadbod',                     lazy = true },                                   -- Required
    { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true }, -- Optional
  },
  cmd = {
    'DBUI',
    'DBUIToggle',
    'DBUIAddConnection',
    'DBUIFindBuffer',
  },
  init = function()
    vim.g.db_ui_use_nerd_fonts = 1

    -- Build connection list from environment variables.
    -- Set these in ~/.env.local (or direnv .envrc) on each machine:
    --   export DB_WP_DOCKER="mysql://wordpress:wordpresspassword@172.20.0.2:3306/wordpress"
    --   export DB_BRONKBUILDER_PROD="postgresql://bronkbuilder_user@10.255.100.26:5432/bronkbuilder_db"
    local dbs = {}
    local env_map = {
      wp_docker_dev      = "DB_WP_DOCKER",
      bronkbuilder_prod  = "DB_BRONKBUILDER_PROD",
    }
    for name, env_var in pairs(env_map) do
      local url = vim.env[env_var]
      if url and url ~= "" then
        dbs[name] = url
      end
    end
    vim.g.dbs = dbs
  end,
}
