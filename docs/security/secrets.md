# Secrets Management

## Local development

Use a `.env` file at the repo root (it is gitignored):

```bash
# .env  — never commit this file
DATABASE_URL=postgresql://user:pass@localhost:5432/appdb
SECRET_KEY=dev-only-secret
REDIS_URL=redis://localhost:6379
```

Reference it in `docker-compose.override.yml`:

```yaml
services:
  py-service:
    env_file:
      - ../.env
```

## CI (GitHub Actions)

Store secrets in the GitHub repository settings under
**Settings → Secrets and variables → Actions**.

Reference them in workflow files:

```yaml
env:
  DATABASE_URL: ${{ secrets.DATABASE_URL }}
```

Never hard-code secrets in workflow files or commit `.env` files.

## Production

| Maturity level | Recommended mechanism                         |
|----------------|-----------------------------------------------|
| Basic          | Docker secrets (Compose `secrets:` stanza)    |
| Cloud-native   | AWS Secrets Manager / GCP Secret Manager      |
| Self-hosted    | HashiCorp Vault                               |

### Docker secrets example

```yaml
services:
  py-service:
    secrets:
      - db_password
secrets:
  db_password:
    external: true
```

Create the secret on the host:

```bash
echo "s3cr3t" | docker secret create db_password -
```

## What never to commit

- `.env` files of any kind
- Private keys (`*.pem`, `*.key`, `id_rsa`)
- Service account JSON files
- API tokens or bearer tokens

The `scan-secrets` task (`pixi run -e security scan-secrets`) will flag any of these
if they are accidentally staged.

## Pre-commit hook

`pre-commit` is configured at the repo root. Running `pixi run pre-commit-install` adds a
`pre-commit` hook that runs `trivy --scanners secret` on every commit, blocking the commit
if secrets are detected.
