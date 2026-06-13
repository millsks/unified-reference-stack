# Monitoring & Observability

## Health checks

Every service exposes `GET /health` and is wired into Docker Compose `healthcheck`.
Compose will not start downstream services until all `depends_on: condition: service_healthy`
checks pass.

```bash
# Verify all services are healthy
pixi run docker-ps

# Tail logs for a specific service
docker compose -f infra/docker-compose.yml logs -f py-service
```

## Log tailing

```bash
# All services
pixi run docker-logs

# Single service
docker compose -f infra/docker-compose.yml logs -f node-api

# Since a specific time
docker compose -f infra/docker-compose.yml logs --since 10m
```

## Container resource usage

```bash
docker stats --no-stream
```

## Postgres

```bash
# Connect to the running Postgres container
docker compose -f infra/docker-compose.yml exec postgres \
  psql -U user -d appdb

# Check connection count
docker compose -f infra/docker-compose.yml exec postgres \
  psql -U user -d appdb -c "SELECT count(*) FROM pg_stat_activity;"
```

## Redis

```bash
# Ping
docker compose -f infra/docker-compose.yml exec redis redis-cli ping

# Monitor live commands
docker compose -f infra/docker-compose.yml exec redis redis-cli monitor
```

## Application-level health probes

### py-service

```bash
curl http://localhost:8000/health
# {"status":"ok","service":"py-service"}
```

### node-api

```bash
curl http://localhost:3000/health
# {"status":"ok","service":"node-api"}
```

### Via Nginx (full-stack)

```bash
curl http://localhost/api/py/health
curl http://localhost/api/node/health
```

## CI health gate

The GitHub Actions workflow (`.github/workflows/ci.yml`) runs lint and all test suites before
allowing Docker image builds. No image is built from a failing commit.
