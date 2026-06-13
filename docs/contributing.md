# Contributing

## Commit conventions

This repo uses [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <short summary>
```

| Type     | When to use                            |
|----------|----------------------------------------|
| feat     | New feature                            |
| fix      | Bug fix                                |
| chore    | Maintenance (deps, tooling, CI)        |
| docs     | Documentation only                     |
| refactor | Code change that neither fixes nor adds|
| test     | Adding or updating tests               |

Scope should be the app or component: `py-service`, `node-api`, `rust-cli`, `infra`, `ci`.

Examples:
```
feat(py-service): add /metrics endpoint
fix(node-api): handle missing PORT env var
chore(infra): bump postgres to 16.3
```

## Pull request process

1. Branch from `main`: `git checkout -b feat/your-feature`
2. Run `pixi run lint-all` and fix any issues
3. Run `pixi run test-all` and ensure all tests pass
4. Open a PR — CI will run automatically

## Adding a new app

1. Create `apps/<name>/` with its own `pixi.toml`, `Dockerfile`, and `README.md`
2. Add a feature block to the root `pixi.toml` (see existing `feature.py`, `feature.node`)
3. Add workspace-level tasks to the root `pixi.toml` `[tasks]` section
4. Add a build target to `infra/docker-bake.hcl`
5. Add a service entry to `infra/docker-compose.yml`
6. Add a CI job to `.github/workflows/ci.yml`

## Environment setup

See [onboarding.md](onboarding.md) for first-time setup instructions.
