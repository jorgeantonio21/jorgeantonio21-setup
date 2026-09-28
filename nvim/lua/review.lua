-- Review what an AI agent changed, Cursor style. The git index is the baseline:
-- stage your own work before prompting, and everything left unstaged is the
-- agent's. Accepting a hunk stages it; rejecting one restores it from the index.
local M = {}

-- `git diff -U0` output as quickfix items, one per hunk, labelled with the
-- hunk's first changed line.
local function parse_hunks(diff, root)
  local items, file, in_header = {}, nil, false
  for line in vim.gsplit(diff, "\n", { plain = true }) do
    if vim.startswith(line, "diff ") then
      in_header, file = true, nil
    elseif vim.startswith(line, "@@ ") then
      in_header = false
      local lnum = tonumber(line:match "^@@ %-%S+ %+(%d+)")
      items[#items + 1] = { filename = file, lnum = math.max(lnum, 1) }
    elseif in_header then
      -- `+++ b/` follows `--- a/`, so the new path wins; a deleted file only has the old one.
      -- git ends a path containing spaces with a tab. A path git still quotes (one with `"`,
      -- `\` or control characters) doesn't match, and its hunks are listed without a file.
      local path = line:match "^%-%-%- a/(.-)\t?$" or line:match "^%+%+%+ b/(.-)\t?$"
      if path then
        file = root .. "/" .. path
      end
    elseif line:match "^[+-]" and not items[#items].text then
      items[#items].text = line
    end
  end
  return items
end

-- Every unstaged hunk in the repo into the quickfix list, so ]q / [q walk the
-- changes across files. Reads `git diff` rather than asking gitsigns, whose file
-- scan skips new files marked intent-to-add. Pushes a new list, so `:colder`
-- gets the previous one back. Returns false outside a git repository.
local function load_hunks(on_done)
  local root = vim.fs.root(vim.fn.getcwd(), ".git")
  if not root then
    return false
  end
  -- quotePath=false keeps non-ASCII paths unquoted
  local cmd = { "git", "-c", "core.quotePath=false", "diff", "--no-color", "--no-ext-diff", "-U0" }
  vim.system(cmd, { cwd = root, text = true }, function(res)
    vim.schedule(function()
      if res.code ~= 0 then
        return vim.notify("git diff failed: " .. res.stderr, vim.log.levels.ERROR, { title = "Review" })
      end
      local hunks = parse_hunks(res.stdout, root)
      vim.fn.setqflist({}, " ", { title = "Review hunks", items = hunks })
      on_done(hunks)
    end)
  end)
  return true
end

function M.hunks_to_qflist()
  local in_repo = load_hunks(function(hunks)
    if #hunks == 0 then
      return vim.notify("No unstaged changes", vim.log.levels.INFO, { title = "Review" })
    end
    vim.cmd.copen()
  end)
  if not in_repo then
    vim.notify("Not in a git repository", vim.log.levels.WARN, { title = "Review" })
  end
end

-- Accept everything: stage all changes, new and deleted files included.
function M.accept_all()
  local out = vim.fn.system { "git", "add", "--all" }
  if vim.v.shell_error ~= 0 then
    return vim.notify(out, vim.log.levels.ERROR, { title = "Review" })
  end
  require("gitsigns").refresh()
  vim.notify("Accepted all changes (staged)", vim.log.levels.INFO, { title = "Review" })
end

-- Colour changed lines and words in the buffer itself, like an inline review.
function M.toggle_highlights()
  local gs = require "gitsigns"
  gs.toggle_word_diff(gs.toggle_linehl())
end

-- Claude Code's Stop hook calls this through $NVIM once a turn ends: reload the
-- buffers Claude edited on disk and queue its hunks for review.
function M.claude_stopped()
  vim.schedule(function()
    vim.cmd.checktime()
    load_hunks(function(hunks)
      if #hunks == 0 then
        return
      end
      local files = {}
      for _, hunk in ipairs(hunks) do
        files[hunk.filename] = true
      end
      local msg = "Unreviewed: %d file(s), %d hunk(s). <leader>gd to review, ]q to step through"
      vim.notify(msg:format(vim.tbl_count(files), #hunks), vim.log.levels.INFO, { title = "Claude Code" })
    end)
  end)
end

-- Claude Code's Notification hook calls this when Claude is waiting on you.
function M.claude_notified(msg)
  vim.schedule(function()
    vim.notify(msg, vim.log.levels.WARN, { title = "Claude Code" })
  end)
end

return M
