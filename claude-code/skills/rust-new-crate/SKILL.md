---
name: rust-new-crate
description: >
  Conventions for creating a new Rust crate in an existing workspace.
  Auto-loaded when creating crates, adding workspace members, or
  scaffolding new Rust packages.
---

When creating a new crate in a Rust workspace:

1. Create the crate directory under the workspace's crate root (usually `lib/` or `crates/`)
2. Add the crate to `[workspace.members]` in the root `Cargo.toml`
3. Add any new shared dependencies to `[workspace.dependencies]` using
   `cargo add <crate>` — never hardcode versions
4. In the new crate's `Cargo.toml`, use `edition.workspace = true` and
   `rust-version.workspace = true` if the workspace defines them
5. If the workspace defines `[workspace.lints]`, add `[lints] workspace = true`
   to the new crate. Otherwise add clippy lints directly (see CLAUDE.md)
6. Run `taplo fmt` on the new `Cargo.toml` and any modified workspace TOML files
7. Run `cargo +nightly fmt` and `cargo clippy` to verify the new crate compiles clean

All style, logging, error handling, and dependency conventions are defined
in CLAUDE.md — this skill only covers the scaffolding procedure.
