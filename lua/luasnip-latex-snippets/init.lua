local ls = require("luasnip")
local conds = require("luasnip.extras.expand_conditions")

local utils = require("luasnip-latex-snippets.util.utils")
local pipe = utils.pipe
local no_backslash = utils.no_backslash
local is_math = utils.is_math
local not_math = utils.not_math

local M = {}

M.init = function()
  ls.config.setup({ enable_autosnippets = true })

  ls.add_snippets("tex", {
    ls.parser.parse_snippet(
      { trig = "pac", name = "Package" },
      "\\usepackage[${1:options}]{${2:package}}$0"
    ),

    -- ls.parser.parse_snippet({ trig = "nn", name = "Tikz node" }, {
    --   "$0",
    --   -- "\\node[$5] (${1/[^0-9a-zA-Z]//g}${2}) ${3:at (${4:0,0}) }{$${1}$};",
    --   "\\node[$5] (${1}${2}) ${3:at (${4:0,0}) }{$${1}$};",
    -- }),
  })

  for _, snip in ipairs(require("luasnip-latex-snippets/math_i")) do
    snip.condition = pipe({ is_math })
    snip.wordTrig = false
    ls.add_snippets("tex", { snip })
  end

  local autosnippets = {}

  for _, snip in ipairs(require("luasnip-latex-snippets/math_wRA_no_backslash")) do
    snip.regTrig = true
    snip.condition = pipe({ is_math, no_backslash })
    table.insert(autosnippets, snip)
  end

  for _, snip in ipairs(require("luasnip-latex-snippets/math_rA_no_backslash")) do
    snip.wordTrig = false
    snip.regTrig = true
    snip.condition = pipe({ is_math, no_backslash })
    table.insert(autosnippets, snip)
  end

  for _, snip in ipairs(require("luasnip-latex-snippets/normal_wA")) do
    snip.condition = pipe({ not_math })
    table.insert(autosnippets, snip)
  end

  for _, snip in ipairs(require("luasnip-latex-snippets/math_wrA")) do
    snip.regTrig = true
    snip.condition = pipe({ is_math })
    table.insert(autosnippets, snip)
  end

  for _, snip in ipairs(require("luasnip-latex-snippets/math_wA_no_backslash")) do
    snip.condition = pipe({ is_math, no_backslash })
    table.insert(autosnippets, snip)
  end

  for _, snip in ipairs(require("luasnip-latex-snippets/math_iA")) do
    snip.wordTrig = false
    snip.condition = pipe({ is_math, no_backslash })
    table.insert(autosnippets, snip)
  end

  for _, snip in ipairs(require("luasnip-latex-snippets/math_bwA")) do
    snip.condition = pipe({ conds.line_begin, is_math })
    table.insert(autosnippets, snip)
  end

  for _, snip in ipairs(require("luasnip-latex-snippets/bwA")) do
    snip.condition = pipe({ conds.line_begin, not_math })
    table.insert(autosnippets, snip)
  end

  ls.add_snippets("tex", autosnippets, { type = "autosnippets" })

  -- "Basic template": {
  --     "body": [
  --       "\\documentclass[a4paper]{article}",
  --       "",
  --       "\\usepackage[utf8]{inputenc}",
  --       "\\usepackage[T1]{fontenc}",
  --       "\\usepackage{textcomp}",
  --       "\\usepackage[dutch]{babel}",
  --       "\\usepackage{amsmath, amssymb}",
  --       "",
  --       "% figure support",
  --       "\\usepackage{import}",
  --       "\\usepackage{xifthen}",
  --       "\\pdfminorversion=7",
  --       "\\usepackage{pdfpages}",
  --       "\\usepackage{transparent}",
  --       "\\newcommand{\\incfig}[1]{%",
  --       "\t\\def\\svgwidth{\\columnwidth}",
  --       "\t\\import{./figures/}{#1.pdf_tex}",
  --       "}",
  --       "",
  --       "\\pdfsuppresswarningpagegroup=1",
  --       "",
  --       "\\begin{document}",
  --       "\t$0",
  --       "\\end{document}"
  --     ],
  --     "prefix": "template"
  --   },

  -- "Table environment": {
  --     "body": [
  --       "\\begin{table}[${1:htpb}]",
  --       "\t\\centering",
  --       "\t\\caption{${2:caption}}",
  --       "\t\\label{tab:${3:label}}",
  --       "\t\\begin{tabular}{${5:c}}",
  --       "\t$0${5/((?<=.)c|l|r)|./(?1: & )/g}",
  --       "\t\\end{tabular}",
  --       "\\end{table}"
  --     ],
  --     "prefix": "table"
  --   },

  --   "Plot": {
  --     "body": [
  --       "\\begin{figure}[$1]",
  --       "\t\\centering",
  --       "\t\\begin{tikzpicture}",
  --       "\t\t\\begin{axis}[",
  --       "\t\t\txmin= ${2:-10}, xmax= ${3:10},",
  --       "\t\t\tymin= ${4:-10}, ymax = ${5:10},",
  --       "\t\t\taxis lines = middle,",
  --       "\t\t]",
  --       "\t\t\t\\addplot[domain=$2:$3, samples=${6:100}]{$7};",
  --       "\t\t\\end{axis}",
  --       "\t\\end{tikzpicture}",
  --       "\t\\caption{$8}",
  --       "\t\\label{${9:$8}}",
  --       "\\end{figure}"
  --     ],
  --     "prefix": "plot"
  --   },
  --
end

return M
