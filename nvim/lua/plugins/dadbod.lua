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
    vim.g.dbs = {
      wp_docker_dev = 'mysql://wordpress:wordpresspassword@172.20.0.2:3306/wordpress',
      bronkbuilder_prod = 'postgresql://bronkbuilder_user@10.255.100.26:5432/bronkbuilder_db'
    }
  end,
}
