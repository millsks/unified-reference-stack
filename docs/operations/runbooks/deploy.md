# Runbook: Deploy

## Prerequisites

- `docker buildx` with a multi-platform builder configured
- Write access to GHCR (`ghcr.io/millsks`)
- A semver tag ready (e.g. `v1.2.0`)

## Steps

### 1. Ensure CI is green

Check that the latest commit on `main` passes all CI jobs before tagging.

```bash
gh run list --branch main --limit 5
```

### 2. Create and push a release tag

```bash
git tag v1.2.0
git push origin v1.2.0
```

This triggers `.github/workflows/docker-publish.yml` automatically.

### 3. Verify images are published

```bash
gh run watch   # follow the publish workflow

# Confirm images exist in GHCR
gh api /users/millsks/packages?package_type=container \
  | go-yq '.[].name'
```

### 4. Update the Compose stack (server)

```bash
# On the deployment host
docker compose -f infra/docker-compose.yml pull
docker compose -f infra/docker-compose.yml up -d --remove-orphans
```

### 5. Confirm services are healthy

```bash
docker compose -f infra/docker-compose.yml ps
curl http://localhost/api/py/health
curl http://localhost/api/node/health
```

### 6. Monitor logs for 5 minutes

```bash
docker compose -f infra/docker-compose.yml logs -f --since 5m
```

## Rollback

If anything looks wrong, follow [rollback.md](rollback.md).
