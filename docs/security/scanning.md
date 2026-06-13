# Security Scanning

Both vulnerability scanning and secret scanning are handled by
[trivy](https://github.com/aquasecurity/trivy) via the `security` Pixi environment.

## Vulnerability scanning

Scans the source tree and installed packages for known CVEs:

```bash
pixi run -e security scan-vulns
```

Output: `sbom/trivy-vuln.cdx.json` (CycloneDX 1.6, pretty-printed).

### Interpreting results

```bash
# View the vulnerability report in the terminal instead
pixi shell -e security
trivy fs . --scanners vuln --format table
```

Trivy assigns severities: `CRITICAL`, `HIGH`, `MEDIUM`, `LOW`, `UNKNOWN`.
Block on `CRITICAL` and `HIGH` in CI; review `MEDIUM` periodically.

### Updating the database

Trivy downloads its vulnerability database on first run and caches it.
Force a refresh:

```bash
trivy image --download-db-only
```

## Secret scanning

Detects credentials, tokens, and keys committed in the source tree:

```bash
pixi run -e security scan-secrets
```

Exits non-zero if any secrets are detected. Output is a table listing file path,
rule ID, and matched string excerpt.

### Ignoring false positives

Create `.trivyignore` at the repo root:

```
# Ignore test fixtures
tests/fixtures/fake-api-key.txt
```

## Full security gate

```bash
pixi run -e security security-full
```

Runs in order: `sbom-all` → `scan-secrets` → `scan-vulns`.

## CI integration

Add a security scan job to `.github/workflows/ci.yml`:

```yaml
security:
  runs-on: ubuntu-latest
  steps:
    - uses: actions/checkout@v4
    - uses: prefix-dev/setup-pixi@v0.8.1
      with:
        environments: security
    - run: pixi run -e security scan-secrets
    - run: pixi run -e security scan-vulns
```
