local ls = require("luasnip")

local normal_wA = {
  ls.parser.parse_snippet({ trig = "mk", name = "Math" }, "\\( ${1:${VISUAL}} \\) $0"),
  ls.parser.parse_snippet({ trig = "dm", name = "Block Math" }, "\\[\n\t${1:${VISUAL}}\n.\\] $0"),
}

return normal_wA
