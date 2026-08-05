# GucLogistics

Enterprise logistics marketplace platform (modular Spring Boot monolith + Flutter client).

## Documentation

| Guide | Path |
|-------|------|
| Architecture | [docs/architecture.md](docs/architecture.md) |
| Security | [docs/security.md](docs/security.md) |
| OWASP analysis | [docs/owasp-top10-analysis.md](docs/owasp-top10-analysis.md) |
| Deployment | [docs/deployment.md](docs/deployment.md) |
| API | [docs/api-guide.md](docs/api-guide.md) |
| Recovery | [docs/recovery.md](docs/recovery.md) |

## Quick start

```bash
cp .env.example .env
# Set DB_PASSWORD, JWT_SECRET (>=32 bytes), ENCRYPTION_KEY (openssl rand -base64 32)

cd docker
docker compose --env-file ../.env up --build
```

Backend tests:

```bash
cd backend
mvn -B verify                 # unit tests + JaCoCo >= 80% per module
mvn -B verify -Dguc.integration=true   # + Testcontainers E2E (Docker required)
```

## Security baseline

- No secrets in source; runtime requires env vars (`EnvironmentValidator`)
- Prod profile enables HSTS and rejects weak defaults
- JWT access + rotating refresh tokens, Argon2id, TOTP MFA, Redis rate limits
- CI: build/test/coverage, dependency-check, SpotBugs, gitleaks, Docker image artifact

## Repository layout

```
backend/   Maven modules (guc-*)
mobile/    Flutter MVP client
docker/    Compose + API Dockerfile
docs/      Architecture & ops guides
.github/   CI workflows
```
