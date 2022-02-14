local ls = require("luasnip")

local math_iA = {
  ls.parser.parse_snippet({ trig = "td", name = "to the ... power ^{}" }, "^{$1}$0 "),
  ls.parser.parse_snippet({ trig = "rd", name = "to the ... power ^{()}" }, "^{($1)}$0 "),
  ls.parser.parse_snippet({ trig = "cb", name = "Cube ^3" }, "^3 "),
  ls.parser.parse_snippet({ trig = "sr", name = "Square ^2" }, "^2"),

  ls.parser.parse_snippet({ trig = "EE", name = "exists" }, "\\exists "),
  ls.parser.parse_snippet({ trig = "AA", name = "forall" }, "\\forall "),
  ls.parser.parse_snippet({ trig = "xnn", name = "xn" }, "x_{n}"),
  ls.parser.parse_snippet({ trig = "ynn", name = "yn" }, "y_{n}"),
  ls.parser.parse_snippet({ trig = "xii", name = "xi" }, "x_{i}"),
  ls.parser.parse_snippet({ trig = "yii", name = "yi" }, "y_{i}"),
  ls.parser.parse_snippet({ trig = "xjj", name = "xj" }, "x_{j}"),
  ls.parser.parse_snippet({ trig = "yjj", name = "yj" }, "y_{j}"),
  ls.parser.parse_snippet({ trig = "xp1", name = "x" }, "x_{n+1}"),
  ls.parser.parse_snippet({ trig = "xmm", name = "x" }, "x_{m}"),
  ls.parser.parse_snippet({ trig = "R0+", name = "R0+" }, "\\R_0^+"),

  ls.parser.parse_snippet({ trig = "notin", name = "not in " }, "\\not\\in "),
  ls.parser.parse_snippet({ trig = "cc", name = "subset" }, "\\subset "),
  ls.parser.parse_snippet({ trig = "sq", name = "\\sqrt{}" }, "\\sqrt{${1:${VISUAL}}} $0"),
  ls.parser.parse_snippet({ trig = "<->", name = "leftrightarrow" }, "\\leftrightarrow"),
  ls.parser.parse_snippet({ trig = "...", name = "ldots" }, "\\ldots"),
  ls.parser.parse_snippet({ trig = "!>", name = "mapsto" }, "\\mapsto "),
  ls.parser.parse_snippet({ trig = "iff", name = "iff" }, "\\iff"),
  ls.parser.parse_snippet({ trig = "ooo", name = "\\infty" }, "\\infty"),
  ls.parser.parse_snippet(
    { trig = "rij", name = "mrij" },
    "(${1:x}_${2:n})_{${3:$2}\\in${4:\\N}}$0"
  ),
  ls.parser.parse_snippet({ trig = "nabl", name = "nabla" }, "\\nabla "),
  ls.parser.parse_snippet({ trig = "<!", name = "normal" }, "\\triangleleft "),
  ls.parser.parse_snippet(
    { trig = "floor", name = "floor" },
    "\\left\\lfloor $1 \\right\\rfloor$0"
  ),
  ls.parser.parse_snippet({ trig = "mcal", name = "mathcal" }, "\\mathcal{$1}$0"),
  ls.parser.parse_snippet({ trig = "//", name = "Fraction" }, "\\frac{$1}{$2}$0"),
  ls.parser.parse_snippet({ trig = "\\\\\\", name = "setminus" }, "\\setminus"),
  ls.parser.parse_snippet({ trig = "->", name = "to" }, "\\to "),
  ls.parser.parse_snippet(
    { trig = "letw", name = "let omega" },
    "Let $\\Omega \\subset \\C$ be open."
  ),
  ls.parser.parse_snippet({ trig = "nnn", name = "bigcap" }, "\\bigcap_{${1:i \\in ${2: I}}} $0"),
  ls.parser.parse_snippet({ trig = "norm", name = "norm" }, "\\|$1\\|$0"),
  ls.parser.parse_snippet({ trig = "<>", name = "hokje" }, "\\diamond "),
  ls.parser.parse_snippet({ trig = ">>", name = ">>" }, "\\gg"),
  ls.parser.parse_snippet({ trig = "<<", name = "<<" }, "\\ll"),

  ls.parser.parse_snippet({ trig = "tt", name = "text" }, "\\text{$1}$0"),
  ls.parser.parse_snippet({ trig = "stt", name = "text subscript" }, "_\\text{$1} $0"),
  -- ls.parser.parse_snippet({ trig = "sts", name = "text subscript" }, "_\\text{$1} $0"),

  ls.parser.parse_snippet({ trig = "st", name = "text" }, "\\text{s.t.}"),
  -- ls.parser.parse_snippet({ trig = "tq", name = "text" }, "\\text{tal que}"),

  ls.parser.parse_snippet({ trig = "xx", name = "cross" }, "\\times "),
  ls.parser.parse_snippet({ trig = "**", name = "cdot" }, "\\cdot "),
  ls.parser.parse_snippet({ trig = "SI", name = "SI" }, "\\SI{$1}{$2}"),
  ls.parser.parse_snippet({ trig = "inn", name = "in " }, "\\in "),
  ls.parser.parse_snippet(
    { trig = "cvec", name = "column vector" },
    "\\begin{pmatrix} ${1:x}_${2:1}\\\\ \\vdots\\\\ $1_${2:n} \\end{pmatrix}"
  ),
  ls.parser.parse_snippet({ trig = "bar", name = "bar" }, "\\overline{$1}$0"),
  ls.parser.parse_snippet({ trig = "ceil", name = "ceil" }, "\\left\\lceil $1 \\right\\rceil $0"),
  ls.parser.parse_snippet({ trig = "OO", name = "emptyset" }, "\\O"),
  ls.parser.parse_snippet({ trig = "RR", name = "real" }, "\\R"),
  ls.parser.parse_snippet({ trig = "QQ", name = "Q" }, "\\Q"),
  ls.parser.parse_snippet({ trig = "ZZ", name = "Z" }, "\\Z"),
  ls.parser.parse_snippet({ trig = "UU", name = "cup" }, "\\cup "),
  ls.parser.parse_snippet({ trig = "NN", name = "n" }, "\\N"),
  ls.parser.parse_snippet({ trig = "||", name = "mid" }, " \\mid "),
  ls.parser.parse_snippet({ trig = "Nn", name = "cap" }, "\\cap "),
  ls.parser.parse_snippet(
    { trig = "pmat", name = "pmat" },
    "\\begin{pmatrix} $1 \\end{pmatrix} $0"
  ),
  ls.parser.parse_snippet(
    { trig = "bmat", name = "bmat" },
    "\\begin{bmatrix} $1 \\end{bmatrix} $0"
  ),
  ls.parser.parse_snippet({ trig = "uuu", name = "bigcup" }, "\\bigcup_{${1:i \\in ${2: I}}} $0"),
  ls.parser.parse_snippet({ trig = "DD", name = "D" }, "\\mathbb{D}"),
  ls.parser.parse_snippet({ trig = "HH", name = "H" }, "\\mathbb{H}"),
  ls.parser.parse_snippet({ trig = "lll", name = "l" }, "\\ell"),
  ls.parser.parse_snippet(
    { trig = "dint", name = "integral" },
    "\\int_{${1:-\\infty}}^{${2:\\infty}} ${3:${VISUAL}} $0"
  ),
  ls.parser.parse_snippet({ trig = "==", name = "equals" }, "&= $1 \\\\"),
  ls.parser.parse_snippet({ trig = "!=", name = "equals" }, "\\neq "),
  ls.parser.parse_snippet({ trig = "lim", name = "limit" }, "\\lim_{${1:n} \\to ${2:\\infty}} "),
  ls.parser.parse_snippet({ trig = "compl", name = "complement" }, "^{c}"),
  ls.parser.parse_snippet({ trig = "__", name = "subscript" }, "_{$1}$0"),
  ls.parser.parse_snippet({ trig = "=>", name = "implies" }, "\\implies"),
  ls.parser.parse_snippet({ trig = "=<", name = "implied by" }, "\\impliedby"),
  ls.parser.parse_snippet({ trig = "<<", name = "<<" }, "\\ll"),
  ls.parser.parse_snippet({ trig = "hat", name = "hat" }, "\\hat{$1}$0"),
  ls.parser.parse_snippet({ trig = "<=", name = "leq" }, "\\le "),
  ls.parser.parse_snippet({ trig = ">=", name = "geq" }, "\\ge "),
  ls.parser.parse_snippet({ trig = "invs", name = "inverse" }, "^{-1}"),
  ls.parser.parse_snippet({ trig = "~~", name = "~" }, "\\sim "),
  -- ls.parser.parse_snippet({ trig = "lrb", name = "left\\{ right\\}" }, "\\left\\{ ${1:${VISUAL}} \\right\\} $0"),
  ls.parser.parse_snippet({ trig = "conj", name = "conjugate" }, "\\overline{$1}$0"),

  ls.parser.parse_snippet({ trig = "asin", name = "arcsin" }, "\\arcsin"),
  ls.parser.parse_snippet({ trig = "acos", name = "arccos" }, "\\arccos"),
  ls.parser.parse_snippet({ trig = "atan", name = "arctan" }, "\\arctan"),
  ls.parser.parse_snippet({ trig = "asec", name = "arcsec" }, "\\arcsec"),
  ls.parser.parse_snippet({ trig = "acsc", name = "arccsc" }, "\\arccsc"),
  -- Postfix
  --
  ls.parser.parse_snippet({ trig = "ln", name = "ln postfix" }, "\\ln "),
  ls.parser.parse_snippet({ trig = "log", name = "log postfix" }, "\\log "),
  ls.parser.parse_snippet({ trig = "exp", name = "exp postfix" }, "\\exp "),
  ls.parser.parse_snippet({ trig = "star", name = "star postfix" }, "\\star "),
  ls.parser.parse_snippet({ trig = "perp", name = "perp postfix" }, "\\perp "),
  ls.parser.parse_snippet({ trig = "pm", name = "pm postfix" }, "\\pm "),
  ls.parser.parse_snippet({ trig = "int", name = "int postfix" }, "\\int "),

  ls.parser.parse_snippet({ trig = "qquad", name = "maths whitespace qquad" }, "\\qquad "),
  ls.parser.parse_snippet({ trig = "quad", name = "maths whitespace qquad" }, "\\qquad "),
}

return math_iA
