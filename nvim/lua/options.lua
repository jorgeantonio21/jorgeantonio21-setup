require "nvchad.options"

-- add yours here!

-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!

-- No whitespace-ignoring flags: when reviewing agent output, a changed indent or
-- stray trailing space is part of the change and has to be visible.
vim.opt.diffopt:append {
  "vertical",
  "filler",
  "closeoff",
  "linematch:60",
  "algorithm:histogram",
  "indent-heuristic",
}
