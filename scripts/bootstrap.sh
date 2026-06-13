#!/usr/bin/env bash
set -euo pipefail

echo "==> unified-reference-stack bootstrap"

# Install pre-commit hooks
pixi run pre-commit-install

# Install all environments defined in the root pixi.toml
pixi install --all

echo "==> Bootstrap complete."
