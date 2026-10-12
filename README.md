# spotify-tokener (Pterodactyl-ready)

Docker image for [topi314/spotify-tokener](https://github.com/topi314/spotify-tokener) — a small Go service that returns Spotify anonymous & account access tokens without dealing with their TOTP flow.

This image wraps the original with two fixes that make it run properly on container hosts (especially Pterodactyl/Wings):

| Fix | Why |
| --- | --- |
| Binds to `${SERVER_PORT}` automatically | Pterodactyl allocates a random port per server — the app now listens on the allocated port instead of hardcoded `8080` |
| Chrome runs with `--no-sandbox` + `--disable-dev-shm-usage` | Unprivileged container users have no user namespaces / small `/dev/shm`, so headless Chrome refuses to start otherwise |

[![Build](https://github.com/titanxdevz/spotify-tokener-ptero/actions/workflows/build.yml/badge.svg)](https://github.com/titanxdevz/spotify-tokener-ptero/actions/workflows/build.yml)

## Images

```
ghcr.io/titanxdevz/spotify-tokener-ptero:latest
ghcr.io/titanxdevz/spotify-tokener-ptero:v2
```

## Quick start (Docker)

```bash
docker run -d --name spotify-tokener --restart unless-stopped -p 8080:8080 \
  ghcr.io/titanxdevz/spotify-tokener-ptero:v2
```

### docker compose

```yaml
services:
  spotify-tokener:
    image: ghcr.io/titanxdevz/spotify-tokener-ptero:v2
    restart: unless-stopped
    ports:
      - "8080:8080"
```

## Quick start (Pterodactyl panel)

Create a server with these fields — no egg scripts needed, the binary and Chrome are baked into the image:

| Field | Value |
| --- | --- |
| Docker Image | `ghcr.io/titanxdevz/spotify-tokener-ptero:v2` |
| Startup Command | `/bin/spotify-tokener` |
| Egg | any (e.g. `golang generic`) |
| Skip install scripts | enabled |
| Memory | ≥ 1024 MB recommended (Chrome) |

Then press **Start**. Your endpoint becomes:

```
http://<node-alias>:<allocation-port>/api/token
```

## Usage

### Anonymous token

```bash
curl http://localhost:8080/api/token
```

```json
{
  "clientId": "f6a40776580943a7bc5173125a1e8832",
  "accessToken": "BQD...",
  "accessTokenExpirationTimestampMs": 1791800086194,
  "isAnonymous": true
}
```

### Account token (cookies relayed 1:1)

Send your `sp_dc` cookie with the request:

```bash
curl -H "Cookie: sp_dc=<your_sp_dc>" http://localhost:8080/api/token
```

```js
const res = await fetch("http://localhost:8080/api/token", {
  headers: { Cookie: `sp_dc=${process.env.SP_DC}` },
});
const token = await res.json();
```

## Environment variables

| Variable | Default | Description |
| --- | --- | --- |
| `SPOTIFY_TOKENER_ADDR` | `0.0.0.0:${SERVER_PORT}` (or `8080` if no `SERVER_PORT`) | Listen address, set automatically by the entrypoint |
| `SPOTIFY_TOKENER_LOG_LEVEL` | `INFO` | Go `slog` level (`DEBUG`, `INFO`, `WARN`, `ERROR`) |
| `SPOTIFY_TOKENER_CHROME_PATH` | chromedp default | Override headless-shell path |
| `STARTUP` | — | If set, the entrypoint runs `eval "$STARTUP"` instead (yolks-style, so any command works) |

## Notes

- The service speaks plain HTTP on the allocated port — put a reverse proxy in front if you need TLS.
- Anonymous tokens work out of the box; account tokens require a valid `sp_dc` cookie.
- Use of this endpoint is subject to [Spotify's Developer Terms and Policy](https://developer.spotify.com/policy) — you are responsible for how you use it.

## Credits

- Upstream project: [topi314/spotify-tokener](https://github.com/topi314/spotify-tokener) (Apache-2.0)
- Headless Chrome: [chromedp/headless-shell](https://github.com/chromedp/docker-headless-shell)
