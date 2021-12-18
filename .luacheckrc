-- vim: ft=lua tw=80

stds.nvim = {
  globals = {
    vim = { fields = { "g" } },
  },
  read_globals = {
    "vim",
  },
}
std = "lua51+nvim"

-- Don't report unused self arguments of methods.
self = false

ignore = {
  "631", -- max_line_length
  "212/_.*", -- unused argument, for vars with "_" prefix
}
