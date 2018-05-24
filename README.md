# Docker Plex & Usenet Media Server #

This is a Docker-based Plex Media Server setup for ubuntu using public images from Docker Hub.

The following services are enabled by default:

|service|image|example url|
|---|---|---|
|[plex](plex.tv)|[plexinc/pms-docker](https://hub.docker.com/r/plexinc/pms-docker/)|`plex.exampledomain.com`|
|[tautulli](http://tautulli.com/)|[tautulli/tautulli](https://hub.docker.com/r/tautulli/tautulli/)|`tautulli.exampledomain.com`|
|[hydra](github.com/theotherp/nzbhydra)|[linuxserver/hydra](https://hub.docker.com/r/linuxserver/hydra/)|`hydra.exampledomain.com`|
|[sonarr](sonarr.tv)|[linuxserver/sonarr](https://hub.docker.com/r/linuxserver/sonarr/)|`sonarr.exampledomain.com`|
|[radarr](radarr.video)|[linuxserver/radarr](https://hub.docker.com/r/linuxserver/radarr/)|`radarr.exampledomain.com`|
|[nzbget](nzbget.net)|[linuxserver/nzbget](https://hub.docker.com/r/linuxserver/nzbget/)|`nzbget.exampledomain.com`|
|[transmission](transmissionbt.com)|[linuxserver/transmission](https://hub.docker.com/r/linuxserver/transmission/)|`transmission.exampledomain.com`|
|[caddy](https://caddyserver.com/)|[abiosoft/caddy-docker](https://hub.docker.com/r/abiosoft/caddy/)|n/a|

## Getting Started

### Prerequisites

* (recommended) Dedicated server with plenty of storage
(_tested with [Kimsufi](https://www.kimsufi.com/ca/en/servers.xml)_)
* Custom domain with configurable sub-domains
(_tested with [namecheap](https://www.namecheap.com/)_)
* [Cloudflare DNS](https://www.cloudflare.com/)
* (recommended) Debian OS (not ARM)
(_tested with [Ubuntu Server](https://www.ubuntu.com/download/server) x64 16.04_)

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

**common.env**
* Set `PUID` and `PGID` to the output of `id -u` and `id -g` respectively
* Set `TZ` to your local [unix timezone](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)

**caddy.env**
* Set `ACME_AGREE` to `true` if you agree to the [Letsencrypt TOS](https://docs.google.com/viewer?url=https%3A%2F%2Fletsencrypt.org%2Fdocuments%2F2017.11.15-LE-SA-v1.2.pdf&pdf=true)
* Set `CLOUDFLARE_EMAIL` to your registered Cloudflare email address
* Set `CLOUDFLARE_API_KEY` to your [Cloudflare api key](https://support.cloudflare.com/hc/en-us/articles/200167836-Where-do-I-find-my-Cloudflare-API-key-)

**plex.env**
* Set `ADVERTISE_IP` to `https://plex.yourdomain.com:443`
* Set `PLEX_UID` and `PLEX_GID` to the output of `id -u` and `id -g` respectively
* Set `PLEX_CLAIM` to a new token obtained at https://www.plex.tv/claim

**Caddyfile**
* Add your custom domain to each of the opening blocks above `gzip`
* Add a password to any of the `basicauth` lines

## Deploy

```bash
docker-compose up -d
```

## Usage

**Tautulli**
* Settings -> Plex Media Server -> Plex IP or Hostname = `plex`
* Settings -> Plex Media Server -> Plex Port = `32400`
* Settings -> Access Control -> Use Basic Authentication = `true`

**Hydra**
* Config -> Main -> External URL = `https://hydra.mydomain.com`
* Config -> Authorization -> Auth Type = `HTTP Basic auth`

**Radarr/Sonarr**
* Settings -> Indexers -> Add = `Type: newsnab` `URL: http://hydra:5075`
* Settings -> Download Client -> Add = `Type: nzbget` `Host: nzbget` `Port: 6789`

## Author

Kyle Harding <kylemharding@gmail.com>

## Acknowledgments

I didn't create any of these docker images myself, so credit goes to the
maintainers, and the app creators themselves.

## License

MIT License