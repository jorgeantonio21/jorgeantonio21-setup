require "nvchad.options"

-- add yours here!

-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!

vim.opt.diffopt:append {
  "vertical",
  "filler",
  "closeoff",
  "linematch:60",
  "algorithm:histogram",
  "indent-heuristic",
  "iwhiteall",
}
