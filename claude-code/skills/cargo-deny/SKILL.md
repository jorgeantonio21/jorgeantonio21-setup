---
name: cargo-deny
description: >
  Supply chain security with cargo-deny and cargo-audit. Auto-loaded
  when adding dependencies, auditing crates, or setting up deny.toml.
---

## Tools

- `cargo deny` — checks advisories, licenses, bans, and sources
- `cargo audit` — RUSTSEC advisory database checks

## Running checks

```bash
cargo deny check advisories bans sources
cargo audit
```

Run both before merging any PR that adds or updates dependencies.

## deny.toml setup

Every workspace must have a `deny.toml` in the root. Minimal config:

```toml
[advisories]
vulnerability = "deny"
unmaintained = "warn"
yanked = "warn"
notice = "warn"

[licenses]
unlicensed = "deny"
allow = [
    "MIT",
    "Apache-2.0",
    "BSD-2-Clause",
    "BSD-3-Clause",
    "ISC",
    "Unicode-3.0",
    "Zlib",
]

[bans]
multiple-versions = "warn"
wildcards = "deny"

[sources]
unknown-registry = "deny"
unknown-git = "deny"
allow-registry = ["https://github.com/rust-lang/crates.io-index"]
allow-git = []
```

## When adding new dependencies

1. Use `cargo add <crate>` — never hardcode versions
2. Run `cargo deny check advisories bans sources` to verify the new dep
3. If `cargo deny` flags a license issue, check if the license is
   acceptable and add it to `[licenses.allow]`
4. If multiple versions of the same crate are pulled in, check if
   the workspace can converge on one version

## CI integration

Add to CI pipeline:

```yaml
- name: Supply chain check
  run: |
    cargo install cargo-deny
    cargo deny check advisories bans sources
```

## Pin exact versions

In workspace `[workspace.dependencies]`, pin exact versions for
reproducible builds. Use `cargo update` deliberately, not automatically.
