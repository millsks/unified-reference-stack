# Style Guide

## Python

- Formatter: `ruff format` (Black-compatible)
- Linter: `ruff check` (Flake8-compatible rules)
- Type checker: `mypy --strict`
- Max line length: 100
- Docstrings: only for public APIs; one line if the name is self-explanatory

```bash
cd apps/py-service
pixi run -e lint format    # auto-format
pixi run -e lint lint      # lint check
pixi run -e lint typecheck # type check
```

## Node.js

- Linter: `eslint` (flat config, `eslint.config.js`)
- No Prettier — eslint handles formatting rules
- CommonJS (`require`) in the Express service; ESM (`import`) in the Vite frontend

```bash
cd apps/node-api
pixi run lint
```

## Rust

- Formatter: `rustfmt` (`cargo fmt`)
- Linter: `clippy` with `-D warnings` (all warnings are errors)
- Edition: 2021

```bash
cd apps/rust-cli
pixi run format
pixi run lint
```

## Shell

- All scripts must pass `shellcheck` with zero warnings
- Use `set -euo pipefail` at the top of every script
- Use `"${var}"` double-quoting throughout

```bash
pixi run lint-shell
```

## Git

- Branch naming: `feat/`, `fix/`, `chore/`, `docs/`
- Commit messages: Conventional Commits (see [contributing.md](contributing.md))
- Commits should be atomic: one logical change per commit
