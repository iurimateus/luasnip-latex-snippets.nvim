local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local f = ls.function_node

local vec_node = {
  f(function(_, snip)
    return string.format("\\vec{%s} ", snip.captures[1])
  end, {}),
  i(0),
}

local math_wrA_no_backslash = {
  s({
    trig = "([%a][%a])(%.,)",
    regTrig = true,
    name = "vector",
  }, vim.deepcopy(vec_node)),
  s({
    trig = "([%a][%a])(,%.)",
    regTrig = true,
    name = "vector",
  }, vim.deepcopy(vec_node)),
  s({
    trig = "([%a])(%.,)",
    regTrig = true,
    name = "vector",
  }, vim.deepcopy(vec_node)),
  s({
    trig = "([%a])(,%.)",
    regTrig = true,
    name = "vector",
  }, vim.deepcopy(vec_node)),
}

return math_wrA_no_backslash
