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
