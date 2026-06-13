# hybrid-app

Python (FastAPI) backend + Node.js (Vite) frontend — part of the unified-reference-stack.

## Structure

```
hybrid-app/
├── backend/          # FastAPI app (Python package)
│   ├── __init__.py
│   └── main.py
├── frontend/         # Vite frontend
│   ├── src/main.js
│   ├── index.html
│   └── package.json
├── Dockerfile.backend
├── Dockerfile.frontend
├── docker-compose.yml
└── pixi.toml
```

## Quick start

```bash
# Backend (from apps/hybrid-app)
pixi run backend-dev          # uvicorn on :8000

# Frontend (from apps/hybrid-app)
pixi run frontend-dev         # vite dev server on :5173

# Full stack via Docker Compose
pixi run up
pixi run logs
pixi run down
```

## Root-level tasks

From the repo root, the `hybrid` environment tasks are also available:

```bash
pixi run -e hybrid hybrid-backend
pixi run -e hybrid hybrid-frontend-dev
pixi run -e hybrid hybrid-up
```
