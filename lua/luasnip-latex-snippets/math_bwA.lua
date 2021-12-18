local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

local math_bwA = {
  s({
    priority = 1000,
    trig = ".*%)/",
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

      local rv = stripped:sub(1, i - 1) .. "\\frac{" .. stripped:sub(i + 1, #stripped - 1) .. "}"
      return rv
    end, {}),
    t("{"),
    i(1),
    t("}"),
    i(0),
  }),
}

return math_bwA
