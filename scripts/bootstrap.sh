#!/usr/bin/env bash
set -euo pipefail

echo "==> unified-reference-stack bootstrap"

# Install pre-commit hooks
pixi run pre-commit-install

# Install app-level dependencies
for app in apps/*/; do
  if [ -f "${app}pixi.toml" ]; then
    echo "==> Installing: ${app}"
    (cd "${app}" && pixi install)
  fi
done

echo "==> Bootstrap complete."
