# SBOM Guide

Software Bills of Materials (SBOMs) are generated per Pixi environment using
[syft](https://github.com/anchore/syft) and output in CycloneDX 1.6 JSON format.
[trivy](https://github.com/aquasecurity/trivy) provides vulnerability and secret scanning.

All output lands in `sbom/` (gitignored).

## Prerequisites

Install the `security` environment:

```bash
pixi install -e security
```

## Generate SBOMs

Each task scans the resolved `.pixi/envs/<env>` directory.
**Install the target environment first**, then scan it.

```bash
# Install target environments
pixi install -e default
pixi install -e py
pixi install -e node
pixi install -e rust

# Generate individual SBOMs
pixi run -e security sbom-default   # → sbom/default.cdx.json
pixi run -e security sbom-py        # → sbom/py.cdx.json
pixi run -e security sbom-node      # → sbom/node.cdx.json
pixi run -e security sbom-rust      # → sbom/rust.cdx.json

# Generate all at once
pixi run -e security sbom-all
```

Output files are pretty-printed (formatted via `jq`) for readability and diff-friendliness.

## Scan for secrets

```bash
pixi run -e security scan-secrets
# Exits non-zero if any secrets are detected.
```

Trivy checks for API keys, tokens, and credentials committed in the source tree.

## Scan for vulnerabilities

```bash
pixi run -e security scan-vulns
# → sbom/trivy-vuln.cdx.json (CycloneDX, pretty-printed)
```

## Full security gate

Runs all SBOM generation, secret scanning, and vulnerability scanning in one step:

```bash
pixi run -e security security-full
```

## SBOM format

Output files conform to [CycloneDX 1.6](https://cyclonedx.org/specification/overview/).
Key fields:

```json
{
  "bomFormat": "CycloneDX",
  "specVersion": "1.6",
  "components": [
    {
      "name": "fastapi",
      "version": "0.111.0",
      "purl": "pkg:pypi/fastapi@0.111.0"
    }
  ]
}
```

## Why not cyclonedx-cli?

`cyclonedx-cli` (the .NET validator) is not available on conda-forge and would require
a separate .NET runtime. `syft` and `trivy` produce spec-compliant CycloneDX 1.6 natively,
making a separate validator unnecessary for this workflow.
