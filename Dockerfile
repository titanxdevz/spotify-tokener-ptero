FROM ghcr.io/topi314/spotify-tokener:master

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENV SPOTIFY_TOKENER_LOG_LEVEL=INFO
ENTRYPOINT ["/bin/sh", "/entrypoint.sh"]
