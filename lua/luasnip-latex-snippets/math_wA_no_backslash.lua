local ls = require("luasnip")
local with_priority = require("luasnip-latex-snippets.util.utils").with_priority

local math_wA_no_backslash = {
  with_priority(ls.parser.parse_snippet({ trig = "arcsin", name = "arcsin" }, "\\arcsin "), 10),
  with_priority(ls.parser.parse_snippet({ trig = "arctan", name = "arctan" }, "\\arctan "), 10),
  with_priority(ls.parser.parse_snippet({ trig = "arcsec", name = "arcsec" }, "\\arcsec "), 10),
  with_priority(ls.parser.parse_snippet({ trig = "asin", name = "asin" }, "\\arcsin "), 10),
  with_priority(ls.parser.parse_snippet({ trig = "atan", name = "atan" }, "\\arctan "), 10),
  with_priority(ls.parser.parse_snippet({ trig = "asec", name = "asec" }, "\\arcsec "), 10),

  ls.parser.parse_snippet({ trig = "set", name = "set" }, [[ \\{$1\\} $0 ]]),
  ls.parser.parse_snippet(
    { trig = "fun", name = "function map" },
    "f \\colon $1 \\R \\to \\R \\colon $0"
  ),

  ls.parser.parse_snippet(
    { trig = "abs", name = "absolute value \\abs{}" },
    "\\abs{${1:${TM_SELECTED_TEXT}}}$0"
  ),
}

return math_wA_no_backslash
