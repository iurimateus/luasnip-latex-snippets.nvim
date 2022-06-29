local ls = require("luasnip")
local with_priority = require("luasnip-latex-snippets.util.utils").with_priority

local math_iA_no_backslash = {
  ls.parser.parse_snippet(
    { trig = "sq", name = "\\sqrt{}" },
    "\\sqrt{${1:${TM_SELECTED_TEXT}}} $0"
  ),

  with_priority(ls.parser.parse_snippet({ trig = "hat", name = "hat" }, "\\hat{$1}$0 "), 10),
  with_priority(ls.parser.parse_snippet({ trig = "bar", name = "bar" }, "\\overline{$1}$0 "), 10),

  ls.parser.parse_snippet({ trig = "inf", name = "\\infty" }, "\\infty"),
  ls.parser.parse_snippet({ trig = "inn", name = "in " }, "\\in "),
  ls.parser.parse_snippet({ trig = "SI", name = "SI" }, "\\SI{$1}{$2}"),
}

return math_iA_no_backslash
