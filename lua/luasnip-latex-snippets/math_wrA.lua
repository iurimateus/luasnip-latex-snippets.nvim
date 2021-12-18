local ls = require("luasnip")
local s = ls.snippet
local f = ls.function_node
local i = ls.insert_node
local t = ls.text_node

local frac_no_parens = {
  f(function(_, snip)
    return "\\frac{" .. snip.captures[1] .. "}"
  end, {}),
  t("{"),
  i(1),
  t("}"),
  i(0),
}

local math_wrA = {
  s({
    trig = "([%a])(%d)",
    regTrig = true,
    name = "auto subscript",
  }, {
    f(function(_, snip)
      return snip.captures[1] .. "_" .. snip.captures[2]
    end, {}),
    i(0),
  }),

  s({
    trig = "([%a])_(%d%d)",
    regTrig = true,
    name = "auto subscript 2",
  }, {
    f(function(_, snip)
      return snip.captures[1] .. "_" .. "{" .. snip.captures[2] .. "}"
    end, {}),
    i(0),
  }),

  s({
    trig = "([%w]+\\?^%w)/",
    regTrig = true,
    name = "Fraction no ()",
  }, vim.deepcopy(frac_no_parens)),

  s({
    trig = "([%w]+\\?_%w)/",
    regTrig = true,
    name = "Fraction no ()",
  }, vim.deepcopy(frac_no_parens)),

  s({
    trig = "([%w]+\\?^{%w*})/",
    regTrig = true,
    name = "Fraction no ()",
  }, vim.deepcopy(frac_no_parens)),

  s({
    trig = "([%w]+\\?_{%w*})/",
    regTrig = true,
    name = "Fraction no ()",
  }, vim.deepcopy(frac_no_parens)),

  s({
    trig = "(%d+)/",
    regTrig = true,
    name = "Fraction no ()",
  }, vim.deepcopy(frac_no_parens)),
  s(
    {
      trig = "(%a)bar",
      wordTrig = false,
      regTrig = true,
      name = "bar",
    },
    f(function(_, snip)
      return "\\overline{" .. snip.captures[1] .. "} "
    end, {})
  ),
  s(
    {
      trig = "(%a)hat",
      wordTrig = false,
      regTrig = true,
      name = "hat",
    },
    f(function(_, snip)
      return "\\hat{" .. snip.captures[1] .. "} "
    end, {})
  ),
}

return math_wrA
