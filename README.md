# GucLogistics

Enterprise logistics marketplace connecting shippers, logistics companies, and independent drivers.

## Stack

- **Backend:** Java 21, Spring Boot 3.3, PostgreSQL 16, Redis 7 (modular monolith)
- **Mobile:** Flutter (Android + iOS)
- **Infra:** Docker Compose, GitHub Actions

## Quick start (local)

```bash
# Infrastructure + API
cd docker
docker compose up --build

# API: http://localhost:8080
# Swagger: http://localhost:8080/swagger-ui.html
```

Backend only (requires local Postgres + Redis):

```bash
cd backend
mvn -pl guc-api -am spring-boot:run
```

Mobile:

```bash
cd mobile/guc_logistics
flutter pub get
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8080
```

## Phases delivered

1. Secure auth foundation (JWT, RBAC, MFA, audit, rate limit, CI)
2. Companies, drivers, vehicles, verification
3. Loads, offers, matching
4. Flutter MVP client

## Security notes

See [docs/security.md](docs/security.md). Never commit real secrets; use `.env.example` as a template.
