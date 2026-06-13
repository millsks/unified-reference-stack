group "default" {
  targets = ["py-service", "node-api", "rust-cli"]
}

target "py-service" {
  context    = "../apps/py-service"
  dockerfile = "Dockerfile"
  tags       = ["ghcr.io/millsks/unified-reference-stack/py-service:latest"]
  platforms  = ["linux/amd64", "linux/arm64"]
}

target "node-api" {
  context    = "../apps/node-api"
  dockerfile = "Dockerfile"
  tags       = ["ghcr.io/millsks/unified-reference-stack/node-api:latest"]
  platforms  = ["linux/amd64", "linux/arm64"]
}

target "rust-cli" {
  context    = "../apps/rust-cli"
  dockerfile = "Dockerfile"
  tags       = ["ghcr.io/millsks/unified-reference-stack/rust-cli:latest"]
  platforms  = ["linux/amd64", "linux/arm64"]
}
