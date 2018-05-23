# Docker Plex & Usenet Media Server #

This is a Docker-based Plex Media Server setup for ubuntu using public images from Docker Hub.

The following services are enabled by default:

|service|image|example url|
|---|---|---|
|[plex](plex.tv)|[plexinc/pms-docker](https://hub.docker.com/r/plexinc/pms-docker/)|`plex.exampledomain.com`|
|[tautulli](jonnywong16.github.io/plexpy/)|[shiggins8/tautulli](https://hub.docker.com/r/shiggins8/tautulli/)|`tautulli.exampledomain.com`|
|[hydra](github.com/theotherp/nzbhydra)|[linuxserver/hydra](https://hub.docker.com/r/linuxserver/hydra/)|`hydra.exampledomain.com`|
|[sonarr](sonarr.tv)|[linuxserver/sonarr](https://hub.docker.com/r/linuxserver/sonarr/)|`sonarr.exampledomain.com`|
|[radarr](radarr.video)|[linuxserver/radarr](https://hub.docker.com/r/linuxserver/radarr/)|`radarr.exampledomain.com`|
|[nzbget](nzbget.net)|[linuxserver/nzbget](https://hub.docker.com/r/linuxserver/nzbget/)|`nzbget.exampledomain.com`|
|[transmission](transmissionbt.com)|[linuxserver/transmission](https://hub.docker.com/r/linuxserver/transmission/)|`transmission.exampledomain.com`|
|[caddy](https://caddyserver.com/)|[abiosoft/caddy-docker](https://hub.docker.com/r/abiosoft/caddy/)|n/a|

## Getting Started

### Prerequisites

**Custom domain**

A custom domain (eg. `exampledomain.com`) with configurable sub-domains (eg. `plex.exampledomain.com`).

_Tested with [namecheap](https://www.namecheap.com/) and [cloudflare](https://www.cloudflare.com/)._

**Debian OS**

_Tested with Ubuntu Server x64 16.04 on a [Kimsufi dedicated server](https://www.kimsufi.com/ca/en/servers.xml)._

### Install

```bash
# install docker
curl -sSL get.docker.com | sh

# install docker compose
sudo curl -L --fail https://github.com/docker/compose/releases/download/1.21.2/run.sh -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# clone repo
git clone git@github.com:klutchell/mediaserver.git ~/mediaserver
```

### Configure

#### Forward DNS

Forward any desired A-level domains to your server public IP address. Suggested services
and domains are listed in the description.

|type|domain|address|
|---|---|---|
|Type A|plex.exampledomain.com|xxx.xxx.xxx.xxx|
|Type A|tautulli.exampledomain.com|xxx.xxx.xxx.xxx|
|...|...|...|

#### Open Firewall Ports

Allow HTTP (80) and HTTPS (443) through your firewall. With UFW, it can be done with
this command.

```bash
sudo ufw allow http https
```

#### Configure Services

* Set your domain in `docker-compose.yml`
* Set your email and api key in `caddy.env`
* Set your domain and http basic auth password in `Caddyfile`
* Set your timezone and local user details in `common.env`
* Set your timezone and local user details in `plex.env`
* Set your plex claim token in `plex.env`

## Deploy

```bash
docker-compose up -d
```

## Usage

### Tautulli

Add the local plex media server connection details.
* Settings -> Plex Media Server -> Plex IP or Hostname = `plex.exampledomain.com`
* Settings -> Plex Media Server -> Plex Port = `443`
* Settings -> Plex Media Server -> Remote Server = `true`
* Settings -> Plex Media Server -> Use SSL = `true`
* Settings -> Plex Media Server -> Manual Connection = `true`

Enable basic authorization.
* Settings -> Access Control -> Use Basic Authentication = `true`

### Hydra

Set the public url so remote api commands don't return an unreachable link.
* Config -> Main -> External URL = `https://hydra.exampledomain.com`

Enable basic authorization.
* Config -> Authorization -> Auth Type = `HTTP Basic auth`

### Sonarr

Add the local hydra indexer connection details.
* Settings -> Indexers -> Add = `Type: newsnab` `URL: http://hydra:5075`

Add the local nzbget download client connection details.
* Settings -> Download Client -> Add = `Type: nzbget` `Host: nzbget` `Port: 6789`

### Radarr

Add the local hydra indexer connection details.
* Settings -> Indexers -> Add = `Type: newsnab` `URL: http://hydra:5075`

Add the local nzbget download client connection details.
* Settings -> Download Client -> Add = `Type: nzbget` `Host: nzbget` `Port: 6789`

## Author

Kyle Harding <kylemharding@gmail.com>

## Acknowledgments

I didn't create any of these docker images myself, so credit goes to the
maintainers, and the app creators themselves.

* https://www.plex.tv
* https://www.linuxserver.io

## License

MIT License