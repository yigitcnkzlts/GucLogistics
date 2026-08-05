# Security Guide

## Secrets

Required environment variables (no defaults in base `application.yml`):

- `DB_URL`, `DB_USER`, `DB_PASSWORD`
- `REDIS_HOST`, `REDIS_PORT`
- `JWT_SECRET` (≥ 32 bytes)
- `ENCRYPTION_KEY` (Base64 32-byte AES key)
- `GUC_STORAGE_PATH` (required in prod)

Validated by `com.guclogistics.config.EnvironmentValidator`. Production additionally rejects weak/default-looking values.

Copy `.env.example` → `.env` for local Compose. Never commit `.env`.

## Authentication & sessions

| Control | Implementation |
|---------|----------------|
| Password hash | Argon2id (`SecurityConfig`) |
| Access token | JWT 15m (`JwtService`) |
| Refresh | Opaque token, hashed in `user_sessions`, rotation + reuse detection |
| MFA | TOTP + AES-GCM encrypted secret + hashed recovery codes |
| Rate limit | Redis sliding window (`RateLimitService`) |
| Lockout | `login_attempts` + `users.locked_until` |
| Sessions/devices | List/revoke APIs |

## Transport

- Production: terminate TLS at proxy; `guc.security.hsts-enabled=true` emits HSTS
- Security headers: nosniff, DENY frame, CSP, Referrer-Policy (`SecurityHeadersFilter`)

## Authorization

- JWT roles → `ROLE_*` authorities
- Method security enabled; moderation/admin endpoints use `@PreAuthorize`
- Resource ownership enforced in application services (IDOR unit-tested)

## Uploads

- Apache Tika MIME allowlist (PDF/JPEG/PNG), 5MB limit
- `VirusScanPort` with no-op adapter (replace in production)

## Auditing

Critical auth and marketplace events → `audit_logs` via `AuditEventListener`.
