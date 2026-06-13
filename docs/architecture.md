# Architecture

## Overview

The unified-reference-stack is a polyglot monorepo demonstrating how to manage multiple
language runtimes, shared tooling, containerization, and CI/CD in a single repository.

```
unified-reference-stack/
├── apps/              # Application services
│   ├── py-service/    # Python FastAPI service
│   ├── node-api/      # Node.js Express API
│   ├── rust-cli/      # Rust CLI tool
│   └── hybrid-app/    # Python backend + Node.js frontend
├── infra/             # Infrastructure (Compose, Nginx, Postgres)
├── scripts/           # Shared shell utilities
├── docs/              # Documentation
├── .github/workflows/ # CI/CD pipelines
├── pixi.toml          # Root workspace manifest
└── pixi.lock          # Pinned dependency lock file
```

## Language Runtimes

| App         | Language | Framework    | Port |
|-------------|----------|--------------|------|
| py-service  | Python   | FastAPI      | 8000 |
| node-api    | Node.js  | Express      | 3000 |
| rust-cli    | Rust     | Clap (CLI)   | N/A  |
| hybrid-app  | Py + Node| FastAPI+Vite | 8001 |

## Dependency Management

[Pixi](https://pixi.sh) manages all language runtimes and shared tooling via a single
`pixi.toml` at the root. Each app also has its own `pixi.toml` for app-level isolation.

- **Shared tools** (in every environment): `git`, `gh`, `pre-commit`, `shellcheck`, `go-yq`, `jq`
- **Per-language features**: `py`, `node`, `rust`, `hybrid`
- **Solve groups**: each language group resolves independently to avoid cross-language conflicts

## Service Communication

In the full Docker Compose stack, Nginx routes traffic:

```
Client --> Nginx :80
              ├── /api/py/  --> py-service :8000
              └── /api/node/ --> node-api :3000
```

## Security Posture

- All Docker images use non-root users (`appuser`)
- Multi-stage builds minimize attack surface
- SBOMs generated via `syft` for each environment
- Vulnerability scanning via `trivy`
- Secret scanning via `trivy --scanners secret`
