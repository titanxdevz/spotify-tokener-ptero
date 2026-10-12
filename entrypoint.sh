#!/bin/sh
cd /home/container || exit 1
export TZ="${TZ:-UTC}"
export SPOTIFY_TOKENER_ADDR="${SPOTIFY_TOKENER_ADDR:-0.0.0.0:${SERVER_PORT:-8080}}"
if [ -n "${STARTUP}" ]; then
  eval "${STARTUP}"
else
  exec /bin/spotify-tokener
fi
