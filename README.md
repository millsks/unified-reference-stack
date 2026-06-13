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
16. [CI/CD Integration](#cicd-integration)
17. [Best Practices](#best-practices)
18. [Cheat Sheet](#cheat-sheet)

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
- **Declarative `pixi.toml`**: A single manifest per app defines dependencies, tasks, and environments.
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
|   |   +-- pixi.toml
|   |   +-- README.md
|   |
|   +-- node-api/            # Node.js Express API
|   |   +-- src/
|   |   +-- Dockerfile
|   |   +-- pixi.toml
|   |   +-- package.json
|   |   +-- README.md
|   |
|   +-- rust-cli/            # Rust CLI tool
|   |   +-- src/
|   |   +-- Dockerfile
|   |   +-- pixi.toml
|   |   +-- Cargo.toml
|   |   +-- README.md
|   |
|   +-- hybrid-app/          # Python backend + Node.js frontend
|       +-- backend/
|       +-- frontend/
|       +-- Dockerfile.backend
|       +-- Dockerfile.frontend
|       +-- docker-compose.yml
|       +-- pixi.toml
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
|   +-- architecture.md
|   +-- contributing.md
|   +-- docker-guide.md
|   +-- onboarding.md
|   +-- style-guide.md
|
+-- .github/
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

```toml
[workspace]
name = "unified-reference-stack"
version = "0.1.0"
description = "Polyglot monorepo with Python, Node.js, Rust, and containerized stacks"
channels = ["conda-forge"]
platforms = ["linux-64", "osx-arm64", "osx-64", "win-64"]

[dependencies]
# Shared dev tooling available in all environments
git = ">=2.40"
pre-commit = ">=3.6"
shellcheck = ">=0.9"
docker-compose = ">=2.24"   # docker compose CLI via conda-forge
jq = ">=1.7"
yq = ">=4.40"

[tasks]
# Workspace-level tasks
bootstrap   = "bash scripts/bootstrap.sh"
lint-all    = "bash scripts/lint-all.sh"
pre-commit  = "pre-commit run --all-files"

# Docker convenience tasks
docker-up   = "docker compose -f infra/docker-compose.yml up -d"
docker-down = "docker compose -f infra/docker-compose.yml down"
docker-logs = "docker compose -f infra/docker-compose.yml logs -f"
docker-ps   = "docker compose -f infra/docker-compose.yml ps"
docker-clean = "bash scripts/docker-clean.sh"

# Build all images
build-all   = { cmd = "docker buildx bake", cwd = "infra" }
```

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

Documentation lives at two levels:

- **Top-level (`/docs`)** -- architecture, contributing guides, style guides, onboarding, Docker guide
- **App-level (`/apps/<app>/README.md`)** -- app-specific setup, API references, runbooks, container notes

### `/docs/docker-guide.md` Outline

```markdown
# Docker Guide

## Prerequisites
## Building Images Locally
## Running the Full Stack
## Environment Variables
## Secrets Management
## Multi-platform Builds
## Pushing to GHCR
## Troubleshooting
```

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
+-- pixi.toml
+-- README.md
```

### `apps/py-service/pixi.toml`

```toml
[workspace]
name = "py-service"
version = "0.1.0"
channels = ["conda-forge"]
platforms = ["linux-64", "osx-arm64", "osx-64"]

[dependencies]
python = ">=3.12"

[pypi-dependencies]
fastapi = ">=0.111"
uvicorn = { version = ">=0.29", extras = ["standard"] }
pydantic = ">=2.7"

[tasks]
start   = "uvicorn py_service.main:app --host 0.0.0.0 --port 8000"
dev     = "uvicorn py_service.main:app --reload --port 8000"
test    = "pytest tests/ -v"
lint    = "ruff check src/ tests/"
format  = "ruff format src/ tests/"
# Docker tasks
build   = "docker build -t unified/py-service:dev ."
run-container = "docker run --rm -p 8000:8000 unified/py-service:dev"

[feature.test.dependencies]
pytest = ">=8.0"
pytest-asyncio = ">=0.23"
httpx = ">=0.27"

[feature.lint.dependencies]
ruff = ">=0.4"

[environments]
default = { features = [], solve-group = "default" }
test    = { features = ["test"], solve-group = "default" }
lint    = { features = ["lint"], solve-group = "default" }
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
+-- pixi.toml
+-- package.json
+-- README.md
```

### `apps/node-api/pixi.toml`

```toml
[workspace]
name = "node-api"
version = "0.1.0"
channels = ["conda-forge"]
platforms = ["linux-64", "osx-arm64", "osx-64"]

[dependencies]
nodejs = ">=20"
npm    = ">=10"

[tasks]
install = "npm ci"
start   = { cmd = "node src/index.js", depends-on = ["install"] }
dev     = { cmd = "npx nodemon src/index.js", depends-on = ["install"] }
test    = { cmd = "npm test", depends-on = ["install"] }
lint    = { cmd = "npx eslint src/", depends-on = ["install"] }
# Docker tasks
build   = "docker build -t unified/node-api:dev ."
run-container = "docker run --rm -p 3000:3000 unified/node-api:dev"

[feature.dev.dependencies]
nodejs = ">=20"

[environments]
default = { features = [], solve-group = "default" }
dev     = { features = ["dev"], solve-group = "default" }
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
+-- pixi.toml
+-- Cargo.toml
+-- README.md
```

### `apps/rust-cli/pixi.toml`

```toml
[workspace]
name = "rust-cli"
version = "0.1.0"
channels = ["conda-forge"]
platforms = ["linux-64", "osx-arm64", "osx-64"]

[dependencies]
rust = ">=1.78"

[tasks]
build   = "cargo build --release"
run     = "cargo run"
test    = "cargo test"
lint    = "cargo clippy -- -D warnings"
format  = "cargo fmt"
clean   = "cargo clean"
# Docker tasks
docker-build = "docker build -t unified/rust-cli:dev ."
docker-run   = "docker run --rm unified/rust-cli:dev"

[feature.dev.dependencies]
rust = ">=1.78"
cargo-watch = "*"

[feature.dev.tasks]
watch = "cargo-watch -x run"

[environments]
default = { features = [], solve-group = "default" }
dev     = { features = ["dev"], solve-group = "default" }
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
pixi run pre-commit install

# Install app-level dependencies
for app in apps/*/; do
  if [ -f "$app/pixi.toml" ]; then
    echo "==> Installing: $app"
    (cd "$app" && pixi install)
  fi
done

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
(cd apps/py-service && pixi run -e lint lint)

echo "==> Linting Node.js..."
(cd apps/node-api && pixi run lint)

echo "==> Linting Rust..."
(cd apps/rust-cli && pixi run lint)

echo "==> All linters passed."
```

---

## Hybrid Stack Applications

### Directory Layout

```
apps/hybrid-app/
+-- backend/
|   +-- src/
|   +-- pixi.toml        # Python deps
+-- frontend/
|   +-- src/
|   +-- package.json
+-- Dockerfile.backend
+-- Dockerfile.frontend
+-- docker-compose.yml   # App-level Compose
+-- pixi.toml            # Orchestrates both stacks
+-- README.md
```

### `apps/hybrid-app/pixi.toml`

```toml
[workspace]
name = "hybrid-app"
version = "0.1.0"
channels = ["conda-forge"]
platforms = ["linux-64", "osx-arm64", "osx-64"]

[dependencies]
python = ">=3.12"
nodejs = ">=20"
npm    = ">=10"

[pypi-dependencies]
fastapi  = ">=0.111"
uvicorn  = { version = ">=0.29", extras = ["standard"] }

[tasks]
# Backend
backend-dev  = { cmd = "uvicorn backend.main:app --reload --port 8000", cwd = "backend" }
backend-test = { cmd = "pytest tests/ -v", cwd = "backend" }

# Frontend
frontend-install = { cmd = "npm ci", cwd = "frontend" }
frontend-dev     = { cmd = "npm run dev", cwd = "frontend", depends-on = ["frontend-install"] }
frontend-build   = { cmd = "npm run build", cwd = "frontend", depends-on = ["frontend-install"] }

# Docker Compose
up    = "docker compose up -d"
down  = "docker compose down"
logs  = "docker compose logs -f"
build = "docker compose build"
```

### `apps/hybrid-app/Dockerfile.backend`

```dockerfile
FROM ghcr.io/prefix-dev/pixi:latest AS builder
WORKDIR /app
COPY backend/pixi.toml backend/pixi.lock ./
RUN pixi install --frozen -e default
COPY backend/src ./src

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

# From repo root, targeting a specific app
(cd apps/py-service && pixi run -e test coverage)

# Root-level Docker tasks
pixi run docker-up
pixi run docker-logs
pixi run docker-down
```

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
    defaults:
      run:
        working-directory: apps/py-service
    steps:
      - uses: actions/checkout@v4
      - uses: prefix-dev/setup-pixi@v0.8.1
        with:
          pixi-version: latest
          cache: true
          manifest-path: apps/py-service/pixi.toml
      - run: pixi run -e test test

  test-node:
    runs-on: ubuntu-latest
    defaults:
      run:
        working-directory: apps/node-api
    steps:
      - uses: actions/checkout@v4
      - uses: prefix-dev/setup-pixi@v0.8.1
        with:
          pixi-version: latest
          cache: true
          manifest-path: apps/node-api/pixi.toml
      - run: pixi run test

  test-rust:
    runs-on: ubuntu-latest
    defaults:
      run:
        working-directory: apps/rust-cli
    steps:
      - uses: actions/checkout@v4
      - uses: prefix-dev/setup-pixi@v0.8.1
        with:
          pixi-version: latest
          cache: true
          manifest-path: apps/rust-cli/pixi.toml
      - run: pixi run test

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
| One `pixi.toml` per app         | Keeps dependency graphs isolated                            |
| Root `pixi.toml` for tooling    | Shared linters, Docker CLI, pre-commit                      |
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
