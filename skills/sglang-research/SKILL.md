---
name: sglang-research
description: >
  Investigate SGLang's Python source code to understand implementation
  details for the sglang-rs Rust rewrite. Use when porting Python SGLang
  components to Rust, understanding SGLang internals, or comparing
  Python vs Rust implementations.
disable-model-invocation: true
---

Investigate SGLang's official Python source code: $ARGUMENTS

## Instructions

1. **Clone or update the SGLang repo** (if not already available):

   ```bash
   if [ -d /tmp/sglang ]; then
     cd /tmp/sglang && git pull origin main
   else
     git clone --depth=100 https://github.com/sgl-project/sglang.git /tmp/sglang
   fi
   ```

2. **Locate the relevant Python code** in `/tmp/sglang/python/sglang/srt/`
   (the serving runtime). Use `rg` and `fd` to find the specific component
   mentioned in the arguments. The SGLang codebase evolves frequently —
   discover the current file structure rather than assuming paths.

3. **Analyze the Python implementation** of the requested component:
   - Read the source thoroughly
   - Identify the core algorithm and data structures
   - Note Python-specific patterns (GIL, asyncio, multiprocessing)
   - Identify ZeroMQ IPC boundaries (these become channel boundaries in Rust)
   - Look for global state, monkey-patching, or dynamic dispatch

4. **Compare against the sglang-rs Rust implementation** if it exists.
   Check the workspace's `lib/` directory for the corresponding crate.
   Note any divergences, missing features, or recent upstream changes.

5. **Report findings** with:
   - Summary of how the Python code works
   - Key data structures and their roles
   - Hot path identification (what runs per-token or per-batch)
   - Recommended Rust translation approach (if not yet ported)
   - Edge cases or tricky behavior to preserve
   - Any recent upstream changes that differ from the current Rust impl
