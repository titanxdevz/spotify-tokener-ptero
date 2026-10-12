# spotify-tokener

A simple GoLang service which returns spotify anonymous & account tokens without having to deal with their annoying TOTP shit.

## Installation

For god's sake, just use docker. Otherwise, have fun compiling yourself:

### Manual

Requirements:

* [go 1.24+](https://go.dev/doc/install)
* [chrome](https://www.google.com/chrome/)

```bash
go install github.com/topi314/spotify-tokener@master
```

Now run it via systemd or something.

### Docker

Create your `compose.yml` and run `docker compose up -d`.

```yaml
services:
  spotify-tokener:
    image: ghcr.io/topi314/spotify-tokener:master
    container_name: spotify-tokener
    restart: unless-stopped
    environment:
#      - SPOTIFY_TOKENER_ADDR=0.0.0.0:8080
#      - SPOTIFY_TOKENER_CHROME_PATH=chrome
#      - SPOTIFY_TOKENER_LOG_LEVEL=INFO
    ports:
      - 8080:8080
```


## Usage

The endpoint is under `/api/token` and cookies are relayed 1:1 (like the sp_dc cookie for account login).

## License

This project is licensed under the [Apache License 2.0](LICENSE).

## Contributing

Contributions are welcome, but for bigger changes, please open an issue first to discuss what you would like to change.

## Contact

- [Discord](https://discord.gg/sD3ABd5)
- [Matrix](https://matrix.to/#/@topi:topi.wtf)
- [Twitter](https://twitter.com/topi314)
- [Email](mailto:hi@topi.wtf)
