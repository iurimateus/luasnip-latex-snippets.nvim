local ls = require("luasnip")
local s = ls.snippet
local f = ls.function_node
local i = ls.insert_node
local t = ls.text_node

local frac_no_parens = {
  f(function(_, snip)
    return string.format("\\frac{%s}", snip.captures[1])
  end, {}),
  t("{"),
  i(1),
  t("}"),
  i(0),
}

local frac = s({
  priority = 1000,
  trig = ".*%)/",
  wordTrig = true,
  name = "() frac",
}, {
  f(function(_, snip)
    local match = vim.trim(snip.trigger)

    local stripped = match:sub(1, #match - 1)

    i = #stripped
    local depth = 0
    while true do
      if stripped:sub(i, i) == ")" then
        depth = depth + 1
      end
      if stripped:sub(i, i) == "(" then
        depth = depth - 1
      end
      if depth == 0 then
        break
      end
      i = i - 1
    end

    local rv = string.format(
      "%s\\frac{%s}",
      stripped:sub(1, i - 1),
      stripped:sub(i + 1, #stripped - 1)
    )
    return rv
  end, {}),
  t("{"),
  i(1),
  t("}"),
  i(0),
})

local math_wrA = {
  frac,

  s({
    trig = "([%a])(%d)",
    name = "auto subscript",
  }, {
    f(function(_, snip)
      return string.format("%s_%s", snip.captures[1], snip.captures[2])
    end, {}),
    i(0),
  }),

  s({
    trig = "([%a])_(%d%d)",
    name = "auto subscript 2",
  }, {
    f(function(_, snip)
      return string.format("%s_{%s}", snip.captures[1], snip.captures[2])
    end, {}),
    i(0),
  }),

  s({
    trig = "(\\?[%w]+\\?^%w)/",
    name = "Fraction no ()",
  }, vim.deepcopy(frac_no_parens)),

  s({
    trig = "(\\?[%w]+\\?_%w)/",
    name = "Fraction no ()",
  }, vim.deepcopy(frac_no_parens)),

  s({
    trig = "(\\?[%w]+\\?^{%w*})/",
    name = "Fraction no ()",
  }, vim.deepcopy(frac_no_parens)),

  s({
    trig = "(\\?[%w]+\\?_{%w*})/",
    name = "Fraction no ()",
  }, vim.deepcopy(frac_no_parens)),

  s({
    trig = "(\\?%w+)/",
    name = "Fraction no ()",
  }, vim.deepcopy(frac_no_parens)),
}

return math_wrA
