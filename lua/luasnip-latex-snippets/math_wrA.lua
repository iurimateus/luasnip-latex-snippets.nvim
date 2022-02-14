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

local frac = s({
  priority = 1000,
  trig = ".*%)/",
  wordTrig = true,
  regTrig = true,
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
