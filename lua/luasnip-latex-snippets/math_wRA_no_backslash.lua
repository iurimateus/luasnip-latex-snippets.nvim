local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local f = ls.function_node

local fn = {
  f(function(_, snip)
    return "\\" .. snip.captures[1] .. " "
  end, {}),
}

-- "([aA]lpha|[bB]eta|[gG]amma|[dD]elta|[eE]psilon|[zZ]eta|[tT]heta|[iI]ota|[kK]appa|[lL]ambda|[mM]u|[nN]u|[pP]i|[rR]ho|sigma|[tT]au|[pP]hi|[cC]hi|[pP]si|[oO]mega)",
local greek_postfix_completions = {
  s({
    trig = "([aA]lpha)",
    regTrig = true,
  }, vim.deepcopy(fn)),
  s({
    trig = "([bB]eta)",
    regTrig = true,
  }, vim.deepcopy(fn)),
  s({
    trig = "([gG]amma)",
    regTrig = true,
  }, vim.deepcopy(fn)),
  s({
    trig = "([dD]elta)",
    regTrig = true,
  }, vim.deepcopy(fn)),
  s({
    trig = "([eE]psilon)",
    regTrig = true,
  }, vim.deepcopy(fn)),
  s({
    trig = "([zZ]eta)",
    regTrig = true,
  }, vim.deepcopy(fn)),
  s({
    trig = "([tT]heta)",
    regTrig = true,
  }, vim.deepcopy(fn)),
  s({
    trig = "([iI]ota)",
    regTrig = true,
  }, vim.deepcopy(fn)),
  s({
    trig = "([kK]appa)",
    regTrig = true,
  }, vim.deepcopy(fn)),
  s({
    trig = "([lL]ambda)",
    regTrig = true,
  }, vim.deepcopy(fn)),
  s({
    trig = "([mM]u)",
    regTrig = true,
  }, vim.deepcopy(fn)),
  s({
    trig = "([nN]u)",
    regTrig = true,
  }, vim.deepcopy(fn)),
  s({
    trig = "([pP]i)",
    regTrig = true,
  }, vim.deepcopy(fn)),
  s({
    trig = "([rR]ho)",
    regTrig = true,
  }, vim.deepcopy(fn)),
  s({
    trig = "([sS]igma)",
    regTrig = true,
  }, vim.deepcopy(fn)),
  s({
    trig = "([tT]au)",
    regTrig = true,
  }, vim.deepcopy(fn)),
  s({
    trig = "([pP]hi)",
    regTrig = true,
  }, vim.deepcopy(fn)),
  s({
    trig = "([cC]hi)",
    regTrig = true,
  }, vim.deepcopy(fn)),
  s({
    trig = "([pP]si)",
    regTrig = true,
  }, vim.deepcopy(fn)),
  s({
    trig = "([oO]mega)",
    regTrig = true,
  }, vim.deepcopy(fn)),
}

local math_wRA_no_backslash = {
  s({
    trig = "([%a][%a])(%.,)",
    regTrig = true,
    name = "vector",
  }, {
    f(function(_, snip)
      return "\\vec{" .. snip.captures[1] .. "}"
    end, {}),
    i(0),
  }),
  s({
    trig = "([%a][%a])(,%.)",
    regTrig = true,
    name = "vector",
  }, {
    f(function(_, snip)
      return "\\vec{" .. snip.captures[1] .. "}"
    end, {}),
    i(0),
  }),
  s({
    trig = "([%a])(%.,)",
    regTrig = true,
    name = "vector",
  }, {
    f(function(_, snip)
      return "\\vec{" .. snip.captures[1] .. "}"
    end, {}),
    i(0),
  }),
  s({
    trig = "([%a])(,%.)",
    regTrig = true,
    name = "vector",
  }, {
    f(function(_, snip)
      return "\\vec{" .. snip.captures[1] .. "}"
    end, {}),
    i(0),
  }),
}

for _, snip in ipairs(greek_postfix_completions) do
  table.insert(math_wRA_no_backslash, snip)
end

return math_wRA_no_backslash
