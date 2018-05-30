# Docker Plex & Usenet Media Server #

docker-based plex media server for debian-based x86/x64 os 

**goals**

* host services at `https://<service>.<yourdomain>.com` with tls/ssl
* run public maintained images with no modifications
* keep source repo small (~4 required files)
* require minimal configuration and setup (~15 env variables)
* attempt self-healing containers and dependencies (healthcheck, wait-for-it)
* enforce http basic authentication with exceptions for api urls

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

* dedicated server with plenty of storage
  * [Kimsufi](https://www.kimsufi.com/ca/en/servers.xml) _(tested)_
  * [SoYouStart](https://www.soyoustart.com/ca/en/essential-servers/)
  * [Hetzner](https://www.hetzner.com/sb?country=us)
  * etc...

* debian-based x86/x64 os (not ARM)
  * [Ubuntu Server x64](https://www.ubuntu.com/download/server) _(tested)_
  * etc...

* custom top-level domain with cloudflare DNS
  * [namecheap](https://www.namecheap.com/) & [cloudflare](https://www.cloudflare.com/) _(tested)_
  * etc...

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

## Deploy

```bash
# set environment variables in plex.env and common.env
# descriptions and examples are provided
nano plex.env
nano common.env

# deploy containers with docker compose
docker-compose up -d
```

## Usage

* add hydra users for authentication under `Config -> Authorization`
* link containers internally via the service name & port
  * tautulli can reach plex via `http://plex:32400`
  * sonarr/radarr can reach hydra via `http://hydra:5076`
  * sonarr/radarr can reach nzbget via `http://nzbget:6789`

## Author

Kyle Harding <kylemharding@gmail.com>

## Acknowledgments

I didn't create any of these docker images myself, so credit goes to the
maintainers, and the app creators themselves.

## License

MIT License