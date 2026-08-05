# Architecture

## Style

Modular monolith (Spring Boot 3.3 / Java 21) with Clean Architecture packaging per bounded context.

## Modules

`guc-shared`, `guc-identity-access`, `guc-users`, `guc-companies`, `guc-drivers`, `guc-vehicles`, `guc-verification`, `guc-loads`, `guc-offers`, `guc-matching`, `guc-notifications`, `guc-audit`, `guc-api` (composition root).

## Rules

- No cross-module repository access
- Integration via domain events (`DomainEventPublisher` + `outbox_events` write) and narrow ports
- Single PostgreSQL; Flyway `V1`–`V11`
- Redis for rate limiting

## Quality gates

- Per-module JaCoCo line coverage ≥ 80% (with documented excludes for DTOs/entities/controllers)
- CI: verify + integration tests, dependency-check, SpotBugs, gitleaks, Docker image artifact

## Client

Flutter app under `mobile/guc_logistics` (secure storage, refresh interceptor, Hive offline loads cache).
