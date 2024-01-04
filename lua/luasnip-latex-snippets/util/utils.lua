local M = {}

-- local s = ls.snippet
-- local sn = ls.snippet_node
-- local isn = ls.indent_snippet_node
-- local t = ls.text_node
-- local i = ls.insert_node
-- local f = ls.function_node
-- local c = ls.choice_node
-- local d = ls.dynamic_node
-- local events = require("luasnip.util.events")
-- local r = require("luasnip.extras").rep
-- local fmt = require("luasnip.extras.fmt").fmt
-- local fmta = require("luasnip.extras.fmt").fmta

M.pipe = function(fns)
  return function(...)
    for _, fn in ipairs(fns) do
      if not fn(...) then
        return false
      end
    end

    return true
  end
end

M.no_backslash = function(line_to_cursor)
  return not line_to_cursor:find("\\%a+$", -#line_to_cursor)
end

local ts_utils = require("luasnip-latex-snippets.util.ts_utils")
M.is_math = function(opts)
  opts = opts or {}

  local lang = opts.lang

  assert(lang ~= nil and lang ~= "", "lang must be specified: " .. lang)

  if lang == "tex" then
    local use_treesitter = opts.use_treesitter or false
    if use_treesitter then
      return ts_utils.in_mathzone_tex()
    end

    return vim.fn["vimtex#syntax#in_mathzone"]() == 1
  elseif lang == "markdown" then
    return ts_utils.in_mathzone_md()
  else
    assert(true, "file type not support: " .. lang)
  end
end

M.not_math = function(opts)
  opts = opts or {}

  local lang = opts.lang

  assert(lang ~= nil and lang ~= "", "lang must be specified: " .. lang)

  if lang == "tex" then
    local use_treesitter = opts.use_treesitter or false
    if use_treesitter then
      return ts_utils.in_text_tex(true)
    end

    return not M.is_math(opts)
  elseif lang == "markdown" then
    return not ts_utils.in_mathzone_md()
  else
    assert(true, "file type not support: " .. lang)
  end
end

M.comment = function()
  return vim.fn["vimtex#syntax#in_comment"]() == 1
end

M.env = function(name)
  local x, y = unpack(vim.fn["vimtex#env#is_inside"](name))
  return x ~= "0" and y ~= "0"
end

M.with_priority = function(snip, priority)
  snip.priority = priority
  return snip
end

M.with_opts = function(fn, opts)
  return function()
    return fn(opts)
  end
end

return M
