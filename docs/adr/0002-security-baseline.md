# ADR 0002: Security Baseline

## Status

Accepted

## Context

The platform handles company KYC documents, authentication, and commercial freight offers. Demo-grade security shortcuts are unacceptable.

## Decision

- Argon2id password hashing
- Short-lived JWT access tokens + rotating opaque refresh tokens in Redis-backed session store (DB hash)
- TOTP MFA with AES-GCM encrypted secrets
- Redis rate limiting and login lockout
- Audit trail for critical identity and marketplace events
- MIME allowlisting via Apache Tika for uploads; virus scan port for future ClamAV/S3 scanning

## Consequences

- Slightly higher auth latency due to Argon2 and refresh rotation
- Clear operational requirements for secret management and Docker/K8s env injection
