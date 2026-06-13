# ---- Stage 1: Build ----
FROM rust:1.78-slim AS builder

WORKDIR /app

# Cache dependency layer
COPY Cargo.toml Cargo.lock* ./
RUN mkdir src && echo "fn main() {}" > src/main.rs
RUN cargo build --release
RUN rm -f target/release/deps/rust_cli*

# Build actual source
COPY src/ ./src/
RUN cargo build --release

# ---- Stage 2: Minimal runtime ----
FROM debian:bookworm-slim AS runtime

RUN addgroup --system appgroup && adduser --system --ingroup appgroup appuser

WORKDIR /app

COPY --from=builder /app/target/release/rust-cli ./rust-cli

RUN chown appuser:appgroup ./rust-cli
USER appuser

CMD ["./rust-cli"]
