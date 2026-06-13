# Troubleshooting

## Pixi

### `pixi install` fails with "no candidates found"

A package constraint has no matching version on conda-forge.

1. Search for the correct package name: `pixi search <name>`
2. Check if the package exists on conda-forge: [prefix.dev/channels/conda-forge](https://prefix.dev/channels/conda-forge)
3. Common name differences:
   - `yq` (Python v3) vs `go-yq` (Go v4+)
   - `npm` does not exist — use `nodejs` which bundles it

### `pixi run <task>` exits with "task not found"

- Tasks in `[feature.*.tasks]` are only available in environments that include that feature.
  Use `pixi run -e <env> <task>`.
- Run `pixi task list` to see all available tasks in the current directory.

### Lock file conflict after merge

```bash
pixi install   # re-resolve and update pixi.lock
git add pixi.lock
git commit -m "chore: resolve pixi.lock conflict"
```

### `pixi install --frozen` fails in Docker

The `pixi.lock` was not committed, or the `COPY pixi.lock ./` line in the Dockerfile
is missing. Commit `pixi.lock` and ensure it is not in `.dockerignore`.

## Node.js

### `npm ci` fails with "Missing: package-lock.json"

The lock file was not generated yet. Run once from the app directory:

```bash
cd apps/node-api
pixi install
.pixi/envs/default/bin/npm install   # generates package-lock.json
git add package-lock.json
```

Subsequent runs of `pixi run test` (which calls `npm ci`) will succeed.

### `npx nodemon` not found

`nodemon` is a `devDependency` in `package.json`. Run `pixi run install` (which calls
`npm ci`) before calling `pixi run dev`.

## Python

### `ModuleNotFoundError: No module named 'py_service'`

The `src/` layout requires the `src/` directory to be on the Python path.
Ensure `pyproject.toml` contains:

```toml
[tool.pytest.ini_options]
pythonpath = ["src"]
```

### `pytest-asyncio` warning about unrecognised marks

Add `asyncio_mode = "auto"` to `[tool.pytest.ini_options]` in `pyproject.toml`, or
ensure every async test is decorated with `@pytest.mark.asyncio`.

## Docker

### Port already in use

```bash
# Find what is using the port
lsof -ti :8000

# Kill it
lsof -ti :8000 | xargs kill -9
```

### Image build fails with stale cache

```bash
docker compose -f infra/docker-compose.yml build --no-cache
```

### Postgres healthcheck never passes

Check the Postgres logs:

```bash
docker compose -f infra/docker-compose.yml logs postgres
```

Common cause: `POSTGRES_USER` or `POSTGRES_PASSWORD` mismatch between `docker-compose.yml`
and the `pg_isready` healthcheck command.

### Service exits immediately with code 1

```bash
docker compose -f infra/docker-compose.yml logs <service>
```

The most common causes are a missing environment variable or a failed dependency
(e.g. Postgres not ready before `py-service` starts). Add a `depends_on: condition:
service_healthy` entry in the Compose file.
