-- local fmt = require("luasnip.extras.fmt").fmt
local ls = require("luasnip")

local s = ls.snippet
local f = ls.function_node

-- pip install git+https://github.com/OrangeX4/latex2sympy
-- pip install sympy

local parse_snippet = ls.extend_decorator.apply(ls.parser.parse_snippet, {
  wordTrig = false,
}) --[[@as function]]

-- Adapted from
-- https://www.reddit.com/r/neovim/comments/yfbfvu/sympy_luasnip_vimtex/.compact
return {
  parse_snippet({ trig = "sym", name = "sympy block" }, "sympy $1 sympy"),
  s(
    {
      trig = "sympy.*sympy",
      regTrig = true,
      name = "Sympy block evaluator",
      desc = "",
      docTrig = "",
      priority = 100,
    },
    f(function(_, snip)
      -- Gets the part of the block we actually want, and replaces spaces
      -- at the beginning and at the end
      local to_eval = snip.trigger:gsub("^sympy(.*)sympy", "%1")
      to_eval = to_eval:gsub("^%s+(.*)%s+$", "%1")

      local script = string.format(
        [[
from sympy import *
from sympy.parsing.sympy_parser import parse_expr
from sympy.printing.latex import print_latex
from latex2sympy2 import latex2sympy, latex2latex

x, y, z, t = symbols('x y z t')
k, m, n = symbols('k m n', integer=True)
f, g, h = symbols('f g h', cls=Function)

parsed = parse_expr(str(latex2sympy(r"%s")))
print_latex(parsed)
]],
        to_eval
      )

      -- deindent
      script = script:gsub("^[\t%s]+", "")

      local result
      local Job = require("plenary.job")
      Job:new({
        command = "python",
        args = { "-c", script },
        on_exit = function(j)
          result = j:result()
        end,
      }):sync()

      if not next(result) then
        return to_eval .. ".. could not calculate"
      end

      return to_eval .. "  = " .. table.concat(result, "\t")
    end, {})
  ),
}
