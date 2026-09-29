return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- VSCode-style diffs next to an explorer of changed files, built for reviewing
  -- an agent's work as it lands. In a view: `t` flips inline / side-by-side,
  -- ]c [c walk hunks (and on into the next file), ]f [f walk files, <leader>hs /
  -- <leader>hr stage / discard the hunk, `-` stages the file, `g?` lists the rest.
  -- codediff never downloads a prebuilt binary: build.sh compiles the diff
  -- library locally (needs a C compiler), and without its native file watcher
  -- the explorer refreshes by polling instead.
  {
    "esmuellert/codediff.nvim",
    cmd = "CodeDiff",
    build = "./build.sh",
    init = function()
      vim.env.CODEDIFF_WATCHER_NO_AUTO_INSTALL = "1"
    end,
    opts = {
      diff = {
        layout = "inline",
        cycle_hunks_across_files = true,
      },
      explorer = {
        line_stats = { enabled = true, count_untracked = true },
      },
    },
  },

  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G", "Gdiffsplit", "Gvdiffsplit", "Gclog" },
  },

  {
    "lewis6991/gitsigns.nvim",
    opts = function(_, opts)
      opts = opts or {}
      opts.current_line_blame = false
      -- files an agent creates show up as all-added hunks
      opts.attach_to_untracked = true
      opts.preview_config = {
        border = "rounded",
      }

      opts.on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        map("n", "]h", function()
          gs.nav_hunk "next"
        end, "Next hunk")
        map("n", "[h", function()
          gs.nav_hunk "prev"
        end, "Prev hunk")
        map("n", "<leader>hp", gs.preview_hunk_inline, "Preview hunk inline")
        map("n", "<leader>ht", require("review").toggle_highlights, "Toggle review highlights")
        map("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
        map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
        map("v", "<leader>hs", function()
          gs.stage_hunk { vim.fn.line ".", vim.fn.line "v" }
        end, "Stage selected lines")
        map("v", "<leader>hr", function()
          gs.reset_hunk { vim.fn.line ".", vim.fn.line "v" }
        end, "Reset selected lines")
        map("n", "<leader>hS", gs.stage_buffer, "Stage buffer")
        map("n", "<leader>hR", gs.reset_buffer, "Reset buffer")
        map("n", "<leader>hb", gs.blame_line, "Blame line")
        map("n", "<leader>hd", gs.diffthis, "Diff this")
      end

      return opts
    end,
  },

  {
    'mrcjkb/rustaceanvim',
    version = '^8', -- Recommended
    lazy = false, -- This plugin is already lazy
    ft = "rust",
  },

  {
    'rust-lang/rust.vim',
    ft = "rust",
    init = function ()
      vim.g.rustfmt_autosave = 1
    end
  },

  {
    "saecki/crates.nvim",
    ft = { "toml" },
    config = function()
      require("crates").setup {
        lsp = {
          enabled = true,
          actions = true,
          completion = true,
          hover = true,
        },
      }
    end,
  },

  -- Claude Code IDE integration: implements the same WebSocket protocol as the
  -- official VS Code / JetBrains extensions (selection context, @-mentions,
  -- in-editor diff review). Requires the `claude` CLI on PATH.
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    opts = {
      -- terminal_cmd = "~/.claude/local/claude", -- set if claude is not on PATH
      focus_after_send = true,
      terminal = {
        provider = "auto", -- snacks when available, native split otherwise
        split_side = "right",
        split_width_percentage = 0.35,
      },
      -- Only shown when Claude asks before each edit (default permission mode).
      -- In accept-edits or auto mode edits land on disk and are reviewed
      -- afterwards with <leader>gd / <leader>go (see lua/review.lua).
      diff_opts = {
        layout = "unified",
        auto_resize_terminal = true,
      },
    },
    cmd = {
      "ClaudeCode",
      "ClaudeCodeFocus",
      "ClaudeCodeSelectModel",
      "ClaudeCodeAdd",
      "ClaudeCodeSend",
      "ClaudeCodeTreeAdd",
      "ClaudeCodeStatus",
      "ClaudeCodeStart",
      "ClaudeCodeStop",
      "ClaudeCodeOpen",
      "ClaudeCodeClose",
      "ClaudeCodeDiffAccept",
      "ClaudeCodeDiffDeny",
      "ClaudeCodeCloseAllDiffs",
    },
    keys = {
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Claude toggle" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Claude focus" },
      { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Claude resume session" },
      { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Claude continue last session" },
      { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Claude select model" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Claude add current buffer" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Claude send selection" },
      {
        "<leader>as",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Claude add file from tree",
        ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw", "snacks_picker_list" },
      },
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Claude accept diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Claude deny diff" },
      { "<leader>ax", "<cmd>ClaudeCodeCloseAllDiffs<cr>", desc = "Claude close all diffs" },
      { "<leader>aS", "<cmd>ClaudeCodeStatus<cr>", desc = "Claude connection status" },
    },
  },

  -- Codex in a side split via sidekick.nvim. Codex has no IDE protocol like the
  -- one claudecode.nvim speaks, so this drives the real Codex TUI and pushes
  -- context into it (file, visual selection, function under the cursor).
  -- `<leader>os` switches to any other installed CLI (claude, gemini, pi, ...).
  {
    "folke/sidekick.nvim",
    dependencies = { "folke/snacks.nvim" },
    opts = {
      -- next edit suggestions need a Copilot subscription, so stay off <Tab>
      nes = { enabled = false },
      cli = {
        watch = true, -- reload buffers the CLI edits on disk
        win = {
          layout = "right",
          split = { width = 80 },
        },
        -- mux = { backend = "tmux", enabled = true }, -- keep sessions alive outside nvim
      },
    },
    cmd = "Sidekick",
    keys = {
      {
        "<leader>oo",
        function()
          require("sidekick.cli").toggle { name = "codex", focus = true }
        end,
        desc = "Codex toggle",
      },
      {
        "<leader>of",
        function()
          require("sidekick.cli").send { name = "codex", msg = "{file}" }
        end,
        desc = "Codex send file",
      },
      {
        "<leader>ov",
        function()
          require("sidekick.cli").send { name = "codex", msg = "{selection}" }
        end,
        mode = "x",
        desc = "Codex send selection",
      },
      {
        "<leader>ot",
        function()
          require("sidekick.cli").send { name = "codex", msg = "{this}" }
        end,
        mode = { "n", "x" },
        desc = "Codex send this (function/class)",
      },
      {
        "<leader>op",
        function()
          local cli = require "sidekick.cli"
          cli.prompt {
            cb = function(_, text)
              if text then
                cli.send { name = "codex", text = text }
              end
            end,
          }
        end,
        mode = { "n", "x" },
        desc = "Codex prompt library",
      },
      {
        "<leader>od",
        function()
          require("sidekick.cli").close { name = "codex" }
        end,
        desc = "Codex close session",
      },
      {
        "<leader>os",
        function()
          require("sidekick.cli").select { focus = true }
        end,
        desc = "Select AI CLI (codex, claude, ...)",
      },
    },
  },

  -- GitHub PRs and issues via Snacks.gh (needs `gh` authenticated).
  -- Review flow:
  --   1. `<leader>gq` (review queue), <cr> on a PR, "Start a review". Without a
  --      pending review, `a` posts each line comment on its own immediately.
  --   2. To read with LSP, check the PR out in a separate worktree (never in a
  --      checkout an AI session is working in), open nvim there (or `:tcd` in a
  --      new tab), and `<leader>gB` diffs it against its base in CodeDiff.
  --   3. "View diff" (or `d` in a PR buffer), `<a-w>` into the diff pane, `a` on
  --      a line (or `V` + `a` for a suggestion).
  --   4. <cr> > "Submit pending review". Resolve threads in the browser (`<a-b>`).
  -- snacks.nvim is already pulled in by claudecode and sidekick; this spec
  -- merges into theirs.
  {
    "folke/snacks.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      picker = {
        sources = {
          -- the diff pane is where you review, so give it the whole screen
          gh_diff = { layout = { fullscreen = true } },
        },
      },
      gh = {
        keys = {
          diff = { "d", "gh_diff", desc = "View diff" },
        },
      },
    },
    keys = {
      { "<leader>gr", function() Snacks.picker.gh_pr() end, desc = "GitHub PRs (open)" },
      { "<leader>gR", function() Snacks.picker.gh_pr { state = "all" } end, desc = "GitHub PRs (all)" },
      { "<leader>gq", function() Snacks.picker.gh_pr { search = "review-requested:@me" } end, desc = "PRs awaiting my review" },
      { "<leader>gm", function() Snacks.picker.gh_pr { author = "@me" } end, desc = "My PRs" },
      { "<leader>gi", function() Snacks.picker.gh_issue() end, desc = "GitHub issues (open)" },
      -- agent review list: every unstaged hunk with its diff; <Tab> accepts
      -- (stages) it, <c-r> rejects (restores) it on disk
      { "<leader>gd", function() Snacks.picker.git_diff { staged = false } end, desc = "Review hunks (accept/reject)" },
      {
        "<leader>gB",
        function()
          local base = vim.trim(vim.fn.system { "gh", "pr", "view", "--json", "baseRefName", "-q", ".baseRefName" })
          if vim.v.shell_error ~= 0 or base == "" then
            return Snacks.notify.warn "No PR for this branch"
          end
          vim.cmd(("CodeDiff origin/%s...HEAD"):format(base))
        end,
        desc = "CodeDiff against this PR's base",
      },
    },
  },

  { import = "nvchad.blink.lazyspec" },

  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      opts.keymap = vim.tbl_extend("force", opts.keymap or {}, {
        ["<Tab>"] = {
          function()
            local ok, vt = pcall(require, "codeium.virtual_text")
            if ok and vt.get_current_completion_item and vt.get_current_completion_item() then
              vt.accept()
              return true
            end
          end,
          "select_next",
          "snippet_forward",
          "fallback",
        },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
      })
      return opts
    end,
  },
}
