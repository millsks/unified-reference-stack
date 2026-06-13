# Service Map

## Port assignments

| Service    | Internal port | Host port (dev) | Protocol |
|------------|---------------|-----------------|----------|
| py-service | 8000          | 8000            | HTTP     |
| node-api   | 3000          | 3000            | HTTP     |
| hybrid-app | 8000          | 8001            | HTTP     |
| nginx      | 80            | 80              | HTTP     |
| postgres   | 5432          | (internal only) | TCP      |
| redis      | 6379          | 6379            | TCP      |

## Docker Compose network topology

All services in `infra/docker-compose.yml` join the `unified-stack` bridge network.
Only `nginx`, `py-service`, `node-api`, and `redis` expose host ports in the dev Compose file.

```text
┌─────────────────────────────────────────────────┐
│  Docker bridge network: unified-stack            │
│                                                  │
│  ┌──────────┐   /api/py/   ┌────────────┐        │
│  │  nginx   │ ──────────► │ py-service │        │
│  │  :80     │   /api/node/ │ :8000      │        │
│  │          │ ──────────► ├────────────┤        │
│  └──────────┘             │ node-api   │        │
│       │                   │ :3000      │        │
│       │ host :80          └────────────┘        │
│                                                  │
│  ┌────────────┐   ┌────────────┐                 │
│  │  postgres  │   │   redis    │                 │
│  │  :5432     │   │   :6379    │                 │
│  └────────────┘   └────────────┘                 │
└─────────────────────────────────────────────────┘
```

## Nginx routing rules

Defined in `infra/nginx/nginx.conf`:

| Request path   | Upstream         | Notes                          |
|----------------|------------------|--------------------------------|
| `/api/py/*`    | py-service:8000  | Strips `/api/py` prefix        |
| `/api/node/*`  | node-api:3000    | Strips `/api/node` prefix      |
| `/*`           | Static files     | Falls back to `index.html`     |

## Health check endpoints

Each service exposes a `/health` endpoint used by Docker Compose `healthcheck` and CI probes:

| Service    | Endpoint              | Expected response                              |
|------------|-----------------------|------------------------------------------------|
| py-service | `GET /health`         | `{"status":"ok","service":"py-service"}`       |
| node-api   | `GET /health`         | `{"status":"ok","service":"node-api"}`         |
| hybrid-app | `GET /health`         | `{"status":"ok","service":"hybrid-app-backend"}`|

## Inter-service dependencies (Compose)

```text
nginx
  └── depends_on: py-service, node-api

py-service
  └── depends_on: postgres (condition: service_healthy)

postgres
  └── healthcheck: pg_isready

redis
  └── healthcheck: redis-cli ping
```
