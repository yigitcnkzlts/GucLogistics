# ADR 0001: Modular Monolith First

## Status

Accepted

## Context

The platform must eventually scale to thousands of companies and tens of thousands of drivers, but starting with distributed microservices would slow delivery and complicate transactional consistency for the MVP.

## Decision

Ship a Spring Boot modular monolith with Maven modules aligned to bounded contexts. Use domain events and an outbox table so contexts can later be extracted.

## Consequences

- Faster MVP delivery with ACID transactions across modules when needed
- Clear extraction seams for future microservices
- Single deployable unit for early operations
