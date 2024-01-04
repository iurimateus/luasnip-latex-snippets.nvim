local M = {}

local MATH_NODES = {
  displayed_equation = true,
  inline_formula = true,
  math_environment = true,
}

local TEXT_NODES = {
  text_mode = true,
  label_definition = true,
  label_reference = true,
}

function M.get_node_at_cursor(lang)
  local bufnr = vim.api.nvim_get_current_buf()
  local pos = vim.api.nvim_win_get_cursor(0)
  local row, col = pos[1] - 1, pos[2]

  assert(row >= 0 and col >= 0, "Invalid position: row and col must be non-negative")

  local ts_range = { row, col, row, col }

  local root_lang_tree = vim.treesitter.get_parser(bufnr, lang)
  if not root_lang_tree then
    return
  end

  return root_lang_tree:named_node_for_range(ts_range)
end

function M.in_text_tex(check_parent)
  local node = M.get_node_at_cursor("latex")
  while node do
    if node:type() == "text_mode" then
      if check_parent then
        -- For \text{}
        local parent = node:parent()
        if parent and MATH_NODES[parent:type()] then
          return false
        end
      end

      return true
    elseif MATH_NODES[node:type()] then
      return false
    end
    node = node:parent()
  end
  return true
end

function M.in_mathzone_tex()
  local node = M.get_node_at_cursor("latex")
  while node do
    if TEXT_NODES[node:type()] then
      return false
    elseif MATH_NODES[node:type()] then
      return true
    end
    node = node:parent()
  end
  return false
end

function M.in_mathzone_md()
  local node = M.get_node_at_cursor("markdown_inline")
  while node do
    if node:type() == "latex_block" then
      return true
    end
    node = node:parent()
  end
  return false
end

return M
