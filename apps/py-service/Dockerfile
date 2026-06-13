# ---- Stage 1: Install deps via Pixi ----
FROM ghcr.io/prefix-dev/pixi:latest AS builder

WORKDIR /app

COPY pixi.toml pixi.lock ./
RUN pixi install --frozen -e default

COPY src/ ./src/

# ---- Stage 2: Minimal runtime ----
FROM python:3.12-slim AS runtime

RUN addgroup --system appgroup && adduser --system --ingroup appgroup appuser

WORKDIR /app

COPY --from=builder /app/.pixi/envs/default /app/.pixi/envs/default
COPY --from=builder /app/src ./src

RUN chown -R appuser:appgroup /app
USER appuser

ENV PATH="/app/.pixi/envs/default/bin:$PATH"

EXPOSE 8000

HEALTHCHECK --interval=10s --timeout=5s --retries=3 \
  CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8000/health')"

CMD ["uvicorn", "py_service.main:app", "--host", "0.0.0.0", "--port", "8000"]
