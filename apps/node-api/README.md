# node-api

Express API — part of the unified-reference-stack.

## Quick start

```bash
pixi run dev    # nodemon hot-reload on :3000
pixi run test   # run tests
pixi run lint   # eslint
```

## Endpoints

| Method | Path      | Description   |
|--------|-----------|---------------|
| GET    | `/`       | Root greeting |
| GET    | `/health` | Health check  |

## Notes

- `npm` is bundled inside `nodejs` on conda-forge; do not add it as a separate dependency.
- `node_modules/` is populated by `npm ci` via the `install` task.
