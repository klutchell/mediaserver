# Docker Plex & Usenet Media Server #

docker-based plex media server for debian-based x86/x64 os 

**goals**
* expose each service at `https://<service>.<mydomain>.com` with SSL and Basic Auth
* use only publicly maintained images with as few modifications if any
* keep the source repo as small and clean as possible (~5 required files)
* avoid extensive configuration and setup (~10 required params, set once and forget)
* self-healing containers and dependencies (healthcheck, wait-for-it)

**services**

* [plex](https://plex.tv)
* [tautulli](http://tautulli.com/)
* [hydra](https://github.com/theotherp/nzbhydra2)
* [sonarr](https://sonarr.tv)
* [radarr](https://radarr.video)
* [nzbget](https://nzbget.net)
* [transmission](https://transmissionbt.com)
* [caddy](https://caddyserver.com/)

## Getting Started

### Prerequisites

* _(recommended)_ dedicated server with plenty of storage ( eg.
[Kimsufi](https://www.kimsufi.com/ca/en/servers.xml),
[SoYouStart](https://www.soyoustart.com/ca/en/essential-servers/),
[Hetzner](https://www.hetzner.com/sb?country=us)
)

* _(recommended)_ debian-based x86/x64 os (not ARM) ( eg.
[Ubuntu Server x64](https://www.ubuntu.com/download/server)
)

* _(required)_ custom top-level domain with cloudflare DNS ( eg.
[namecheap](https://www.namecheap.com/) & [cloudflare](https://www.cloudflare.com/)
)

### Install

```bash
# install docker
# https://docs.docker.com/install/linux/docker-ce/debian/
curl -sSL get.docker.com | sh

# install docker compose
# https://docs.docker.com/compose/install/
sudo curl -L --fail https://github.com/docker/compose/releases/download/1.21.2/run.sh -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# clone mediaserver repo
mkdir mediaserver && cd mediaserver
git clone git@github.com:klutchell/mediaserver.git .

# download wait-for-it.sh from jlordiales's github fork
# this fork allows multiple services to be tested
curl -L --fail https://raw.githubusercontent.com/jlordiales/wait-for-it/master/wait-for-it.sh -o wait-for-it.sh
chmod +x wait-for-it.sh
```

### Configure

#### Cloudflare

* `DNS` -> `DNS Records`

|Type|Name|Value|
|---|---|---|
|`A`|`plex.yourdomain.com`|`xxx.xxx.xxx.xxx`|
|`A`|`tautulli.yourdomain.com`|`xxx.xxx.xxx.xxx`|
|`A`|`hydra.yourdomain.com`|`xxx.xxx.xxx.xxx`|
|`A`|`sonarr.yourdomain.com`|`xxx.xxx.xxx.xxx`|
|`A`|`radarr.yourdomain.com`|`xxx.xxx.xxx.xxx`|
|`A`|`nzbget.yourdomain.com`|`xxx.xxx.xxx.xxx`|
|`A`|`transmission.yourdomain.com`|`xxx.xxx.xxx.xxx`|

* `Crypto` -> `SSL` = `Full (strict)`

#### Firewall

* allow HTTP (80) and HTTPS (443) through your firewall
```bash
# ufw example
sudo ufw allow http https
```

#### Services

**common.env**
* set `PUID` and `PGID` to the output of `id -u` and `id -g` respectively
* set `TZ` to your local [unix timezone](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)

**caddy.env**
* set `ACME_AGREE` to `true` if you agree to the [Letsencrypt TOS](https://docs.google.com/viewer?url=https%3A%2F%2Fletsencrypt.org%2Fdocuments%2F2017.11.15-LE-SA-v1.2.pdf&pdf=true)
* set `CLOUDFLARE_EMAIL` to your registered Cloudflare email address
* set `CLOUDFLARE_API_KEY` to your [Cloudflare api key](https://support.cloudflare.com/hc/en-us/articles/200167836-Where-do-I-find-my-Cloudflare-API-key-)

**plex.env**
* set `ADVERTISE_IP` to `https://plex.yourdomain.com:443`
* set `PLEX_UID` and `PLEX_GID` to the output of `id -u` and `id -g` respectively
* set `PLEX_CLAIM` to a new token obtained at https://www.plex.tv/claim

**Caddyfile**
* add your custom domain to each of the opening blocks above `gzip`
* add a password to all of the `basicauth` lines

## Deploy

```bash
docker-compose up -d
```

## Usage

1. **enable basic authentication on each service via the respective webui**
2. link containers internally via the service name & port (eg. `http://hydra:5076`)

## Author

Kyle Harding <kylemharding@gmail.com>

## Acknowledgments

I didn't create any of these docker images myself, so credit goes to the
maintainers, and the app creators themselves.

## License

MIT License