# Frequently Asked Questions

## Pixi

### Why use `go-yq` instead of `yq`?

The `yq` package on conda-forge is a Python-based wrapper pinned at v3.x. The Go-based
`yq` (v4+) — which is what most documentation references — is published as `go-yq` on
conda-forge. Always use `go-yq = ">=4.40"` in `pixi.toml`.

### Why can't I add `npm` as a dependency?

`npm` is bundled inside `nodejs` on conda-forge and is not a separately installable package.
Adding `nodejs = ">=20"` gives you both `node` and `npm`. Never add `npm` explicitly.

### Why is `cargo-watch` not in the rust environment?

`cargo-watch` is not on conda-forge. Install it manually after activating the environment:

```bash
pixi shell -e rust
cargo install cargo-watch
cargo-watch -x run
```

### Why does `jq` only install on Linux and macOS?

`jq` has no `win-64` build on conda-forge. The root `pixi.toml` uses
`[target.<platform>.dependencies]` to restrict it to the three POSIX platforms.
On Windows, use `go-yq` for JSON/YAML processing, or install `jq` via Scoop/Chocolatey
outside of Pixi.

### Why doesn't `default-environment` work in task definitions?

The `default-environment` field is documented in the Pixi advanced tasks guide but is not
implemented in Pixi 0.70.x. Tasks in features that appear in multiple environments will
require `-e <env>` to disambiguate. This will be removed once the feature ships.

### Why use `pixi install --frozen` in Dockerfiles?

`--frozen` prevents Pixi from modifying `pixi.lock` during a container build. Without it,
a network hiccup or a new package version could silently change the installed packages,
breaking reproducibility.

## Docker

### Why do Dockerfiles use multi-stage builds?

Multi-stage builds keep the final runtime image lean: build tools (Rust compiler, pixi,
npm devDependencies) are installed in an intermediate stage and are not copied to the
production layer. This reduces image size and attack surface.

### Why is there a `docker-compose.override.yml`?

The override file adds volume mounts for hot-reload during local development without
touching the production `docker-compose.yml`. Docker Compose merges them automatically
when both files are present.

## General

### Where do I report a bug or request a feature?

Open an issue on GitHub. See [contributing.md](../development/contributing.md) for the
full process.

### Where are Architecture Decision Records (ADRs)?

In [docs/architecture/adr/](../architecture/adr/). Each significant design choice gets
its own numbered ADR.
