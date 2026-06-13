# The Unified Reference Stack

A comprehensive reference monorepo for polyglot applications -- Python, Node.js, Rust, and Shell
Scripts -- powered by Pixi for dependency management and Docker for containerized application stacks.

---

## Table of Contents

1. [What is a Monorepo?](#what-is-a-monorepo)
2. [Why Pixi?](#why-pixi)
3. [Why Docker?](#why-docker)
4. [Installing Pixi](#installing-pixi)
5. [Repository Structure Overview](#repository-structure-overview)
6. [Setting Up the Root](#setting-up-the-root)
7. [Documentation Structure](#documentation-structure)
8. [Python Applications](#python-applications)
9. [Node.js Applications](#nodejs-applications)
10. [Rust Applications](#rust-applications)
11. [Shell Scripts](#shell-scripts)
12. [Hybrid Stack Applications](#hybrid-stack-applications)
13. [Docker & Containerized Stacks](#docker--containerized-stacks)
14. [Docker Compose Orchestration](#docker-compose-orchestration)
15. [Pixi Tasks & Environments](#pixi-tasks--environments)
16. [Security & SBOM](#security--sbom)
17. [CI/CD Integration](#cicd-integration)
18. [Best Practices](#best-practices)
19. [Cheat Sheet](#cheat-sheet)

---

## What is a Monorepo?

A **monorepo** (monolithic repository) is a single version-controlled repository that houses multiple
projects, applications, and shared libraries. Rather than maintaining separate repositories for each
service or application, everything lives together -- making cross-project changes, shared tooling, and
unified CI/CD pipelines much easier to manage.

### Monorepo vs. Polyrepo

| Feature              | Monorepo                            | Polyrepo                          |
|----------------------|-------------------------------------|-----------------------------------|
| Code sharing         | Easy (shared libs in one place)     | Requires publishing packages      |
| Atomic commits       | Yes (cross-project changes in one PR) | No                              |
| CI/CD complexity     | Moderate (needs smart filtering)    | Simple per-repo, complex overall  |
| Onboarding           | One clone, one setup                | Multiple repos to clone           |
| Tooling              | Requires monorepo tools             | Standard per-repo tools           |
| Container builds     | Centralized Dockerfiles + Compose   | Scattered per-repo                |

---

## Why Pixi?

[Pixi](https://pixi.sh) is a cross-platform, multi-language package manager and workflow tool built on
the Conda ecosystem. It is an ideal fit for a polyglot monorepo because:

- **Multi-language**: Manages Python (conda + PyPI), Node.js, Rust, and system-level packages in one tool.
- **Declarative `pixi.toml`**: A single root manifest defines all dependencies, tasks, and environments.
- **Reproducible lock files**: `pixi.lock` pins every dependency across all platforms.
- **Built-in task runner**: Replace `Makefile`, `npm run`, and shell scripts with `pixi run <task>`.
- **Multiple environments**: Define `dev`, `test`, `prod`, and `lint` environments in one file.
- **Cross-platform**: Works identically on Linux, macOS, and Windows.

### Pixi Concepts at a Glance

| Concept              | Description                                                      |
|----------------------|------------------------------------------------------------------|
| `pixi.toml`          | The workspace manifest -- defines deps, tasks, environments      |
| `pixi.lock`          | Auto-generated lock file -- pins all resolved packages           |
| `[dependencies]`     | Conda packages (e.g. Python, Node.js, Rust toolchain)            |
| `[pypi-dependencies]`| PyPI packages resolved via uv                                    |
| `[tasks]`            | Cross-platform shell commands run via `pixi run`                 |
| `[feature.*]`        | Named groups of deps/tasks that compose into environments        |
| `[environments]`     | Named environments built from features                           |

---

## Why Docker?

Docker provides consistent, reproducible runtime environments for every application in the monorepo.
Combined with Pixi for local development, Docker handles production-grade containerization:

- **Isolation**: Each app runs in its own container with pinned OS-level dependencies.
- **Portability**: Build once, run anywhere -- dev, staging, production.
- **Compose stacks**: `docker-compose.yml` wires multi-service apps (API + DB + frontend) together.
- **Multi-stage builds**: Keep images lean by separating build-time and runtime layers.
- **Registry integration**: Push images to GitHub Container Registry (GHCR) or Docker Hub from CI.

### Docker + Pixi Workflow

```
Local Dev          -->  pixi run dev        (fast iteration, hot reload)
Integration Test   -->  pixi run docker:up  (full stack via Compose)
Production Build   -->  docker build        (multi-stage, minimal image)
CI/CD              -->  docker buildx bake  (parallel multi-platform builds)
```

---

## Installing Pixi

### macOS / Linux

```bash
curl -fsSL https://pixi.sh/install.sh | bash
```

### Windows (PowerShell)

```powershell
iwr -useb https://pixi.sh/install.ps1 | iex
```

### Shell Autocompletion

```bash
# bash
pixi completion --shell bash >> ~/.bashrc

# zsh
pixi completion --shell zsh >> ~/.zshrc

# fish
pixi completion --shell fish > ~/.config/fish/completions/pixi.fish
```

### Verify Installation

```bash
pixi --version
# pixi 0.x.x
```

---

## Repository Structure Overview

```
unified-reference-stack/
|
+-- apps/
|   +-- py-service/          # Python FastAPI service
|   |   +-- src/
|   |   +-- tests/
|   |   +-- Dockerfile
|   |   +-- README.md
|   |
|   +-- node-api/            # Node.js Express API
|   |   +-- src/
|   |   +-- Dockerfile
|   |   +-- package.json
|   |   +-- README.md
|   |
|   +-- rust-cli/            # Rust CLI tool
|   |   +-- src/
|   |   +-- Dockerfile
|   |   +-- Cargo.toml
|   |   +-- README.md
|   |
|   +-- hybrid-app/          # Python backend + Node.js frontend
|       +-- backend/
|       +-- frontend/
|       +-- Dockerfile.backend
|       +-- Dockerfile.frontend
|       +-- docker-compose.yml
|       +-- README.md
|
+-- scripts/                 # Shared shell utilities
|   +-- bootstrap.sh
|   +-- lint-all.sh
|   +-- docker-clean.sh
|
+-- infra/                   # Infrastructure-as-code
|   +-- docker-compose.yml   # Root-level full-stack Compose
|   +-- docker-compose.override.yml
|   +-- nginx/
|   |   +-- nginx.conf
|   +-- postgres/
|       +-- init.sql
|
+-- docs/
|   +-- architecture/
|   |   +-- overview.md
|   |   +-- service-map.md
|   |   +-- adr/
|   |       +-- 001-pixi-polyglot-monorepo.md
|   +-- development/
|   |   +-- onboarding.md
|   |   +-- contributing.md
|   |   +-- style-guide.md
|   +-- operations/
|   |   +-- docker-guide.md
|   |   +-- monitoring.md
|   |   +-- runbooks/
|   |       +-- deploy.md
|   |       +-- rollback.md
|   +-- security/
|   |   +-- sbom-guide.md
|   |   +-- secrets.md
|   |   +-- scanning.md
|   +-- kb/
|       +-- pixi-cheatsheet.md
|       +-- faq.md
|       +-- troubleshooting.md
|
+-- .github/
|   +-- CONTRIBUTING.md          # GitHub-discoverable entry point
|   +-- workflows/
|       +-- ci.yml
|       +-- docker-publish.yml
|
+-- .dockerignore
+-- .gitignore
+-- pixi.toml                # Root workspace manifest
+-- pixi.lock
+-- README.md
```

---

## Setting Up the Root

### Initialize the Repository

```bash
mkdir unified-reference-stack && cd unified-reference-stack
git init
pixi init .
```

### Root `pixi.toml`

The workspace manifest defines shared tooling, per-language features, and named environments.
Key design decisions:

- `gh` (GitHub CLI) is available in every environment alongside `git`.
- `go-yq` is the Go-based yq (v4); the Python-based `yq` on conda-forge is a different package at v3.
- `jq` has no win-64 conda-forge build, so it is declared per-platform using `[target.<platform>.dependencies]`.
- Each language group uses its own `solve-group` so package resolution does not create cross-language conflicts.
- `npm` is bundled inside `nodejs` on conda-forge -- do not add it as a separate dependency.
- `cargo-watch` is not on conda-forge; install it manually with `cargo install cargo-watch` after activating the `rust` environment.

```toml
[workspace]
name        = "unified-reference-stack"
version     = "0.1.0"
description = "Polyglot monorepo: Python, Node.js, Rust, and Shell Scripts"
authors     = ["Kevin Mills <millsks@gmail.com>"]
channels    = ["conda-forge"]
platforms   = ["linux-64", "osx-arm64", "osx-64", "win-64"]

# ── Shared tooling — present in every environment ────────────
[dependencies]
git        = ">=2.40"
gh         = ">=2.50"
pre-commit = ">=3.6"
shellcheck = ">=0.9"
go-yq      = ">=4.40"

# jq has no win-64 conda-forge build; restrict to POSIX platforms
[target.linux-64.dependencies]
jq = ">=1.7"

[target.osx-64.dependencies]
jq = ">=1.7"

[target.osx-arm64.dependencies]
jq = ">=1.7"

# ── Workspace-level tasks ────────────────────────────────────
[tasks]
bootstrap          = "bash scripts/bootstrap.sh"
pre-commit-install = "pre-commit install"
pre-commit-run     = "pre-commit run --all-files"
lint-shell = "shellcheck scripts/*.sh"
lint-all   = { cmd = "bash scripts/lint-all.sh", depends-on = ["lint-shell"] }
docker-up    = "docker compose -f infra/docker-compose.yml up -d"
docker-down  = "docker compose -f infra/docker-compose.yml down"
docker-logs  = "docker compose -f infra/docker-compose.yml logs -f"
docker-ps    = "docker compose -f infra/docker-compose.yml ps"
docker-clean = "bash scripts/docker-clean.sh"
build-all    = { cmd = "docker buildx bake -f docker-bake.hcl", cwd = "infra" }
build-py   = { cmd = "docker build -t unified/py-service:dev .", cwd = "apps/py-service" }
build-node = { cmd = "docker build -t unified/node-api:dev .",   cwd = "apps/node-api"   }
build-rust = { cmd = "docker build -t unified/rust-cli:dev .",   cwd = "apps/rust-cli"   }
test-py   = "pixi run -e py-dev py-test"
test-node = "pixi run -e node node-test"
test-rust = "pixi run -e rust rust-test"
test-all  = { depends-on = ["test-py", "test-node", "test-rust"] }
ci = { depends-on = ["lint-all", "test-all"] }

# ── Features (abbreviated — see pixi.toml for full content) ──
[feature.py.dependencies]
python = ">=3.12,<3.14"

[feature.node.dependencies]
nodejs = ">=20,<23"

[feature.rust.dependencies]
rust = ">=1.78"

# ── Environments ─────────────────────────────────────────────
[environments]
default  = { features = [],                         solve-group = "default"  }
py       = { features = ["py"],                     solve-group = "py"       }
py-dev   = { features = ["py", "py-test", "py-lint"], solve-group = "py"    }
node     = { features = ["node"],                   solve-group = "node"     }
rust     = { features = ["rust"],                   solve-group = "rust"     }
hybrid   = { features = ["hybrid"],                 solve-group = "hybrid"   }
ci       = { features = ["ci"],                     solve-group = "ci"       }
security = { features = ["security"],               solve-group = "security" }
```

### Root `.pixi/config.toml`

Project-level Pixi configuration that overrides the global `~/.config/pixi/config.toml` for this
workspace only. Top-level scalar keys must appear **before** any `[section]` headers in TOML.

```toml
pinning-strategy = "semver"
tls-no-verify    = false

[shell]
change-ps1 = true
```

| Key                 | Purpose                                                           |
|---------------------|-------------------------------------------------------------------|
| `pinning-strategy`  | Constraint added by `pixi add` (`semver` = `>=x.y,<x+1`)          |
| `tls-no-verify`     | Set `true` only in air-gapped envs with self-signed certs         |
| `change-ps1`        | Prepends `(pixi:<env>)` to the shell prompt inside `pixi shell`   |

### Root `.gitignore`

```gitignore
# Pixi
.pixi/
*.egg-info/

# Docker
.docker/
*.tar

# Python
__pycache__/
*.pyc
.venv/
dist/
build/

# Node
node_modules/
.npm/

# Rust
target/

# OS
.DS_Store
Thumbs.db

# Secrets
.env
.env.local
*.pem
*.key
```

### Root `.dockerignore`

```dockerignore
# Pixi environments (rebuilt inside container)
.pixi/

# Version control
.git/
.github/

# Docs
docs/

# Other apps (each Dockerfile uses its own context)
apps/

# Dev artifacts
**/__pycache__/
**/*.pyc
**/node_modules/
**/target/
**/.env
```

---

## Documentation Structure

Docs are organized by concern under `docs/`, with a GitHub-discoverable entry point at
`.github/CONTRIBUTING.md`. App-level `README.md` files cover app-specific setup and runbooks.

```text
docs/
├── architecture/          # System design, ADRs, service topology
│   ├── overview.md        # High-level architecture and layout
│   ├── service-map.md     # Ports, Nginx routing, health endpoints
│   └── adr/               # Architecture Decision Records
│       └── 001-pixi-polyglot-monorepo.md
├── development/           # Developer workflow
│   ├── onboarding.md      # First-time setup and daily commands
│   ├── contributing.md    # Commit conventions, PR process, adding apps
│   └── style-guide.md     # Per-language formatting and lint rules
├── operations/            # Running and maintaining the stack
│   ├── docker-guide.md    # Building, running, pushing images
│   ├── monitoring.md      # Health checks, logs, observability
│   └── runbooks/          # Step-by-step operational procedures
│       ├── deploy.md
│       └── rollback.md
├── security/              # Security tooling and practices
│   ├── sbom-guide.md      # SBOM generation with syft
│   ├── secrets.md         # Secrets management across environments
│   └── scanning.md        # Trivy vuln and secret scanning
└── kb/                    # Knowledge base
    ├── pixi-cheatsheet.md # Quick-reference for all pixi commands
    ├── faq.md             # Common questions and known gotchas
    └── troubleshooting.md # Error patterns and their fixes
```

> **Note:** `CONTRIBUTING.md` lives at `.github/CONTRIBUTING.md` so GitHub surfaces it
> automatically on issues and pull requests. It links to `docs/development/contributing.md`
> for the full guide.

---

## Python Applications

### Directory Layout

```
apps/py-service/
+-- src/
|   +-- py_service/
|       +-- __init__.py
|       +-- main.py
|       +-- api/
|       +-- models/
+-- tests/
|   +-- test_main.py
+-- Dockerfile
+-- README.md
```

### `apps/py-service/Dockerfile`

```dockerfile
# ---- Stage 1: Build / install deps ----
FROM ghcr.io/prefix-dev/pixi:latest AS builder

WORKDIR /app

# Copy manifest and lock file first (layer cache)
COPY pixi.toml pixi.lock ./

# Install only production dependencies
RUN pixi install --frozen -e default

# Copy source
COPY src/ ./src/

# ---- Stage 2: Runtime ----
FROM python:3.12-slim AS runtime

WORKDIR /app

# Copy the resolved Pixi environment
COPY --from=builder /app/.pixi/envs/default /app/.pixi/envs/default
COPY --from=builder /app/src ./src

# Add the Pixi env to PATH
ENV PATH="/app/.pixi/envs/default/bin:$PATH"

EXPOSE 8000

CMD ["uvicorn", "py_service.main:app", "--host", "0.0.0.0", "--port", "8000"]
```

### `apps/py-service/src/py_service/main.py`

```python
from fastapi import FastAPI

app = FastAPI(title="py-service", version="0.1.0")

@app.get("/health")
async def health() -> dict:
    return {"status": "ok", "service": "py-service"}

@app.get("/")
async def root() -> dict:
    return {"message": "Hello from unified-reference-stack / py-service"}
```

---

## Node.js Applications

### Directory Layout

```
apps/node-api/
+-- src/
|   +-- index.js
|   +-- routes/
+-- Dockerfile
+-- package.json
+-- README.md
```

### `apps/node-api/Dockerfile`

```dockerfile
# ---- Stage 1: Install dependencies ----
FROM node:20-alpine AS deps

WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --omit=dev

# ---- Stage 2: Runtime ----
FROM node:20-alpine AS runtime

WORKDIR /app

COPY --from=deps /app/node_modules ./node_modules
COPY src/ ./src/
COPY package.json ./

EXPOSE 3000

CMD ["node", "src/index.js"]
```

### `apps/node-api/src/index.js`

```javascript
const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());

app.get('/health', (req, res) => {
  res.json({ status: 'ok', service: 'node-api' });
});

app.get('/', (req, res) => {
  res.json({ message: 'Hello from unified-reference-stack / node-api' });
});

app.listen(PORT, () => {
  console.log(`node-api listening on port ${PORT}`);
});
```

---

## Rust Applications

### Directory Layout

```
apps/rust-cli/
+-- src/
|   +-- main.rs
+-- Dockerfile
+-- Cargo.toml
+-- README.md
```

### `apps/rust-cli/Dockerfile`

```dockerfile
# ---- Stage 1: Build ----
FROM rust:1.78-slim AS builder

WORKDIR /app

# Cache dependencies layer
COPY Cargo.toml Cargo.lock ./
RUN mkdir src && echo "fn main() {}" > src/main.rs
RUN cargo build --release
RUN rm -f target/release/deps/rust_cli*

# Build actual source
COPY src/ ./src/
RUN cargo build --release

# ---- Stage 2: Minimal runtime ----
FROM debian:bookworm-slim AS runtime

WORKDIR /app

COPY --from=builder /app/target/release/rust-cli ./rust-cli

CMD ["./rust-cli"]
```

### `apps/rust-cli/src/main.rs`

```rust
fn main() {
    println!("Hello from unified-reference-stack / rust-cli");
}
```

---

## Shell Scripts

### Directory Layout

```
scripts/
+-- bootstrap.sh      # Clone + first-time setup
+-- lint-all.sh       # Run linters across all apps
+-- docker-clean.sh   # Prune containers, images, volumes
```

### `scripts/bootstrap.sh`

```bash
#!/usr/bin/env bash
set -euo pipefail

echo "==> unified-reference-stack bootstrap"

# Install pre-commit hooks
pixi run pre-commit-install

# Install all environments defined in the root pixi.toml
pixi install --all

echo "==> Bootstrap complete."
```

### `scripts/docker-clean.sh`

```bash
#!/usr/bin/env bash
set -euo pipefail

echo "==> Stopping all Compose services..."
docker compose -f infra/docker-compose.yml down --remove-orphans

echo "==> Pruning stopped containers..."
docker container prune -f

echo "==> Pruning dangling images..."
docker image prune -f

echo "==> Pruning unused volumes (dry-run -- remove -n to confirm)..."
docker volume prune -n

echo "==> Done."
```

### `scripts/lint-all.sh`

```bash
#!/usr/bin/env bash
set -euo pipefail

echo "==> Linting shell scripts..."
shellcheck scripts/*.sh

echo "==> Linting Python..."
pixi run -e py-dev py-lint

echo "==> Linting Node.js..."
pixi run -e node node-lint

echo "==> Linting Rust..."
pixi run -e rust rust-lint

echo "==> All linters passed."
```

---

## Hybrid Stack Applications

### Directory Layout

```
apps/hybrid-app/
+-- backend/
|   +-- src/
+-- frontend/
|   +-- src/
|   +-- package.json
+-- Dockerfile.backend
+-- Dockerfile.frontend
+-- docker-compose.yml   # App-level Compose
+-- README.md
```

### `apps/hybrid-app/Dockerfile.backend`

```dockerfile
FROM ghcr.io/prefix-dev/pixi:latest AS builder
WORKDIR /app
COPY pixi.toml pixi.lock ./
RUN pixi install --frozen -e hybrid
COPY backend/ ./backend/

FROM python:3.12-slim AS runtime
WORKDIR /app
COPY --from=builder /app/.pixi/envs/default /app/.pixi/envs/default
COPY --from=builder /app/src ./src
ENV PATH="/app/.pixi/envs/default/bin:$PATH"
EXPOSE 8000
CMD ["uvicorn", "backend.main:app", "--host", "0.0.0.0", "--port", "8000"]
```

### `apps/hybrid-app/Dockerfile.frontend`

```dockerfile
# ---- Stage 1: Build ----
FROM node:20-alpine AS builder
WORKDIR /app
COPY frontend/package.json frontend/package-lock.json ./
RUN npm ci
COPY frontend/src ./src
RUN npm run build

# ---- Stage 2: Serve with nginx ----
FROM nginx:alpine AS runtime
COPY --from=builder /app/dist /usr/share/nginx/html
COPY infra/nginx/nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
```

### `apps/hybrid-app/docker-compose.yml`

```yaml
version: "3.9"

services:
  backend:
    build:
      context: .
      dockerfile: Dockerfile.backend
    ports:
      - "8000:8000"
    environment:
      - DATABASE_URL=postgresql://user:pass@db:5432/appdb
    depends_on:
      db:
        condition: service_healthy

  frontend:
    build:
      context: .
      dockerfile: Dockerfile.frontend
    ports:
      - "80:80"
    depends_on:
      - backend

  db:
    image: postgres:16-alpine
    environment:
      POSTGRES_USER: user
      POSTGRES_PASSWORD: pass
      POSTGRES_DB: appdb
    volumes:
      - pgdata:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U user -d appdb"]
      interval: 5s
      timeout: 5s
      retries: 5

volumes:
  pgdata:
```

---

## Docker & Containerized Stacks

### Dockerfile Best Practices

| Practice                  | Why                                                        |
|---------------------------|------------------------------------------------------------|
| Multi-stage builds        | Separate build tools from runtime -- smaller final image   |
| Pin base image digests    | Reproducible builds (e.g. `python:3.12-slim@sha256:...`)  |
| `.dockerignore`           | Exclude `.pixi/`, `node_modules/`, `.git/` from context   |
| Non-root user             | Security -- run as `appuser`, not `root`                   |
| `COPY` before `RUN`       | Maximize layer cache hits                                  |
| `--frozen` Pixi installs  | Ensures lock file is respected inside container            |
| Health checks             | Enable Compose `depends_on: condition: service_healthy`    |

### Adding a Non-Root User (Python Example)

```dockerfile
FROM python:3.12-slim AS runtime

RUN addgroup --system appgroup && adduser --system --ingroup appgroup appuser

WORKDIR /app
COPY --from=builder /app/.pixi/envs/default /app/.pixi/envs/default
COPY --from=builder /app/src ./src

RUN chown -R appuser:appgroup /app
USER appuser

ENV PATH="/app/.pixi/envs/default/bin:$PATH"
EXPOSE 8000
CMD ["uvicorn", "py_service.main:app", "--host", "0.0.0.0", "--port", "8000"]
```

### Environment Variables and Secrets

Use `.env` files for local development -- never commit them:

```bash
# .env (gitignored)
DATABASE_URL=postgresql://user:pass@localhost:5432/appdb
SECRET_KEY=dev-only-secret
REDIS_URL=redis://localhost:6379
```

Reference in Compose:

```yaml
services:
  backend:
    env_file:
      - .env
```

For production, use Docker secrets or a secrets manager (Vault, AWS Secrets Manager):

```yaml
services:
  backend:
    secrets:
      - db_password
secrets:
  db_password:
    external: true
```

### Multi-Platform Builds

```bash
# Set up buildx builder
docker buildx create --name multi --use

# Build for linux/amd64 and linux/arm64
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t ghcr.io/your-org/unified-reference-stack/py-service:latest \
  --push \
  apps/py-service/
```

---

## Docker Compose Orchestration

### Root-Level `infra/docker-compose.yml`

This file wires all services in the monorepo into a single stack:

```yaml
version: "3.9"

services:

  # ---- Python Service ----
  py-service:
    build:
      context: ../apps/py-service
      dockerfile: Dockerfile
    image: unified/py-service:dev
    ports:
      - "8000:8000"
    environment:
      - DATABASE_URL=postgresql://user:pass@postgres:5432/appdb
    depends_on:
      postgres:
        condition: service_healthy
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8000/health"]
      interval: 10s
      timeout: 5s
      retries: 3

  # ---- Node.js API ----
  node-api:
    build:
      context: ../apps/node-api
      dockerfile: Dockerfile
    image: unified/node-api:dev
    ports:
      - "3000:3000"
    environment:
      - PORT=3000
    healthcheck:
      test: ["CMD", "wget", "-qO-", "http://localhost:3000/health"]
      interval: 10s
      timeout: 5s
      retries: 3

  # ---- Nginx Reverse Proxy ----
  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/conf.d/default.conf:ro
    depends_on:
      - py-service
      - node-api

  # ---- PostgreSQL ----
  postgres:
    image: postgres:16-alpine
    environment:
      POSTGRES_USER: user
      POSTGRES_PASSWORD: pass
      POSTGRES_DB: appdb
    volumes:
      - pgdata:/var/lib/postgresql/data
      - ./postgres/init.sql:/docker-entrypoint-initdb.d/init.sql:ro
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U user -d appdb"]
      interval: 5s
      timeout: 5s
      retries: 5

  # ---- Redis ----
  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 5s
      timeout: 3s
      retries: 5

volumes:
  pgdata:

networks:
  default:
    name: unified-stack
```

### `infra/docker-compose.override.yml` (Dev Overrides)

```yaml
version: "3.9"

services:
  py-service:
    volumes:
      - ../apps/py-service/src:/app/src   # hot reload
    command: uvicorn py_service.main:app --host 0.0.0.0 --port 8000 --reload

  node-api:
    volumes:
      - ../apps/node-api/src:/app/src     # hot reload
    command: npx nodemon src/index.js
```

### `infra/nginx/nginx.conf`

```nginx
upstream py_service {
    server py-service:8000;
}

upstream node_api {
    server node-api:3000;
}

server {
    listen 80;

    location /api/py/ {
        proxy_pass http://py_service/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }

    location /api/node/ {
        proxy_pass http://node_api/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }

    location / {
        root /usr/share/nginx/html;
        try_files $uri $uri/ /index.html;
    }
}
```

### `infra/docker-bake.hcl` (Parallel Multi-Platform Builds)

```hcl
group "default" {
  targets = ["py-service", "node-api", "rust-cli"]
}

target "py-service" {
  context    = "../apps/py-service"
  dockerfile = "Dockerfile"
  tags       = ["ghcr.io/your-org/unified-reference-stack/py-service:latest"]
  platforms  = ["linux/amd64", "linux/arm64"]
}

target "node-api" {
  context    = "../apps/node-api"
  dockerfile = "Dockerfile"
  tags       = ["ghcr.io/your-org/unified-reference-stack/node-api:latest"]
  platforms  = ["linux/amd64", "linux/arm64"]
}

target "rust-cli" {
  context    = "../apps/rust-cli"
  dockerfile = "Dockerfile"
  tags       = ["ghcr.io/your-org/unified-reference-stack/rust-cli:latest"]
  platforms  = ["linux/amd64", "linux/arm64"]
}
```

---

## Pixi Tasks & Environments

### Task Anatomy

```toml
[tasks]
# Simple command
test = "pytest tests/ -v"

# With working directory
frontend-build = { cmd = "npm run build", cwd = "frontend" }

# With dependencies (run in order)
ci = { cmd = "pytest tests/ -v", depends-on = ["lint", "format"] }

# With environment variables
serve = { cmd = "uvicorn main:app", env = { PORT = "8000", DEBUG = "false" } }
```

### Multi-Environment Pattern

```toml
[feature.test.dependencies]
pytest = ">=8.0"
pytest-cov = ">=5.0"

[feature.test.tasks]
test     = "pytest tests/ -v"
coverage = "pytest tests/ --cov=src --cov-report=html"

[feature.lint.dependencies]
ruff = ">=0.4"
mypy = ">=1.10"

[feature.lint.tasks]
lint   = "ruff check src/"
typecheck = "mypy src/"

[environments]
default = { features = [], solve-group = "default" }
test    = { features = ["test"], solve-group = "default" }
lint    = { features = ["lint"], solve-group = "default" }
ci      = { features = ["test", "lint"], solve-group = "default" }
```

### Running Tasks

```bash
# Default environment
pixi run test

# Specific environment
pixi run -e ci test

# From repo root, targeting a specific app environment
pixi run -e py-dev py-coverage

# Root-level Docker tasks
pixi run docker-up
pixi run docker-logs
pixi run docker-down
```

---

## Security & SBOM

The `security` environment bundles [syft](https://github.com/anchore/syft) and
[trivy](https://github.com/aquasecurity/trivy) for SBOM generation, secret scanning, and
vulnerability auditing. All output files land in `sbom/` and are formatted with `jq`.

> **Note:** `cyclonedx-cli` (.NET validator) and `gitleaks` are not on conda-forge.
> `trivy` covers both roles: `--scanners secret` for leak detection, `--scanners vuln` for CVEs.
> `syft` and `trivy` produce spec-compliant CycloneDX 1.6 JSON natively.

### Activate the security environment

```bash
pixi install -e security
pixi shell -e security
```

### SBOM generation

`syft` scans a resolved `.pixi/envs/<env>` directory and writes a CycloneDX 1.6 JSON file.
`jq` then formats it in-place via a temp-file swap (syft does not support pretty-printing to stdout
with the `=<file>` argument syntax).

```bash
# Install the target environment first, then scan it
pixi install -e rust
pixi run -e security sbom-rust        # → sbom/rust.cdx.json (pretty-printed)

pixi install -e py
pixi run -e security sbom-py          # → sbom/py.cdx.json

pixi run -e security sbom-all         # default + py + node + rust
```

### Secret scanning

```bash
pixi run -e security scan-secrets     # trivy --scanners secret; exits non-zero if secrets found
```

### Vulnerability scan

```bash
pixi run -e security scan-vulns       # → sbom/trivy-vuln.cdx.json (CycloneDX, pretty-printed)
```

### Full security gate

```bash
pixi run -e security security-full    # sbom-all + scan-secrets + scan-vulns
```

### Available security tasks

| Task             | What it does                                                    |
|------------------|-----------------------------------------------------------------|
| `sbom-dirs`      | Creates the `sbom/` output directory (idempotent)               |
| `sbom-default`   | SBOM of `.pixi/envs/default` -> `sbom/default.cdx.json`        |
| `sbom-py`        | SBOM of `.pixi/envs/py` -> `sbom/py.cdx.json`                  |
| `sbom-node`      | SBOM of `.pixi/envs/node` -> `sbom/node.cdx.json`              |
| `sbom-rust`      | SBOM of `.pixi/envs/rust` -> `sbom/rust.cdx.json`              |
| `sbom-all`       | Runs all four `sbom-*` tasks                                    |
| `scan-secrets`   | `trivy fs . --scanners secret` (table output)                   |
| `scan-vulns`     | `trivy fs . --scanners vuln` -> `sbom/trivy-vuln.cdx.json`     |
| `security-full`  | Runs `sbom-all` + `scan-secrets` + `scan-vulns`                 |

---

## CI/CD Integration

### `.github/workflows/ci.yml`

```yaml
name: CI

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: prefix-dev/setup-pixi@v0.8.1
        with:
          pixi-version: latest
          cache: true
      - name: Lint all
        run: pixi run lint-all

  test-python:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: prefix-dev/setup-pixi@v0.8.1
        with:
          pixi-version: latest
          cache: true
          environments: py-dev
      - run: pixi run -e py-dev py-test

  test-node:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: prefix-dev/setup-pixi@v0.8.1
        with:
          pixi-version: latest
          cache: true
          environments: node
      - run: pixi run -e node node-test

  test-rust:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: prefix-dev/setup-pixi@v0.8.1
        with:
          pixi-version: latest
          cache: true
          environments: rust
      - run: pixi run -e rust rust-test

  docker-build:
    runs-on: ubuntu-latest
    needs: [lint, test-python, test-node, test-rust]
    steps:
      - uses: actions/checkout@v4
      - uses: docker/setup-buildx-action@v3
      - name: Build all images
        run: docker buildx bake -f infra/docker-bake.hcl --load
```

### `.github/workflows/docker-publish.yml`

```yaml
name: Publish Docker Images

on:
  push:
    tags: ["v*.*.*"]

env:
  REGISTRY: ghcr.io
  ORG: your-org

jobs:
  publish:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      packages: write

    steps:
      - uses: actions/checkout@v4

      - name: Log in to GHCR
        uses: docker/login-action@v3
        with:
          registry: ${{ env.REGISTRY }}
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}

      - uses: docker/setup-buildx-action@v3

      - name: Build and push all images
        run: |
          docker buildx bake \
            -f infra/docker-bake.hcl \
            --push
```

---

## Best Practices

### Pixi

| Practice                        | Recommendation                                              |
|---------------------------------|-------------------------------------------------------------|
| Commit `pixi.lock`              | Ensures reproducible installs across all machines and CI    |
| Use `--frozen` in CI/Docker     | Prevents accidental lock file updates                       |
| Separate features per concern   | `test`, `lint`, `dev` -- keep prod env lean                 |
| Use `depends-on` for task chains| Avoid shell `&&` -- Pixi handles cross-platform ordering    |
| Pin channels                    | Use `conda-forge` as the primary channel                    |

### Docker

| Practice                        | Recommendation                                              |
|---------------------------------|-------------------------------------------------------------|
| Multi-stage builds              | Always separate build and runtime stages                    |
| Pin base image tags             | Use `python:3.12-slim`, not `python:latest`                 |
| Non-root user                   | Add `appuser` in runtime stage                              |
| Health checks                   | Required for `depends_on: condition: service_healthy`       |
| `.dockerignore`                 | Exclude `.pixi/`, `node_modules/`, `.git/`                  |
| Layer ordering                  | `COPY` manifests first, then source (maximize cache)        |
| Use `docker-compose.override`   | Keep dev-only mounts/commands out of the main Compose file  |

### Monorepo

| Practice                        | Recommendation                                              |
|---------------------------------|-------------------------------------------------------------|
| Single root `pixi.toml`         | One manifest; per-language features keep graphs isolated    |
| Root tasks target named envs    | `pixi run -e py-dev py-test` keeps CI consistent with local |
| Path filters in CI              | Only run jobs for changed apps (use `dorny/paths-filter`)   |
| Conventional commits            | `feat(py-service):`, `fix(node-api):`, `chore(infra):`      |
| Shared scripts in `/scripts`    | Avoid duplicating bootstrap/lint logic across apps          |

---

## Cheat Sheet

### Pixi

```bash
pixi init .                        # Initialize a new pixi.toml
pixi install                       # Install all environments
pixi install --frozen              # Install without updating lock file
pixi run <task>                    # Run a task in default environment
pixi run -e <env> <task>           # Run a task in a specific environment
pixi add <pkg>                     # Add a conda package
pixi add --pypi <pkg>              # Add a PyPI package
pixi add --feature <feat> <pkg>    # Add to a named feature
pixi shell                         # Activate the default environment
pixi shell -e <env>                # Activate a specific environment
pixi list                          # List installed packages
pixi update                        # Update all packages + regenerate lock
```

### Docker

```bash
docker build -t <name>:<tag> .              # Build an image
docker run --rm -p 8000:8000 <name>:<tag>   # Run a container
docker compose up -d                        # Start all services (detached)
docker compose down                         # Stop and remove containers
docker compose logs -f <service>            # Tail logs for a service
docker compose ps                           # List running services
docker compose build --no-cache             # Rebuild without cache
docker buildx bake -f docker-bake.hcl      # Build all images in parallel
docker image prune -f                       # Remove dangling images
docker system prune -af                     # Full cleanup (use with care)
```

### Root Pixi Tasks (from repo root)

```bash
pixi run bootstrap      # First-time setup
pixi run lint-all       # Lint all apps
pixi run docker-up      # Start full stack
pixi run docker-down    # Stop full stack
pixi run docker-logs    # Tail all logs
pixi run docker-clean   # Prune containers + images
pixi run build-all      # Build all Docker images via bake
```
