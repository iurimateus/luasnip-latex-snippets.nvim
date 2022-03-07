local ls = require("luasnip")
local s = ls.snippet
local f = ls.function_node

local math_rA_no_backslash = {}

-- "([aA]lpha|[bB]eta|[gG]amma|[dD]elta|[eE]psilon|[zZ]eta|[tT]heta|[iI]ota|[kK]appa|[lL]ambda|[mM]u|[nN]u|[pP]i|[rR]ho|sigma|[tT]au|[pP]hi|[cC]hi|[pP]si|[oO]mega)"
local greek_postfix_completions = function()
  local greek_node = {
    f(function(_, snip)
      return string.format("\\%s ", snip.captures[1])
    end, {}),
  }

  local build_snippet = function(match)
    return s({
      trig = string.format("(%s)", match),
    }, vim.deepcopy(greek_node))
  end

  local re =
    "[aA]lpha|[bB]eta|[gG]amma|[dD]elta|[eE]psilon|[zZ]eta|[tT]heta|[iI]ota|[kK]appa|[lL]ambda|[mM]u|[nN]u|[pP]i|[rR]ho|sigma|[tT]au|[pP]hi|[cC]hi|[pP]si|[oO]mega"

  return vim.tbl_map(build_snippet, vim.split(re, "|"))
end

vim.list_extend(math_rA_no_backslash, greek_postfix_completions())

return math_rA_no_backslash
