# Contributing

## Commit conventions

This repo uses [Conventional Commits](https://www.conventionalcommits.org/):

```text
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

```text
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

1. Create `apps/<name>/` with a `Dockerfile` and `README.md` (no per-app `pixi.toml` needed)
2. Add a `[feature.<name>.*]` block to the root `pixi.toml` with deps and tasks
3. Add a named environment in the root `[environments]` section
4. Add a build target to `infra/docker-bake.hcl`
5. Add a service entry to `infra/docker-compose.yml`
6. Add a CI job to `.github/workflows/ci.yml`

## Environment setup

See [onboarding.md](onboarding.md) for first-time setup instructions.
