---
name: docker-dev
description: >
  Docker and docker-compose conventions for local development environments.
  Auto-loaded when working with Dockerfiles, docker-compose files, or
  container-based E2E testing.
---

## General conventions

- Never hardcode `localhost` — use `127.0.0.1` to avoid IPv6 resolution issues
- Use docker-compose service names for inter-container communication
- Use `host.docker.internal` for host access from containers in CI
- Name volumes explicitly in compose files
- Use multi-stage Dockerfile builds to keep final images small

## E2E testing pattern

1. Start backing services first with `--wait` for health checks
2. Clear stale state between runs (kill old containers, wipe data volumes)
3. Build and start application services
4. Discover endpoints via `docker compose port <service> <port>`
5. Run tests against discovered endpoints
6. Wipe data volumes between test runs for clean state; preserve build
   cache volumes for speed

## Integration tests

Prefer the `testcontainers` crate (Rust) or equivalent for integration
tests that need a single external service. This avoids needing a full
compose environment for targeted tests. Reserve docker-compose for
full E2E scenarios with multiple interacting services.

## Directory layout

Compose environments typically live under `envs/` with one subdirectory
per environment (e.g., `envs/dev-local/`, `envs/staging/`). Read the
project's actual structure before assuming paths.
