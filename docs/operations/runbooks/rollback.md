# Runbook: Rollback

Use this runbook when a deployment introduces a regression and must be reverted quickly.

## Option A: Revert to the previous image tag (fastest)

### 1. Identify the last known-good tag

```bash
# List recent tags
git tag --sort=-creatordate | head -10

# Or check GHCR for available image tags
gh api /users/millsks/packages/container/py-service/versions \
  | go-yq '.[].metadata.container.tags[]' | head -10
```

### 2. Pin the Compose stack to the previous tag

Edit `infra/docker-compose.yml` (or `docker-compose.override.yml`) to pin each service:

```yaml
services:
  py-service:
    image: ghcr.io/millsks/unified-reference-stack/py-service:v1.1.0
  node-api:
    image: ghcr.io/millsks/unified-reference-stack/node-api:v1.1.0
```

### 3. Redeploy

```bash
docker compose -f infra/docker-compose.yml up -d --remove-orphans
```

### 4. Verify health

```bash
curl http://localhost/api/py/health
curl http://localhost/api/node/health
```

## Option B: Revert the Git tag and republish

If the bad tag needs to be removed from the registry:

```bash
# Delete the bad tag locally and remotely
git tag -d v1.2.0
git push origin :refs/tags/v1.2.0

# Delete the GHCR package version (requires write permission)
gh api -X DELETE \
  /users/millsks/packages/container/py-service/versions/<version-id>
```

Then fix the code, re-tag, and follow [deploy.md](deploy.md) again.

## Post-incident

1. Open an issue documenting what went wrong.
2. Add a regression test that would have caught the issue.
3. Update this runbook if the procedure needs adjustment.
