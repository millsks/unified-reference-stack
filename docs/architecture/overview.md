# Architecture Overview

The unified-reference-stack is a polyglot monorepo demonstrating how to manage multiple
language runtimes, shared tooling, containerization, and CI/CD in a single repository.

For service ports, network topology, and Nginx routing rules see [service-map.md](service-map.md).
For the rationale behind key design choices see [adr/](adr/).

## Repository layout

```text
unified-reference-stack/
├── apps/
│   ├── py-service/        # Python FastAPI service
│   ├── node-api/          # Node.js Express API
│   ├── rust-cli/          # Rust CLI tool
│   └── hybrid-app/        # Python backend + Node.js (Vite) frontend
├── infra/                 # Docker Compose, Nginx, Postgres, docker-bake.hcl
├── scripts/               # Shared shell utilities
├── docs/                  # Structured documentation (you are here)
├── .github/workflows/     # CI/CD pipelines
├── pixi.toml              # Root workspace manifest
└── pixi.lock              # Pinned lock file (committed)
```

## Language runtimes

| App        | Language      | Framework        | Port          |
|------------|---------------|------------------|---------------|
| py-service | Python        | FastAPI          | 8000          |
| node-api   | Node.js       | Express          | 3000          |
| rust-cli   | Rust          | (binary CLI)     | N/A           |
| hybrid-app | Python + Node | FastAPI + Vite   | 8000 / 5173   |

## Dependency management

[Pixi](https://pixi.sh) manages all language runtimes and shared tooling via a single
`pixi.toml` at the root. Each app also carries its own `pixi.toml` for isolated resolution.

| Layer             | Mechanism                                                  |
|-------------------|------------------------------------------------------------|
| Shared tooling    | Root `[dependencies]` - present in every environment       |
| Per-language deps | `[feature.<lang>.*]` blocks composed into environments     |
| Solve isolation   | `solve-group` per language prevents cross-lang conflicts   |
| PyPI packages     | `[feature.*.pypi-dependencies]` resolved via uv            |

See [ADR 001](adr/001-pixi-polyglot-monorepo.md) for why Pixi was chosen over alternatives.

## Service communication

In the full Docker Compose stack (`infra/docker-compose.yml`), Nginx acts as the reverse proxy:

```text
Client
  └─► Nginx :80
        ├─► /api/py/   ──► py-service :8000
        └─► /api/node/ ──► node-api   :3000
```

PostgreSQL (:5432) and Redis (:6379) are internal-only; no host port exposure in production.

## Security posture

| Control                | Implementation                                          |
|------------------------|---------------------------------------------------------|
| Non-root containers    | `appuser` in every runtime Dockerfile stage             |
| Minimal images         | Multi-stage builds strip build tools from runtime image |
| SBOM generation        | `syft` per environment, CycloneDX 1.6 JSON output       |
| Vulnerability scanning | `trivy fs --scanners vuln`                              |
| Secret scanning        | `trivy fs --scanners secret`                            |

See [../security/](../security/) for full details.
