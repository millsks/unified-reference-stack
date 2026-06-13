# ADR 001: Pixi as the Polyglot Package Manager

**Status:** Accepted
**Date:** 2026-06-12

## Context

The unified-reference-stack hosts Python, Node.js, Rust, and Shell applications in a single
repository. Managing multiple language toolchains reproducibly across Linux, macOS, and Windows
without requiring per-developer manual installation is a hard requirement.

Alternatives considered:

| Tool        | Strengths                            | Weaknesses for this use case               |
|-------------|--------------------------------------|--------------------------------------------|
| Nix / flake | Hermetic, reproducible               | Steep learning curve, poor Windows support |
| asdf        | Multi-language version management    | No lock file, no task runner, Unix-only    |
| mise (rtx)  | Fast, multi-language                 | Younger ecosystem, no Windows support      |
| Conda/Mamba | Python + native packages             | Single-language focus, no task runner      |
| Makefile    | Universal                            | No dependency management at all            |
| **Pixi**    | See Decision below                   |                                            |

## Decision

Use [Pixi](https://pixi.sh) as the single tool for dependency management, environment
isolation, and task running across all languages.

Key factors:

1. **Cross-platform**: Works identically on `linux-64`, `osx-arm64`, `osx-64`, and `win-64`
   without WSL or Homebrew.

2. **Lock file**: `pixi.lock` pins every package across all platforms and environments,
   enabling byte-for-byte reproducible installs in CI and on new developer machines.

3. **Multi-language**: Manages Python (conda + PyPI via uv), Node.js, Rust, and system
   packages from conda-forge in one manifest.

4. **Task runner**: `pixi run <task>` replaces `make`, `npm run`, and shell script wrappers
   with cross-platform, dependency-aware task execution.

5. **Features + environments**: Named feature groups (e.g. `py`, `py-test`, `py-lint`) compose
   into environments, keeping production installs lean while CI gets everything.

6. **Solve groups**: Independent solver runs per language (`solve-group = "py"`, `"node"`,
   `"rust"`) prevent cross-language version conflicts.

## Consequences

**Positive:**
- Single `pixi install --all` bootstraps the entire repo on any OS.
- `pixi.lock` eliminates "works on my machine" dependency drift.
- Task definitions live in `pixi.toml` alongside their dependencies.

**Negative / trade-offs:**
- Not all tools are on conda-forge (`cargo-watch`, `gitleaks`, `cyclonedx-cli`).
  These require separate `cargo install` or download steps, documented in the relevant READMEs.
- `jq` has no `win-64` conda-forge build; platform-specific dependency declarations are required.
- Pixi is younger than Nix or Conda; some edge cases (e.g. `default-environment` task field)
  may not yet be implemented in the current release.

## References

- [Pixi documentation](https://pixi.sh/latest/)
- [conda-forge package search](https://prefix.dev/channels/conda-forge)
- [pixi.toml](../../../pixi.toml) — root workspace manifest
