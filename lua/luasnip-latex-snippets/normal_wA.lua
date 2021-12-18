local ls = require("luasnip")

local normal_wA = {
  ls.parser.parse_snippet({ trig = "mk", name = "Math" }, "\\( ${1:${VISUAL}} \\) $0"),
  ls.parser.parse_snippet({ trig = "dm", name = "Block Math" }, "\\[\n\t${1:${VISUAL}}\n.\\] $0"),
  ls.parser.parse_snippet(
    { trig = "enum", name = "Enumerate" },
    "\\begin{enumerate}\n\t\\item $0\n\\end{enumerate}"
  ),
  ls.parser.parse_snippet(
    { trig = "item", name = "Itemize x" },
    "\\begin{itemize}",
    "\t\\item $0",
    "\\end{itemize}"
  ),
}

return normal_wA
