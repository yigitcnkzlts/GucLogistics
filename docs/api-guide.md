# API Guide

Base path: `/api/v1`  
OpenAPI: `/v3/api-docs`  
Swagger UI: `/swagger-ui.html`

## Authentication

1. `POST /api/v1/auth/register` or `POST /api/v1/auth/login`
2. Use `Authorization: Bearer <accessToken>` on protected routes
3. Rotate with `POST /api/v1/auth/refresh` body `{ "refreshToken": "..." }`
4. If login returns `mfaRequired=true`, complete `POST /api/v1/auth/mfa/verify`

Access tokens expire in 15 minutes (configurable). Refresh tokens rotate; reuse revokes the session family.

## Common headers

| Header | Purpose |
|--------|---------|
| `Authorization` | Bearer access JWT |
| `X-Correlation-Id` | Optional; generated if missing |
| `Content-Type` | `application/json` (or multipart for documents) |

## Error model

RFC 7807 `ProblemDetail` with `errorCode`, `timestamp`, `path`.

## Major resources

- Identity: `/auth/*`, `/sessions`, `/devices`, `/me`
- Companies: `/companies`
- Drivers: `/drivers`
- Vehicles: `/vehicles`
- Verification: `/verification/applications`
- Loads: `/loads`
- Offers: `/loads/{id}/offers`, `/offers/{id}/*`
- Matches: `/matches`
- Notifications: `/notifications`

See controller classes under `backend/guc-*/src/main/java/**/api` for the authoritative contract.
