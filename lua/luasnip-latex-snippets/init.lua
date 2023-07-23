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

  ls.config.setup({ enable_autosnippets = true })

  local augroup = vim.api.nvim_create_augroup("luasnip-latex-snippets", {})
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "tex",
    group = augroup,
    once = true,
    callback = function()
      local is_math = utils.with_opts(utils.is_math, opts.use_treesitter)
      local not_math = utils.with_opts(utils.not_math, opts.use_treesitter)
      M.setup_tex(is_math, not_math)
    end,
  })

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    group = augroup,
    once = true,
    callback = function()
      M.setup_markdown()
    end,
  })
end

local _autosnippets = function(is_math, not_math)
  local match_pattern = require("luasnip/nodes/util/trig_engines").pattern()

  local autosnippets = {}

  for _, snip in ipairs(require("luasnip-latex-snippets/math_wRA_no_backslash")) do
    snip.trig_matcher = match_pattern
    snip.condition = pipe({ is_math, no_backslash })
    table.insert(autosnippets, snip)
  end

  for _, snip in ipairs(require("luasnip-latex-snippets/math_rA_no_backslash")) do
    snip.wordTrig = false
    snip.trig_matcher = match_pattern
    snip.condition = pipe({ is_math, no_backslash })
    table.insert(autosnippets, snip)
  end

  for _, snip in ipairs(require("luasnip-latex-snippets/normal_wA")) do
    snip.condition = pipe({ not_math })
    table.insert(autosnippets, snip)
  end

  for _, snip in ipairs(require("luasnip-latex-snippets/math_wrA")) do
    snip.trig_matcher = match_pattern
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

  return autosnippets
end

M.setup_tex = function(is_math, not_math)
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

  ls.add_snippets("tex", _autosnippets(is_math, not_math), {
    type = "autosnippets",
    default_priority = 0,
  })
end

M.setup_markdown = function()
  local is_math = utils.with_opts(utils.is_math, true)
  local not_math = utils.with_opts(utils.not_math, true)

  local autosnippets = _autosnippets(is_math, not_math)
  local trigger_of_snip = function(s)
    return s.trigger
  end

  local normal_wA = vim.tbl_map(trigger_of_snip, require("luasnip-latex-snippets/normal_wA"))
  local bwa = vim.tbl_map(trigger_of_snip, require("luasnip-latex-snippets/bwA"))

  local to_filter = { bwa, normal_wA }

  local filtered = vim.tbl_filter(function(s)
    for _, t in pairs(to_filter) do
      for _, v in pairs(t) do
        if s.trigger == v then
          return false
        end
      end
    end

    return true
  end, autosnippets)

  -- tex delimiters
  local normal_wA_tex = {
    ls.parser.parse_snippet({ trig = "mk", name = "Math" }, "$${1:${TM_SELECTED_TEXT}}$"),
    ls.parser.parse_snippet(
      { trig = "dm", name = "Block Math" },
      "$$\n\t${1:${TM_SELECTED_TEXT}}\n.$$"
    ),
  }

  local not_math = utils.with_opts(utils.not_math, true)
  for _, snip in ipairs(normal_wA_tex) do
    snip.condition = pipe({ not_math })
    table.insert(filtered, snip)
  end

  ls.add_snippets("markdown", filtered, {
    type = "autosnippets",
    default_priority = 0,
  })
end

return M
