# Skills

[Agent Skills](https://agentskills.io/specification) shared across Claude Code, Codex, and pi.
`install.sh` collects skills from every source tree and symlinks each one into all three harness
directories, so the three agents see the same set.

## Sources

| Source | Skills | Checkout |
|--------|--------|----------|
| `skills/` (this folder) | 7 | in this repo |
| [`matpocock-skills`](https://github.com/jorgeantonio21/matpocock-skills) | 47 | `~/dev/matpocock-skills`, override with `MATPOCOCK_SKILLS` |

A missing source is skipped with a warning and the clone command, matching how `tmux/` and
`themes/` handle their external dependencies. Clone the fork with:

```sh
git clone https://github.com/jorgeantonio21/matpocock-skills ~/dev/matpocock-skills
```

`skills/deprecated/` and `node_modules/` are excluded; everything else is linked, including
`in-progress/`. Skill names share one flat namespace across sources -- the installer fails loudly
on a duplicate rather than letting one shadow another.

### Local skills

| Skill              | Description                                                        |
|--------------------|--------------------------------------------------------------------|
| `cargo-deny`       | Supply chain security with cargo-deny and cargo-audit              |
| `docker-dev`       | Docker and docker-compose conventions for local development        |
| `grpc-service`     | gRPC service conventions using tonic and prost in Rust             |
| `rust-new-crate`   | Creating a new Rust crate in an existing workspace                 |
| `sglang-research`  | Investigate SGLang's Python source for the sglang-rs Rust rewrite  |
| `sql-queries`      | Correct, performant SQL across major warehouse dialects            |
| `terraform-module` | Terraform and IaC conventions for AWS infrastructure               |

`matpocock-skills` carries the engineering and productivity workflows -- `grill-me`,
`grill-with-docs`, `wayfinder`, `ask-jorge`, `ask-matt`, `implement-by-commit`, `pair-by-commit`,
`tdd`, `code-review`, and the rest. Run `scripts/list-skills.sh` in that repo for the full list.

## Manual install

```sh
cd skills
chmod +x install.sh
./install.sh
```

Each skill is linked individually into every agent's skill directory:

| Agent       | Directory          | Notes                                                        |
|-------------|--------------------|--------------------------------------------------------------|
| Claude Code | `~/.claude/skills` | Discovered automatically                                     |
| Codex       | `~/.codex/skills`  | Requires the `skill_search` feature (on by default since 0.153); Codex writes its own bundled skills into `.system/` in the same directory |
| pi          | `~/.agents/skills` | Harness-neutral location pi scans by default -- no settings needed |

Linking skill by skill rather than linking the directory keeps Codex's bundled `.system/` skills and
anything else already in those directories intact. Stale links from a previous run -- renamed,
removed, or from a source checkout that is gone -- are pruned.

`matpocock-skills` ships its own `scripts/link-skills.sh`, but that script is upstream dev tooling
marked "not a supported installer", and it only targets `~/.claude/skills` and `~/.agents/skills`.
Codex reads `~/.codex/skills`, not `~/.agents/skills`, so it would miss every skill. This installer
covers all three and leaves the upstream script untouched.

## Adding a skill

Create `<name>/SKILL.md` here (or in the fork) with the standard frontmatter, then re-run
`install.sh`:

```markdown
---
name: my-skill
description: What this skill does and when to use it. Be specific -- this line is what each agent matches against.
---

# My Skill
...
```

Anything else in the skill directory (`scripts/`, `references/`, `assets/`) is freeform and loaded
on demand via relative paths.

## Harness differences

Of the 54 installed skills, 25 are auto-invocable and 29 set `disable-model-invocation: true`,
meaning they are meant to be triggered explicitly rather than matched against a task.

- **Claude Code** honours `disable-model-invocation`: the 29 are hidden from automatic matching and
  invoked as `/grill-me`, `/wayfinder`, `/pair-by-commit`, etc.
- **pi** behaves the same way, exposing every skill as `/skill:<name>`.
- **Codex** honours the key only for skills it resolves through a package manifest. The
  `matpocock-skills` checkout has one, so Codex auto-lists 19 of its 47 and keeps the invoke-only
  ones off the list. Codex has no `/<skill>` command in 0.154, so reach those by asking for them by
  name. Skills in this folder have no manifest, so Codex lists all 7 regardless of the key --
  `sglang-research` is auto-listed in Codex but invoke-only in Claude Code and pi.

### Known name collision

`code-review` from the fork collides with Claude Code's own built-in `code-review` skill, and the
built-in wins -- `/code-review` in Claude Code is the built-in, not the fork's two-axis Standards +
Spec review. Codex and pi have no built-in by that name and use the fork's. Rename the directory in
the fork if you want it reachable in Claude Code too.
