# Docker Guide

## Prerequisites

- Docker Desktop >= 24 (or Docker Engine + Compose plugin)
- `docker buildx` for multi-platform builds

## Building images locally

```bash
# Single app
pixi run build-py
pixi run build-node
pixi run build-rust

# All apps in parallel (uses docker-bake.hcl)
pixi run build-all
```

## Running the full stack

```bash
# Start all services (detached)
pixi run docker-up

# Tail logs
pixi run docker-logs

# Check service status
pixi run docker-ps

# Stop everything
pixi run docker-down

# Prune containers + dangling images
pixi run docker-clean
```

## Environment variables

Use a `.env` file at the repo root for local development (it is gitignored):

```bash
# .env
DATABASE_URL=postgresql://user:pass@localhost:5432/appdb
SECRET_KEY=dev-only-secret
REDIS_URL=redis://localhost:6379
```

Reference in `docker-compose.override.yml` via `env_file: [.env]`.

## Secrets management

| Environment  | Mechanism                            |
|--------------|--------------------------------------|
| Local dev    | `.env` file (gitignored)             |
| CI           | GitHub Actions secrets               |
| Production   | Docker secrets / Vault / AWS SSM     |

## Multi-platform builds

```bash
# Set up a buildx builder (one-time)
docker buildx create --name multi --use

# Build and push all images for amd64 + arm64
docker buildx bake -f infra/docker-bake.hcl --push
```

## Pushing to GHCR

```bash
echo $GITHUB_TOKEN | docker login ghcr.io -u millsks --password-stdin
docker buildx bake -f infra/docker-bake.hcl --push
```

## Troubleshooting

| Problem                          | Fix                                           |
|----------------------------------|-----------------------------------------------|
| Port already in use              | `docker compose ps` to find the conflict      |
| Image not found                  | Run `pixi run build-all` first                |
| DB connection refused            | Wait for postgres healthcheck to pass         |
| Stale node_modules in container  | Rebuild with `docker compose build --no-cache`|
