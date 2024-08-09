local M = {}

local ls = require("luasnip")

function M.retrieve(is_math)
  return {
    ls.parser.parse_snippet({ trig = "sum", name = "sum" }, "\\sum_{n=${1:1}}^{${2:\\infty}} ${3:a_n z^n}"),
    ls.parser.parse_snippet({ trig = "lim", name = "limit" }, "\\lim_{${1:n} \\to ${2:\\infty}} "),
  }
end

return M
