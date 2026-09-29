require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- rustaceanvim
map("n", "<Leader>dt", "<cmd>lua vim.cmd('RustLsp testables')<CR>", { desc = "Debugger testables" })

-- git review
map("n", "<leader>gv", "<cmd>Gvdiffsplit<CR>", { desc = "Git vertical diff" })
map("n", "<leader>gs", "<cmd>Git<CR>", { desc = "Git status (fugitive)" })
map("n", "<leader>go", "<cmd>CodeDiff<CR>", { desc = "CodeDiff open (working tree)" })
map("n", "<leader>gO", "<cmd>CodeDiff origin/main...HEAD<CR>", { desc = "CodeDiff open (PR range)" })
map("n", "<leader>gH", "<cmd>CodeDiff history %<CR>", { desc = "CodeDiff file history" })
map("n", "<leader>gp", "<cmd>tabnew | terminal git add -p<CR>", { desc = "Git add -p (patch review)" })

-- agent review: whatever is unstaged is the agent's (see lua/review.lua)
map("n", "<leader>gh", function()
  require("review").hunks_to_qflist()
end, { desc = "Review all hunks in quickfix" })
map("n", "<leader>gA", function()
  require("review").accept_all()
end, { desc = "Review accept all (stage)" })
