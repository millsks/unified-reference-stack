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
