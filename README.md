# Docker Plex & Usenet Media Server #

docker-based plex & usenet media server using custom subdomains with tls

## Motivation

* host each service as a subdomain of a personal domain over https
* run public maintained images with no modifications
* keep source repo small (3 required files)
* require minimal configuration and setup

## Features

* [Plex](https://hub.docker.com/r/linuxserver/plex/) organizes video, music and photos from personal media libraries and streams them to smart TVs, streaming boxes and mobile devices. This container is packaged as a standalone Plex Media Server.
* [NZBGet](https://hub.docker.com/r/linuxserver/nzbget/) is a usenet downloader, written in C++ and designed with performance in mind to achieve maximum download speed by using very little system resources.
* [Sonarr](https://hub.docker.com/r/linuxserver/sonarr/) (formerly NZBdrone) is a PVR for usenet and bittorrent users. It can monitor multiple RSS feeds for new episodes of your favorite shows and will grab, sort and rename them. It can also be configured to automatically upgrade the quality of files already downloaded when a better quality format becomes available.
* [Radarr](https://hub.docker.com/r/linuxserver/radarr/) - A fork of Sonarr to work with movies à la Couchpotato.
* [NZBHydra](https://hub.docker.com/r/linuxserver/hydra2/) 2 is a meta search application for NZB indexers, the "spiritual successor" to NZBmegasearcH, and an evolution of the original application NZBHydra . It provides easy access to a number of raw and newznab based indexers.
* [Traefik](https://hub.docker.com/_/traefik/) is a modern HTTP reverse proxy and load balancer that makes deploying microservices easy.

## Requirements

* dedicated server or PC with plenty of storage
* windows or linux x86/x64 os (not ARM)
* custom top-level domain with configurable sub-domains (eg. plex.exampledomain.com)
* [cloudflare](https://www.cloudflare.com/) dns and proxy

## Installation

1. install [docker](https://docs.docker.com/install/linux/docker-ce/debian/)

2. install [docker-compose](https://docs.docker.com/compose/install/#install-compose)

3. clone mediaserver repo
```bash
git clone https://github.com/klutchell/mediaserver.git
cd mediaserver
```

## Configure

1. copy `env.sample` to `.env` and fill all required fields
```bash
# this file will not be tracked by git
cp env.sample .env && nano .env
```

_skip remaining steps if NOT using traefik https proxy_

2. create an empty file `acme.json` for ssl/tls cert storage

```bash
# this file will not be tracked by git
sudo touch acme.json && sudo chmod 600 acme.json
```

3. login to [cloudflare](https://www.cloudflare.com/) and add dns records 
for each service under `DNS` -> `DNS Records`

|Type|Name|Value|
|---|---|---|
|`A`|`plex.exampledomain.com`|`xxx.xxx.xxx.xxx`|
|`A`|`hydra.exampledomain.com`|`xxx.xxx.xxx.xxx`|
|`A`|`sonarr.exampledomain.com`|`xxx.xxx.xxx.xxx`|
|`A`|`radarr.exampledomain.com`|`xxx.xxx.xxx.xxx`|
|`A`|`nzbget.exampledomain.com`|`xxx.xxx.xxx.xxx`|

## Deploy

_if using traefik https proxy_

```bash
# pull latest public images
docker-compose pull

# deploy (or update) containers with docker compose
docker-compose up -d --remove-orphans
```

_if NOT using traefik https proxy_

```bash
# pull latest public images
docker-compose -f docker-compose.noproxy.yml pull

# deploy (or update) containers with docker compose
docker-compose -f docker-compose.noproxy.yml up -d --remove-orphans
```

## Usage

* Log in to plex and claim server to your plex.tv account
* Log in to each service and enable http authentication

## Author

Kyle Harding <kylemharding@gmail.com>

## Acknowledgments

I didn't create any of these docker images myself, so credit goes to the
maintainers, and the app creators.

* [linuxserver.io](https://linuxserver.io/)
* [traefik.io](https://traefik.io/)

## References

* https://docs.traefik.io/configuration/commons/
* https://docs.traefik.io/configuration/entrypoints/
* https://docs.traefik.io/configuration/backends/docker/
* https://docs.traefik.io/configuration/acme/

## License

[MIT License](./LICENSE)
