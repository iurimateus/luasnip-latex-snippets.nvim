local M = { polling = {} }

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

local function get_node_at_cursor()
  local pos = vim.api.nvim_win_get_cursor(0)
  -- Subtract one to account for 1-based row indexing in nvim_win_get_cursor
  local row, col = pos[1] - 1, pos[2]

  local parser = vim.treesitter.get_parser(0, "latex")
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

function M.in_mathzone()
  local node = get_node_at_cursor()
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

--- @alias node_stack string[]
--- @class tracked_buffer
--- @field timer uv_timer_t
--- @field parser LanguageTree
--- @field tree TSTree
--- @field node_stack node_stack
--- @field in_math boolean
--- @field in_text boolean
--- @type table<buffer, tracked_buffer>
local tracked_bufs = {}

local function get_node()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  row = row - 1
  col = col - 1
  local buf = vim.api.nvim_get_current_buf()
  local root_node = tracked_bufs[buf].tree:root()
  return root_node:named_descendant_for_range(row, col, row, col)
end

--- @return node_stack ns A list of types of nodes. The first element is the type of deepest node.
local function get_node_stack()
  local node = get_node()
  local stack = {}
  while node do
    table.insert(stack, node:type())
    node = node:parent()
  end
  return stack
end

--- @param node_stack node_stack
--- @return boolean
--- Check for a given node stack whether we are in math
local function stack_is_in_math(node_stack)
  for _, node_type in ipairs(node_stack) do
    if TEXT_NODES[node_type] then
      return false
    end
    if MATH_NODES[node_type] then
      return true
    end
  end
  return false
end

--- @param node_stack node_stack
--- @param check_parent boolean
--- @return boolean
--- Check for a given node stack whether we are in text
local function stack_is_in_text(node_stack, check_parent)
  for _, node_type in ipairs(node_stack) do
    if TEXT_NODES[node_type] and not check_parent then
      return true
    end
    if MATH_NODES[node_type] then
      return false
    end
  end
  return true
end

--- @param buf buffer buffer handle
--- Create a callback function which will track whether user is currently
--- editing math
--- @return function
local function mk_callback(buf)
  return function()
    local current_buf = vim.api.nvim_get_current_buf()
    if buf ~= current_buf then
      return
    end

    local parser = tracked_bufs[buf].parser
    tracked_bufs[buf].tree = parser:parse()[1]
    local node_stack = get_node_stack()
    tracked_bufs[buf].node_stack = node_stack
    tracked_bufs[buf].in_math = stack_is_in_math(node_stack)
    tracked_bufs[buf].in_text = stack_is_in_text(node_stack, true)
  end
end

--- @param buf buffer Buffer handle
--- Start tracking a buffer.
--- Assert that given buffer was not tracked before.
local function init_buf(buf)
  assert(not tracked_bufs[buf], "Attempt to initialize already tracked buffer")
  local success, parser = pcall(vim.treesitter.get_parser, buf, "latex")
  if not success then
    vim.notify("Could not load latex treesitter parser. Is it installed?\n TSInstall latex", vim.log.levels.ERROR)
    error(parser, 2)
  end
  local timer = vim.loop.new_timer()
  timer:start(0, 100, vim.schedule_wrap(mk_callback(buf)))

  tracked_bufs[buf] = {
    timer = timer,
    parser = parser,
    tree = nil,
    node_stack = {},
    in_math = false,
    in_text = true,
  }
end

--- @param buf buffer Buffer handle
--- Stop tracking a buffer.
--- Assert that given buffer was tracked before.
local function deinit_buf(buf)
  assert(tracked_bufs[buf], "Attempt to deinitialize buffer that is not tracked")
  tracked_bufs[buf].timer:stop()
  tracked_bufs[buf].timer:close()
  tracked_bufs[buf].parser:destroy()
  tracked_bufs[buf] = nil
end

--- @param buf buffer
--- @return boolean b Whether buffer is tracked by the plugin
local function is_buf_tracked(buf)
  return tracked_bufs[buf] ~= nil
end

M.polling = {
  init_buf = init_buf,
  deinit_buf = deinit_buf,
  is_buf_tracked = is_buf_tracked,
  tracked_bufs = tracked_bufs,
}

return M
