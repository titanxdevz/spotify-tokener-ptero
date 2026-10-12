FROM golang:1.24-alpine AS build

WORKDIR /build

COPY go.mod go.sum ./
RUN go mod download

COPY main.go handler.go ./
RUN CGO_ENABLED=0 go build -o spotify-tokener .

FROM chromedp/headless-shell

COPY --from=build /build/spotify-tokener /bin/spotify-tokener
COPY --chmod=755 entrypoint.sh /entrypoint.sh

ENV SPOTIFY_TOKENER_LOG_LEVEL=INFO
ENTRYPOINT ["/bin/sh", "/entrypoint.sh"]
