local ls = require("luasnip")

local math_wA_no_backslash = {
  ls.parser.parse_snippet({ trig = "arcsin", name = "arcsin" }, "\\arcsin "),
  ls.parser.parse_snippet({ trig = "arctan", name = "arctan" }, "\\arctan "),
  ls.parser.parse_snippet({ trig = "arcsec", name = "arcsec" }, "\\arcsec "),

  ls.parser.parse_snippet({ trig = "set", name = "set" }, "\\{$1\\} $0"),
  ls.parser.parse_snippet({ trig = "fun", name = "function map" }, "f : $1 \\R \\to \\R : $0"),
}

return math_wA_no_backslash
