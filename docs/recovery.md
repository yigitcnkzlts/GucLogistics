# Recovery Guide

## Lost access / account lockout

- After repeated failed logins the account sets `users.locked_until`.
- Wait for lockout window (30 minutes) or clear `locked_until` via controlled admin DB procedure with audit.
- Rotate password after unlock.

## Compromised refresh token

- Refresh reuse triggers session family revoke (`AuthService.refresh`).
- User should `GET /sessions` and revoke remaining sessions; re-login on trusted devices.
- Investigate `audit_logs` for `SUSPICIOUS_LOGIN` / `TOKEN_REUSE`.

## Compromised JWT signing secret

1. Rotate `JWT_SECRET` immediately.
2. Restart all API instances.
3. All access tokens become invalid; users re-authenticate.
4. Optionally truncate active `user_sessions` to force refresh invalidation.

## Encryption key loss (MFA secrets)

`ENCRYPTION_KEY` decrypts TOTP secrets. Loss means MFA settings cannot be decrypted.

1. Disable MFA rows / force re-enrollment after key rotation ceremony.
2. Never reuse guessed keys; generate with `openssl rand -base64 32`.

## Database restore

1. Restore Postgres from backup.
2. Ensure Flyway `flyway_schema_history` is consistent with restored schema.
3. Flush Redis rate-limit keys if restoring to an older point-in-time.

## Outbox backlog

`outbox_events` is write-ahead for future brokers. Current runtime uses in-process Spring events. If introducing a consumer, process `processed_at IS NULL` ordered by `created_at`.
