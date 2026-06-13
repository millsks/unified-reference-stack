# Pixi Cheat Sheet

## Install & update

```bash
# Install Pixi (macOS / Linux)
curl -fsSL https://pixi.sh/install.sh | bash

# Self-update
pixi self-update

# Check version
pixi --version
```

## Environments

```bash
pixi install              # install default environment
pixi install --all        # install every environment in pixi.toml
pixi install -e py-dev    # install a specific named environment

pixi shell                # activate default environment
pixi shell -e rust        # activate a named environment

pixi list                 # packages in default environment
pixi list -e security     # packages in a named environment
```

## Running tasks

```bash
pixi run <task>           # run in default environment
pixi run -e <env> <task>  # run in a specific environment

# Root-level tasks (run from repo root)
pixi run bootstrap
pixi run lint-all
pixi run test-all
pixi run ci
pixi run docker-up
pixi run docker-down
pixi run docker-logs
pixi run build-all

# Security tasks (require -e security)
pixi run -e security sbom-all
pixi run -e security scan-secrets
pixi run -e security scan-vulns
pixi run -e security security-full
```

## Managing packages

```bash
pixi add numpy                        # add conda package to default
pixi add --pypi httpx                 # add PyPI package to default
pixi add --feature py numpy           # add to a named feature
pixi add --feature py-test --pypi pytest  # add PyPI to a feature

pixi remove numpy                     # remove a conda package
pixi update                           # update all + regenerate lock file
pixi update numpy                     # update one package
```

## Lock file

```bash
pixi install --frozen     # install without updating lock (use in CI / Docker)
pixi install --locked     # install and error if lock file would change
```

## Task anatomy (pixi.toml)

```toml
[tasks]
# Simple command
build = "cargo build --release"

# With working directory
test = { cmd = "pytest tests/ -v", cwd = "apps/py-service" }

# With dependencies (run in order)
ci = { depends-on = ["lint", "test"] }

# With environment variables
serve = { cmd = "uvicorn main:app", env = { PORT = "8000" } }
```

## Environments anatomy (pixi.toml)

```toml
[feature.test.pypi-dependencies]
pytest = ">=8.0"

[environments]
test = { features = ["test"], solve-group = "default" }
```
