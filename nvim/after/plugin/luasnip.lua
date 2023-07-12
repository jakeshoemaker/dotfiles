local ls = require "luasnip"
local t = ls.text_node

-- hello world type snippet lolz
ls.add_snippets("all", {
  ls.snippet("simple", t "wow that was really simple"),
})
