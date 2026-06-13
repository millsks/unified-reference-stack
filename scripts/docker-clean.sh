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
