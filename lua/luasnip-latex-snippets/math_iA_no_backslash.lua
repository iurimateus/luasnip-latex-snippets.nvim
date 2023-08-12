local M = {}

local ls = require("luasnip")

function M.retrieve(is_math)
  local utils = require("luasnip-latex-snippets.util.utils")
  local pipe, no_backslash = utils.pipe, utils.no_backslash

  local parse_snippet = ls.extend_decorator.apply(ls.parser.parse_snippet, {
    wordTrig = false,
    condition = pipe({ is_math, no_backslash }),
  }) --[[@as function]]

  local with_priority = ls.extend_decorator.apply(parse_snippet, {
    priority = 10,
  }) --[[@as function]]

  return {
    parse_snippet({ trig = "sq", name = "\\sqrt{}" }, "\\sqrt{${1:${TM_SELECTED_TEXT}}} $0"),

    with_priority({ trig = "hat", name = "hat" }, "\\hat{$1}$0 "),
    with_priority({ trig = "bar", name = "bar" }, "\\overline{$1}$0 "),

    parse_snippet({ trig = "inf", name = "\\infty" }, "\\infty"),
    parse_snippet({ trig = "inn", name = "in " }, "\\in "),
    parse_snippet({ trig = "SI", name = "SI" }, "\\SI{$1}{$2}"),
  }
end

return M
