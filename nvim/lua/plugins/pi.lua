return {
  {
    "carderne/pi-nvim",
    lazy = false,
    config = function()
      require("pi-nvim").setup()

      local map = vim.keymap.set
      map("n", "<leader>pp", "<cmd>PiSend<CR>", { desc = "Pi prompt" })
      map("n", "<leader>pf", "<cmd>PiSendFile<CR>", { desc = "Pi send file" })
      map("v", "<leader>ps", ":PiSendSelection<CR>", { desc = "Pi send selection" })
      map("n", "<leader>pb", "<cmd>PiSendBuffer<CR>", { desc = "Pi send buffer" })
      map("n", "<leader>pi", "<cmd>PiPing<CR>", { desc = "Pi ping" })
      map("n", "<leader>pS", "<cmd>PiSessions<CR>", { desc = "Pi sessions" })
    end,
  },
}
