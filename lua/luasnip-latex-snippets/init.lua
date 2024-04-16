local M = {}

local default_opts = {
  use_treesitter = false,
  allow_on_markdown = true,
}

M.setup = function(opts)
  opts = vim.tbl_deep_extend("force", default_opts, opts or {})

  local augroup = vim.api.nvim_create_augroup("luasnip-latex-snippets", {})
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "tex",
    group = augroup,
    once = true,
    callback = function()
      local utils = require("luasnip-latex-snippets.util.utils")
      local is_math = utils.with_opts(utils.is_math, opts.use_treesitter)
      local not_math = utils.with_opts(utils.not_math, opts.use_treesitter)
      M.setup_tex(is_math, not_math)
    end,
  })

  if opts.allow_on_markdown then
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "markdown",
      group = augroup,
      once = true,
      callback = function()
        M.setup_markdown()
      end,
    })
  end
end

local _autosnippets = function(is_math, not_math)
  local autosnippets = {}

  for _, s in ipairs({
    "math_wRA_no_backslash",
    "math_rA_no_backslash",
    "math_wA_no_backslash",
    "math_iA_no_backslash",
    "math_iA",
    "math_wrA",
  }) do
    vim.list_extend(
      autosnippets,
      require(("luasnip-latex-snippets.%s"):format(s)).retrieve(is_math)
    )
  end

  for _, s in ipairs({
    "wA",
    "bwA",
  }) do
    vim.list_extend(
      autosnippets,
      require(("luasnip-latex-snippets.%s"):format(s)).retrieve(not_math)
    )
  end

  return autosnippets
end

M.setup_tex = function(is_math, not_math)
  local ls = require("luasnip")
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

  local math_i = require("luasnip-latex-snippets/math_i").retrieve(is_math)

  ls.add_snippets("tex", math_i, { default_priority = 0 })

  ls.add_snippets("tex", _autosnippets(is_math, not_math), {
    type = "autosnippets",
    default_priority = 0,
  })
end

M.setup_markdown = function()
  local ls = require("luasnip")
  local utils = require("luasnip-latex-snippets.util.utils")
  local pipe = utils.pipe

  local is_math = utils.with_opts(utils.is_math, true)
  local not_math = utils.with_opts(utils.not_math, true)

  local math_i = require("luasnip-latex-snippets/math_i").retrieve(is_math)
  ls.add_snippets("markdown", math_i, { default_priority = 0 })

  local autosnippets = _autosnippets(is_math, not_math)
  local trigger_of_snip = function(s)
    return s.trigger
  end

  local to_filter = {}
  for _, str in ipairs({
    "wA",
    "bwA",
  }) do
    local t = require(("luasnip-latex-snippets.%s"):format(str)).retrieve(not_math)
    vim.list_extend(to_filter, vim.tbl_map(trigger_of_snip, t))
  end

  local filtered = vim.tbl_filter(function(s)
    return not vim.tbl_contains(to_filter, s.trigger)
  end, autosnippets)

  local parse_snippet = ls.extend_decorator.apply(ls.parser.parse_snippet, {
    condition = pipe({ not_math }),
  }) --[[@as function]]

  -- tex delimiters
  local normal_wA_tex = {
    parse_snippet({ trig = "mk", name = "Math" }, "$${1:${TM_SELECTED_TEXT}}$"),
    parse_snippet({ trig = "dm", name = "Block Math" }, "$$\n\t${1:${TM_SELECTED_TEXT}}\n.$$"),
  }
  vim.list_extend(filtered, normal_wA_tex)

  ls.add_snippets("markdown", filtered, {
    type = "autosnippets",
    default_priority = 0,
  })
end

return M
