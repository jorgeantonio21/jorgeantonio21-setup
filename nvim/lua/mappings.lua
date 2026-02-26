require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- Nvim DAP
map("n", "<Leader>dl", "<cmd>lua require'dap'.step_into()<CR>", { desc = "Debugger step into" })
map("n", "<Leader>dj", "<cmd>lua require'dap'.step_over()<CR>", { desc = "Debugger step over" })
map("n", "<Leader>dk", "<cmd>lua require'dap'.step_out()<CR>", { desc = "Debugger step out" })
map("n", "<Leader>dc", "<cmd>lua require'dap'.continue()<CR>", { desc = "Debugger continue" })
map("n", "<Leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<CR>", { desc = "Debugger toggle breakpoint" })
map(
	"n",
	"<Leader>dd",
	"<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
	{ desc = "Debugger set conditional breakpoint" }
)
map("n", "<Leader>de", "<cmd>lua require'dap'.terminate()<CR>", { desc = "Debugger reset" })
map("n", "<Leader>dr", "<cmd>lua require'dap'.run_last()<CR>", { desc = "Debugger run last" })

-- rustaceanvim
map("n", "<Leader>dt", "<cmd>lua vim.cmd('RustLsp testables')<CR>", { desc = "Debugger testables" })

-- git review
map("n", "<leader>gv", "<cmd>Gvdiffsplit<CR>", { desc = "Git vertical diff" })
map("n", "<leader>gs", "<cmd>Git<CR>", { desc = "Git status (fugitive)" })
map("n", "<leader>go", "<cmd>DiffviewOpen<CR>", { desc = "Diffview open (working tree)" })
map("n", "<leader>gO", "<cmd>DiffviewOpen origin/main...HEAD<CR>", { desc = "Diffview open (PR range)" })
map("n", "<leader>gH", "<cmd>DiffviewFileHistory %<CR>", { desc = "Diffview file history" })
map("n", "<leader>gc", "<cmd>DiffviewClose<CR>", { desc = "Diffview close" })
map("n", "<leader>gp", "<cmd>tabnew | terminal git add -p<CR>", { desc = "Git add -p (patch review)" })
