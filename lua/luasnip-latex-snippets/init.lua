local ls = require("luasnip")
local conds = require("luasnip.extras.expand_conditions")

local utils = require("luasnip-latex-snippets.util.utils")
local pipe = utils.pipe
local no_backslash = utils.no_backslash

local M = {}

local default_opts = {
  use_treesitter = false,
}

M.setup = function(opts)
  opts = vim.tbl_deep_extend("force", default_opts, opts or {})

  local is_math = utils.with_opts(utils.is_math, opts.use_treesitter)
  local not_math = utils.with_opts(utils.not_math, opts.use_treesitter)

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

  local math_i = require("luasnip-latex-snippets/math_i")
  for _, snip in ipairs(math_i) do
    snip.condition = pipe({ is_math })
    snip.show_condition = is_math
    snip.wordTrig = false
  end

  ls.add_snippets("tex", math_i, { default_priority = 0 })

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
    snip.condition = pipe({ is_math })
    table.insert(autosnippets, snip)
  end

  for _, snip in ipairs(require("luasnip-latex-snippets/math_iA_no_backslash")) do
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

  ls.add_snippets("tex", autosnippets, {
    type = "autosnippets",
    default_priority = 0,
  })
end

return M
