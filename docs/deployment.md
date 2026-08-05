# Deployment Guide

## Prerequisites

- JDK 21
- Maven 3.9+
- Docker + Docker Compose
- Strong secrets (never commit `.env`)

## Local stack

```bash
cp .env.example .env
# fill DB_PASSWORD, JWT_SECRET (>=32 bytes), ENCRYPTION_KEY (openssl rand -base64 32)

cd docker
docker compose --env-file ../.env up --build
```

- API: `http://localhost:8080`
- Health: `http://localhost:8080/actuator/health`
- Swagger: `http://localhost:8080/swagger-ui.html`

## Application profiles

| Profile | Purpose |
|---------|---------|
| `dev` (default) | Local/Docker Compose |
| `prod` | Production — HSTS on, weak-secret fail-fast |
| `test` | Automated tests |

Activate production:

```bash
export SPRING_PROFILES_ACTIVE=prod
export DB_URL=...
export DB_USER=...
export DB_PASSWORD=...
export REDIS_HOST=...
export REDIS_PORT=6379
export JWT_SECRET=...
export ENCRYPTION_KEY=...
export GUC_STORAGE_PATH=/var/guc/uploads
java -jar guc-api.jar
```

TLS/HTTPS must terminate at the reverse proxy/load balancer. With `guc.security.hsts-enabled=true` (prod), the API emits `Strict-Transport-Security`.

## Kubernetes (outline)

1. Store secrets in sealed-secrets / external secrets operator.
2. Deploy Postgres + Redis (managed preferred).
3. Run API Deployment with `SPRING_PROFILES_ACTIVE=prod`.
4. Ingress with TLS certificate; forward `X-Forwarded-*` (`server.forward-headers-strategy=framework`).

## Migrations

Flyway runs automatically on startup from module classpath (`V1`…`V11`).
