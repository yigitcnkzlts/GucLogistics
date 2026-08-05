# OWASP Top 10 Analysis (A01–A10)

Based on the current codebase after Production Foundation hardening.

| ID | Risk | Status | Evidence / residual risk |
|----|------|--------|---------------------------|
| A01 Broken Access Control | Mitigated | Ownership checks in services; `@PreAuthorize` on admin/moderation endpoints; IDOR unit tests | Expand role matrices on every write endpoint |
| A02 Cryptographic Failures | Mitigated | Argon2id passwords; AES-GCM MFA secrets; JWT HMAC ≥32-byte secret; prod weak-secret fail-fast | Enforce TLS at edge; rotate keys via runbooks |
| A03 Injection | Mitigated | JPA + parameterized native SQL; no shell exec | Keep forbidding string-concat SQL |
| A04 Insecure Design | Partial | Modular boundaries, outbox table, rate limits, lockout | Outbox consumer still absent |
| A05 Security Misconfiguration | Mitigated | Security headers, CSRF off for JWT, prod HSTS, secrets via env | Docker Desktop/local TLS still operator-owned |
| A06 Vulnerable Components | Process | CI OWASP Dependency-Check + SpotBugs jobs | Keep CVSS gate tuned; review reports |
| A07 Identification & Auth Failures | Mitigated | JWT+refresh rotation+reuse detection, MFA TOTP, rate limit, lockout, session/device mgmt | Mobile MFA UI still missing (client) |
| A08 Software/Data Integrity | Partial | Flyway migrations; CI artifact image build | Signed releases / provenance not yet |
| A09 Logging & Monitoring Failures | Partial | Correlation ID, audit_logs, suspicious login events | Central SIEM/alerting not wired |
| A10 SSRF | Mitigated | No open URL fetchers; local storage path normalize/allowlist | Watch future webhook/GPS integrations |

## Residual actions

1. Start Docker Desktop and run `mvn verify -Dguc.integration=true` + `docker compose up`.
2. Add signed container provenance in CD.
3. Connect audit logs to SIEM.
