# GucLogistics Security

## Authentication

- Argon2id password hashing
- JWT access tokens (15 minutes) + opaque refresh tokens (7 days)
- Refresh rotation with reuse detection (session family revoke)
- TOTP MFA enrollment/verify/disable; optional global requirement via `mfa.required` feature flag

## Authorization

- Role-based access control (`SHIPPER`, `LOGISTICS_COMPANY`, `INDEPENDENT_DRIVER`, `FLEET_OWNER`, `ADMIN`, `SUPPORT`, `MODERATOR`)
- Method security (`@PreAuthorize`) + resource ownership checks (IDOR prevention)

## Abuse protection

- Redis sliding-window rate limits on register/login/MFA
- Failed login tracking and temporary account lockout
- Suspicious login / new device notifications + audit events

## Transport & headers

- Production TLS + HSTS expected at edge
- `X-Content-Type-Options`, `X-Frame-Options: DENY`, strict CSP, `Referrer-Policy`
- Correlation ID on every request (`X-Correlation-Id`)

## Uploads

- Apache Tika MIME sniffing
- Allowlist: PDF, JPEG, PNG
- Size limit 5MB
- `VirusScanPort` with no-op adapter (replaceable)

## Secrets

- Injected via environment variables (`JWT_SECRET`, `ENCRYPTION_KEY`, DB credentials)
- Never committed to the repository
