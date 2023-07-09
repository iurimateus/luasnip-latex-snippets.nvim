local M = {}

local ts = require("vim.treesitter")

local MATH_NODES = {
  displayed_equation = true,
  inline_formula = true,
  math_environment = true,
}

local function get_node_at_cursor()
  local buf = vim.api.nvim_get_current_buf()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  row = row - 1
  col = col - 1

  local parser = ts.get_parser(buf, "latex")
  if not parser then
    return
  end
  local root_tree = parser:parse()[1]
  local root = root_tree and root_tree:root()

  if not root then
    return
  end

  return root:named_descendant_for_range(row, col, row, col)
end

function M.in_text(check_parent)
  local node = get_node_at_cursor()
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

local function check_in_mathzone()
  local node = get_node_at_cursor()
  while node do
    if node:type() == "text_mode" then
      return false
    elseif MATH_NODES[node:type()] then
      return true
    end
    node = node:parent()
  end
  return false
end

vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"},
  {pattern = {"*.md"},
  callback = function()
    if not vim.b.tracking_math then
      vim.api.nvim_buf_attach(0, false, {on_lines = function(...)
        vim.b.in_mathzone = check_in_mathzone()
      end})
    vim.b.in_mathzone = false
    vim.b.tracking_math = true
    end
  end
  })

function M.in_mathzone()
  return vim.b.in_mathzone
end

return M
