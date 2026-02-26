# Global Development Standards

Global instructions for all projects. Project-specific CLAUDE.md files override these defaults.

- Prefer Exa AI (`mcp__exa__web_search_exa`) over `WebSearch` for all web searches
- Use skills proactively when they match the task — suggest relevant ones, don't block on them

## Philosophy

- **No speculative features** - Don't add features, flags, or configuration unless users actively need them
- **No premature abstraction** - Don't create utilities until you've written the same code three times
- **Clarity over cleverness** - Prefer explicit, readable code over dense one-liners
- **Justify new dependencies** - Each dependency is attack surface and maintenance burden
- **No phantom features** - Don't document or validate features that aren't implemented
- **Replace, don't deprecate** - When a new implementation replaces an old one, remove the old one entirely. No backward-compatible shims, dual config formats, or migration paths. Proactively flag dead code — it adds maintenance burden and misleads both developers and LLMs.
- **Verify at every level** - Set up automated guardrails (linters, type checkers, pre-commit hooks, tests) as the first step, not an afterthought. Prefer structure-aware tools (ast-grep, LSPs, compilers) over text pattern matching. Review your own output critically. Every layer catches what the others miss.
- **Bias toward action** - Decide and move for anything easily reversed; state your assumption so the reasoning is visible. Ask before committing to interfaces, data models, architecture, or destructive/write operations on external services.
- **Finish the job** - Don't stop at the minimum that technically satisfies the request. Handle the edge cases you can see. Clean up what you touched. If something is broken adjacent to your change, flag it. But don't invent new scope — there's a difference between thoroughness and gold-plating.
- **Agent-native by default** - Design so agents can achieve any outcome users can. Tools are atomic primitives; features are outcomes described in prompts. Prefer file-based state for transparency and portability. When adding UI capability, ask: can an agent achieve this outcome too?

## Domain Context

Primary domains: distributed systems, high-performance computing, LLM inference, consensus protocols, trading systems, security

### Distributed Systems & HPC

- Thread-per-core or pinned-thread architectures with message passing over lock-free channels
- Lock-free SPSC ring buffers (`rtrb`) for inter-thread communication between dedicated threads
- `crossbeam-channel` and `flume` for MPSC; `crossbeam-epoch` for lock-free memory reclamation
- `arc-swap` for hot-swappable shared state; `dashmap` / `scc` for concurrent maps
- `parking_lot` when locks are unavoidable (never `std::sync::Mutex`)
- Design for deterministic replay: separate I/O from state transitions
- Core affinity (`core_affinity`) for latency-sensitive threads

### Performance-Critical Code

- Profile before optimizing (`criterion` benchmarks, `hdrhistogram` for latency)
- Zero-copy where possible (`rkyv`, `zerocopy`, `bytes`)
- Preallocated storage (`slab`, `arrayvec`, `smallvec`) over dynamic allocation in hot paths
- Pipeline parallelism: CPU prepares batch N+1 while GPU/IO executes batch N

## Code Quality

### Hard limits

1. ≤100 lines/function, cyclomatic complexity ≤8
2. ≤5 positional params
3. 100-char line width for code, 120-char for comments (`comment_width = 120`)
4. Absolute imports only — no relative (`..`) paths
5. Google-style docstrings on non-trivial public APIs

### Zero warnings policy

Fix every warning from every tool — linters, type checkers, compilers, tests. If a warning truly can't be fixed, add an inline ignore with a justification comment. Never leave warnings unaddressed; a clean output is the baseline, not the goal.

### Comments

Code should be self-documenting. No commented-out code—delete it. If you need a comment to explain WHAT the code does, refactor the code instead.

### Error handling

- Fail fast with clear, actionable messages
- Never swallow exceptions silently
- Include context (what operation, what input, suggested fix)

### Reviewing code

Evaluate in order: architecture → code quality → tests → performance. Before reviewing, sync to latest remote (`git fetch origin`).

For each issue: describe concretely with file:line references, present options with tradeoffs when the fix isn't obvious, recommend one, and ask before proceeding.

### Testing

**Test behavior, not implementation.** Tests should verify what code does, not how. If a refactor breaks your tests but not your code, the tests were wrong.

**Test edges and errors, not just the happy path.** Empty inputs, boundaries, malformed data, missing files, network failures — bugs live in edges. Every error path the code handles should have a test that triggers it.

**Mock boundaries, not logic.** Only mock things that are slow (network, filesystem), non-deterministic (time, randomness), or external services you don't control.

**Verify tests catch failures.** Break the code, confirm the test fails, then fix.

## Development

When adding dependencies, CI actions, or tool versions, always look up the current stable version — never assume from memory unless the user provides one.

### Adding dependencies

**Never hardcode dependency versions manually.** Use the package manager's add command to fetch the latest stable version:

- **Rust:** `cargo add <crate_name>` (or `cargo add <crate_name> --features feat1,feat2`). For workspace deps: `cargo add <crate_name> --path . --manifest-path Cargo.toml`
- **Python:** `uv add <package_name>` (or `uv pip install <package_name>` for non-project contexts)
- **TypeScript:** `pnpm add <package_name>` (or `pnpm add -D <package_name>` for dev deps)

### CLI tools

| tool | replaces | usage |
|------|----------|-------|
| `rg` (ripgrep) | grep | `rg "pattern"` - 10x faster regex search |
| `fd` | find | `fd "*.py"` - fast file finder |
| `ast-grep` | - | `ast-grep --pattern '$FUNC($$$)' --lang rust` - AST-based code search |
| `shellcheck` | - | `shellcheck script.sh` - shell script linter |
| `shfmt` | - | `shfmt -i 2 -w script.sh` - shell formatter |
| `actionlint` | - | `actionlint .github/workflows/` - GitHub Actions linter |
| `zizmor` | - | `zizmor .github/workflows/` - Actions security audit |
| `prek` | pre-commit | `prek run` - fast git hooks (Rust, no Python) |
| `wt` | git worktree | `wt switch branch` - manage parallel worktrees |
| `trash` | rm | `trash file` - moves to macOS Trash (recoverable). **Never use `rm -rf`** |
| `taplo` | - | `taplo fmt` - TOML formatter. **All TOML files must be taplo-formatted** |

Prefer `ast-grep` over ripgrep when searching for code structure (function calls, class definitions, imports, pattern matching across arguments). Use ripgrep for literal strings and log messages.

## Rust (Primary Language)

**Toolchain:** Pinned via `rust-toolchain.toml` per project (typically latest stable). Nightly required only for `rustfmt`.

| purpose | tool |
|---------|------|
| build & deps | `cargo` |
| add deps | `cargo add <crate>` — never hardcode versions |
| lint | `cargo clippy --all-targets --all-features -- -D warnings` |
| format (code) | `cargo +nightly fmt` (nightly required for `unstable_features`) |
| format (TOML) | `taplo fmt` |
| test | `cargo test` |
| supply chain | `cargo deny check advisories bans sources` · `cargo audit` |
| safety check | `cargo careful test` (stdlib debug assertions + UB checks) |

### Formatting

- **rustfmt** (nightly): `comment_width = 120`, `wrap_comments = true`, `unstable_features = true`
- **taplo**: All `.toml` files MUST be formatted with `taplo fmt`. Config: aligned entries, aligned comments, reordered keys/deps/arrays, trailing commas, 4-space indent, 100-char column width
- Format check: `cargo +nightly fmt -- --check && taplo fmt --check`

### Style

- Shadow variables through transformations (no `raw_x`/`parsed_x` prefixes)
- No wildcard matches — explicit destructuring catches field changes. `matches!` is fine for boolean checks where you don't need to bind values
- Use `let...else` for early returns; keep happy path unindented
- Workspace dependencies: always use `dependency = { workspace = true }` syntax (never `dependency.workspace = true`)
- Features: add in specific crate `Cargo.toml` files, never in workspace-level `[workspace.dependencies]`
- Workspace deps: centralize versions in root `Cargo.toml` `[workspace.dependencies]`; crates reference them with `{ workspace = true }`

### Type design

- Newtypes over primitives (`UserId(u64)` not `u64`)
- Enums for state machines, not boolean flags
- `thiserror` for library error types, `anyhow` for application error handling
- `anyhow::Result<T>` with `.context()` for stack traces in applications
- Const generics for protocol parameters (e.g., `<const N: usize, const F: usize>`)

### Logging

- `slog` for structured logging in core/sync paths, `tracing` for async/runtime paths
- Never `println!` or `eprintln!` — always use structured logging macros
- Log levels: `error!` (requires action), `warn!` (degraded), `info!` (state changes), `debug!` (diagnostic)

### Serialization

- `rkyv` for zero-copy internal serialization
- `prost` / `tonic` for gRPC and protobuf
- `serde` + `serde_json` for config and REST APIs
- `bincode` for compact binary encoding

### Concurrency patterns

- Lock-free SPSC ring buffers (`rtrb`) between dedicated threads
- `crossbeam-channel` / `flume` for MPSC
- `tokio` for async I/O; keep async and sync paths separated
- `rayon` for parallel batch operations (e.g., signature verification)

### Config

- `figment` for layered configuration: TOML/YAML files + env vars with project-specific prefix and `__` nesting
- Always provide a `config.example.toml` in the repo root

### gRPC / Protobuf

- `tonic` + `prost` for gRPC services, `tonic-build` for code generation
- Proto files live alongside the crate that owns the service (e.g., `grpc-client/proto/`)
- Service definitions follow standard gRPC naming: `service FooService { rpc GetFoo(...) returns (...); }`

### Optimization

- Write efficient code by default — correct algorithm, appropriate data structures, no unnecessary allocations
- Profile before micro-optimizing; measure after

### Cargo.toml lints (recommended for new projects)

```toml
[lints.clippy]
pedantic = { level = "warn", priority = -1 }
# Panic prevention
panic_in_result_fn = "deny"
unimplemented = "deny"
# Code hygiene
dbg_macro = "deny"
todo = "warn"
print_stdout = "deny"
print_stderr = "deny"
# Safety
await_holding_lock = "deny"
large_futures = "deny"
exit = "deny"
mem_forget = "deny"
# Pedantic relaxations (too noisy)
module_name_repetitions = "allow"
similar_names = "allow"
```

### Supply chain

- Maintain a `deny.toml` in every workspace
- Run `cargo deny check advisories bans sources` and `cargo audit` before merging
- Pin exact versions in workspace deps

## Secondary Languages

### Python

**Runtime:** 3.13 with `uv venv`

| purpose | tool |
|---------|------|
| deps & venv | `uv` |
| add deps | `uv add <package>` — never hardcode versions |
| lint & format | `ruff check` · `ruff format` |
| static types | `ty check` |
| tests | `pytest -q` |

Use `uv`, `ruff`, and `ty` over pip/poetry, black/pylint/flake8, and mypy/pyright. Supply chain: `pip-audit` before deploying, pin exact versions.

### Node/TypeScript

**Runtime:** Node 22 LTS, ESM only (`"type": "module"`)

| purpose | tool |
|---------|------|
| add deps | `pnpm add <package>` — never hardcode versions |
| lint | `oxlint` |
| format | `oxfmt` |
| test | `vitest` |
| types | `tsc --noEmit` |

Use `oxlint` and `oxfmt` over eslint/prettier. Pin exact versions (no `^` or `~`).

### Bash

All scripts must start with `set -euo pipefail`. Lint: `shellcheck script.sh && shfmt -d script.sh`

### GitHub Actions

Pin actions to SHA hashes with version comments: `actions/checkout@<full-sha>  # vX.Y.Z` (use `persist-credentials: false`). Scan workflows with `zizmor` before committing. Configure Dependabot with 7-day cooldowns and grouped updates.

## Infrastructure

### Docker & Docker Compose

- E2E tests run against docker-compose environments (`envs/dev-local/`)
- Use `testcontainers` for integration tests that need external services (postgres, redis, etcd)
- Never hardcode `localhost` — use `127.0.0.1` to avoid IPv6 resolution issues
- Multi-stage Dockerfile builds with a shared `rust-builder` stage for caching

### Terraform & IaC

- Terraform for AWS infrastructure; reusable modules in `modules/`, environment configs in `envs/`
- Packer for AMI builds using a layered golden image approach (Base AMI → App AMI)
- State management: remote state with locking where possible
- Never commit `.tfvars` files with secrets — use environment variables or a secrets manager

## Workflow

**Before committing:**
1. Re-read your changes for unnecessary complexity, redundant code, and unclear naming
2. Run relevant tests — not the full suite
3. `cargo +nightly fmt -- --check && taplo fmt --check` (Rust projects)
4. `cargo clippy --all-targets --all-features -- -D warnings`

**Branch naming:** `<type>/ja/<short-description>` where type matches the change:
- `feat/ja/add-radix-cache` — new feature
- `fix/ja/resolve-nonce-drift` — bug fix
- `refactor/ja/simplify-view-chain` — restructuring without behavior change
- `chore/ja/update-dependencies` — maintenance, CI, tooling
- `docs/ja/architecture-diagrams` — documentation only

**Commits:**
- Imperative mood, ≤72 char subject line, one logical change per commit
- Do not add `Co-Authored-By` or any signature lines to commits unless explicitly asked
- Never amend/rebase commits already pushed to shared branches
- Never push directly to main — use feature branches and PRs
- Never commit secrets, API keys, or credentials — use `.env` files (gitignored) and environment variables

**Hooks and worktrees:**
- Install prek in every repo (`prek install`). Run `prek run` before committing. Configure auto-updates: `prek auto-update --cooldown-days 7`
- Parallel subagents require worktrees. Each subagent MUST work in its own worktree (`wt switch <branch>`), not the main repo. Never share working directories.

**Pull requests:**
Describe what the code does now — not discarded approaches, prior iterations, or alternatives. Only describe what's in the diff.

Use plain, factual language. A bug fix is a bug fix, not a "critical stability improvement." Avoid: critical, crucial, essential, significant, comprehensive, robust, elegant.
