# py-service

FastAPI service — part of the unified-reference-stack.

## Quick start

```bash
pixi run dev          # hot-reload server on :8000
pixi run -e test test # run test suite
pixi run -e lint lint # lint check
```

## Endpoints

| Method | Path      | Description        |
|--------|-----------|--------------------|
| GET    | `/`       | Root greeting      |
| GET    | `/health` | Health check       |

## Environments

| Environment | Contents                        |
|-------------|---------------------------------|
| `default`   | Runtime deps only               |
| `test`      | + pytest, httpx, pytest-asyncio |
| `lint`      | + ruff, mypy                    |
| `dev`       | + test + lint                   |
