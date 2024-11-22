# luasnip-latex-snippets

A port of [Gilles Castel's](https://github.com/gillescastel/latex-snippets)
snippets for the [LuaSnip Engine](https://github.com/L3MON4D3/LuaSnip).

## Why?

UltiSnips felt unbearably slow. See
<https://github.com/neovim/neovim/issues/7063> and
<https://github.com/SirVer/ultisnips/issues?q=label%3A%22neovim+only%22+is%3Aclosed>.

## Installation

Depends on [vimtex](https://github.com/lervag/vimtex) to determine if the
cursor is within math mode. Alternatively, you can use
[nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) (experimental) by passing `{ use_treesitter = true }` to the setup call.

It's necessary to enable `autosnippets` in luasnip: `require("luasnip").config.setup { enable_autosnippets = true }`.

Can be installed like any neovim plugin. If using
[wbthomason/packer.nvim](https://github.com/wbthomason/packer.nvim):

```lua
use {
  "iurimateus/luasnip-latex-snippets.nvim",
  -- vimtex isn't required if using treesitter
  requires = { "L3MON4D3/LuaSnip", "lervag/vimtex" },
  config = function()
    require'luasnip-latex-snippets'.setup()
    -- or setup({ use_treesitter = true })
    require("luasnip").config.setup { enable_autosnippets = true }
  end,
}
```

## Configuration

```
{
  use_treesitter = false, -- whether to use treesitter to determine if cursor is in math mode; if false, vimtex is used
  allow_on_markdown = true, -- whether to add snippets to markdown filetype
}
```

## Misc

The following convention, from
[SirVer/ultisnips](https://github.com/SirVer/ultisnips), is used for naming lua
tables and respective files:

```
A: Automatic snippet expansion - snippets will activate as soon as their trigger
matches.

w: Word boundary - With this option the snippet trigger will match when the
trigger is a word boundary character. This is the default behavior.

b: Beginning of line expansion - A snippet with this option is expanded only if
the trigger is the first word on the line (i.e., only whitespace precedes the
trigger).
```

Note that the _regex_ term used in LuaSnip is misleading: it is not a POSIX
regexp. What's actually being used is Lua pattern matching, which has some
limitations. In particular, it lacks positive lookbehind and alternation `|`.
The first which is used in postfix completions (e.g. match `delta`, but not
`\delta`) and can be handled with simple functions. The second was solved by
splitting and/or partially rewriting the expressions.

### Adding your own snippets / overrides

See discussion https://github.com/iurimateus/luasnip-latex-snippets.nvim/discussions/3#discussioncomment-11348745

```lua
local ls = require("luasnip")
local utils = require("luasnip-latex-snippets.util.utils")
local not_math = utils.not_math() -- pass true if using Treesitter

-- set a higher priority (defaults to 0 for most snippets)
local snip = ls.parser.parse_snippet(
  { trig = "mk", name = "Math", condition = not_math, priority = 10 },
  "$ ${1:${TM_SELECTED_TEXT}} $$0"
)

ls.add_snippets("tex", { snip }, {
  type = "autosnippets",
})
```

## Roadmap

- [ ] Tests
