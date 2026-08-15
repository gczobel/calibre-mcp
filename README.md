# calibre-mcp

A ready-to-run Docker image for [`ajtudela/calibre_mcp_server`](https://github.com/ajtudela/calibre_mcp_server) — a read-only MCP server over a Calibre library's `metadata.db`.

This repo doesn't modify the upstream project. It just packages it as a container image and keeps that image rebuilt on a schedule, so the underlying Python/OS base image and the upstream code both stay current without manual bumping.

## Image

Published to `ghcr.io/gczobel/calibre-mcp:latest` on every push to `main` and on a weekly schedule (Mondays, see `.github/workflows/docker-publish.yml`). Each rebuild reinstalls `calibre_mcp_server` from its `main` branch on top of a freshly-pulled `python:3.12-slim`, so both upstream code changes and base-image security patches land automatically.

## Configuration

All configuration is via environment variables at container run time — nothing is baked into the image except the transport defaults:

| Variable | Required | Default (baked in) | Description |
|---|---|---|---|
| `CALIBRE_LIBRARY_PATH` | Yes | — | Path to the Calibre library inside the container (mount your library volume here, read-only) |
| `CALIBRE_DB_FILENAME` | No | `metadata.db` | Database filename within the library |
| `TRANSPORT_MODE` | No | `http` | `http` or `stdio` |
| `HTTP_HOST` | No | `0.0.0.0` | HTTP bind host |
| `HTTP_PORT` | No | `9001` | HTTP bind port |

## Example

```yaml
services:
  calibre-mcp:
    image: ghcr.io/gczobel/calibre-mcp:latest
    restart: unless-stopped
    environment:
      - CALIBRE_LIBRARY_PATH=/books
    volumes:
      - /path/to/your/calibre/library:/books:ro
    ports:
      - "9001:9001"
```

Mounting the library `:ro` is strongly recommended — the server never writes to it, so a read-only mount costs nothing and guarantees it at the filesystem level too.

## Why a separate repo from a fork

This doesn't fork or modify `ajtudela/calibre_mcp_server` — it's used exactly as published. This repo exists only to solve "run it as a container, kept up to date," which the upstream repo doesn't ship (no `Dockerfile` there).
