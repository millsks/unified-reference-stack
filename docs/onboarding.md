# Onboarding

## Prerequisites

| Tool        | Version  | Install                                    |
|-------------|----------|--------------------------------------------|
| Pixi        | >=0.70   | `curl -fsSL https://pixi.sh/install.sh \| bash` |
| Docker      | >=24     | [docker.com/get-docker](https://www.docker.com/get-docker) |
| Git         | >=2.40   | Managed by Pixi after first install        |

## First-time setup

```bash
# 1. Clone
git clone https://github.com/millsks/unified-reference-stack.git
cd unified-reference-stack

# 2. Install all Pixi environments
pixi install --all

# 3. Bootstrap (installs pre-commit hooks + app deps)
pixi run bootstrap

# 4. Verify
pixi run lint-shell
pixi run -e py py-dev     # starts FastAPI on :8000
```

## Working with individual apps

```bash
# Python service
cd apps/py-service
pixi run dev            # hot-reload server on :8000
pixi run -e test test   # run test suite

# Node.js API
cd apps/node-api
pixi run dev            # nodemon on :3000
pixi run test

# Rust CLI
cd apps/rust-cli
pixi run run            # cargo run
pixi run test           # cargo test
```

## Full stack

```bash
pixi run docker-up      # starts all services via Compose
pixi run docker-logs    # tail all service logs
pixi run docker-down    # stop everything
```

## Code style

- Python: `ruff` for linting and formatting, `mypy` for type checking
- Node.js: `eslint` for linting
- Rust: `clippy` and `rustfmt`
- Shell: `shellcheck`
- Pre-commit hooks enforce all of the above on every commit
