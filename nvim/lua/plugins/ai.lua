return {
  {
    "Exafunction/windsurf.nvim",
    event = "InsertEnter",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      enable_cmp_source = false,
      virtual_text = {
        enabled = true,
        manual = false,
        idle_delay = 75,
        map_keys = false,
        filetypes = {
          help = false,
          gitrebase = false,
        },
        key_bindings = {
          accept = false,
          accept_word = false,
          accept_line = false,
          clear = false,
          next = "<M-]>",
          prev = "<M-[>",
        },
      },
    },
    config = function(_, opts)
      require("codeium").setup(opts)
    end,
  },
}
