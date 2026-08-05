# GucLogistics Architecture

## Style

Modular monolith (Spring Boot) with Clean Architecture + DDD bounded contexts.

## Modules

| Module | Responsibility |
|--------|----------------|
| guc-shared | Shared kernel, events, exceptions, pagination, feature flags, outbox |
| guc-identity-access | Auth, JWT, MFA, sessions, devices, RBAC |
| guc-users | User profile views |
| guc-companies | Shipper / logistics companies |
| guc-drivers | Driver profiles |
| guc-vehicles | Vehicle registry |
| guc-verification | KYC-style verification + document upload |
| guc-loads | Freight load lifecycle |
| guc-offers | Bidding on loads |
| guc-matching | Accepted offer → match |
| guc-notifications | In-app notifications |
| guc-audit | Immutable audit trail |
| guc-api | Composition root |

## Communication rules

- No cross-module repository access.
- Integration via domain events (Spring ApplicationEvents + outbox table) and narrow ports.
- Single PostgreSQL database; Flyway migrations versioned per module (`V1`…`V11`).

## Future extraction

Bounded contexts are packaged as Maven modules so they can be extracted into microservices with an outbox → broker adapter without rewriting domain logic.
