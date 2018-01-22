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
|[docker-gen](https://github.com/helderco/docker-gen)|[helder/docker-gen](https://hub.docker.com/r/helder/docker-gen/)|n/a|
|[letsencrypt](https://letsencrypt.org/)|[jrcs/letsencrypt-nginx-proxy-companion](https://hub.docker.com/r/jrcs/letsencrypt-nginx-proxy-companion)|n/a|
|[nginx](https://www.nginx.com/)|[nginx](https://hub.docker.com/_/nginx/)|n/a|

## Getting Started

### Prerequisites

#### Custom domain

This guide assumes you own a custom domain (eg. `exampledomain.com`) with configurable
sub-domains (eg. `plex.exampledomain.com`).

_Tested with [namecheap](https://www.namecheap.com/) and [cloudflare](https://www.cloudflare.com/)._

#### Debian OS

This guide assumes you are using a recent Debian-based OS.

_Tested with Ubuntu Server x64 16.04._

#### Docker

See https://docs.docker.com/engine/installation/ for installation options.

_Tested with Docker version 17.09.0-ce and higher._

### Installation

#### 1. Clone Repo

Clone the repo to somewhere convenient with reasonable storage available.

```bash
git clone git@github.com:klutchell/mediaserver.git ~/mediaserver
```

_You can change data and media paths in a later step._

#### 2. Forward DNS

Forward any desired A-level domains to your server public IP address. Suggested services
and domains are listed in the description.

**Example:**
Type A : plex.exampledomain.com -> [server public ip]
Type A : tautulli.exampledomain.com -> [server public ip]
etc...

#### 3. Open Firewall Ports

Allow HTTP (80) and HTTPS (443) through your firewall. For UFW, it can be done with
this command.

```bash
sudo ufw allow http https
```

#### 4. Edit Compose File

The docker-compose file in the project root defines the services that will be created.

```bash
nano ./docker-compose.yml
```

From here you can:
* change volume paths (softlinks are allowed)
* remove unwanted services (keep nginx + docker-gen + letsencrypt)
* add new services

_See https://docs.docker.com/compose/compose-file/ for supported values._

#### 5. Set Environment Parameters

Most of the services require environment (.env) files that are sourced by the compose file.
I've included .env.example files for each of the default services.

For convenience, this script will iterate over the .env.example files and prompt for new values.

```bash
./bin/set-env
```

#### 6. Enable HTTP Auth

Either enable authentication on each service manually, or use nginx to prompt for
basic http authentication (safer).

```bash
# create an htpasswd file for each web service you want to protect at the nginx level
htpasswd -bc ./nginx/htpasswd/sonarr.exampledomain.com username password
htpasswd -bc ./nginx/htpasswd/radarr.exampledomain.com username password
htpasswd -bc ./nginx/htpasswd/nzbget.exampledomain.com username password
htpasswd -bc ./nginx/htpasswd/transmission.exampledomain.com username password
# etc...
```

Plex, tautulli, and hydra expose APIs that use tokens so I use the included
auth features for those services.

_See https://github.com/jwilder/nginx-proxy#basic-authentication-support for more info._

## Deployment

### Deploy Stack

Deploy a new stack or update an existing stack with all of our configured services in the compose file.

```bash
./bin/deploy-all
```

### Connect Services

#### Tautulli

Add the local plex media server connection details.
* Settings -> Plex Media Server -> Plex IP or Hostname = `plex.exampledomain.com`
* Settings -> Plex Media Server -> Plex Port = `443`
* Settings -> Plex Media Server -> Remote Server = `true`
* Settings -> Plex Media Server -> Use SSL = `true`
* Settings -> Plex Media Server -> Manual Connection = `true`

Enable basic authorization.
* Settings -> Access Control -> Use Basic Authentication = `true`

#### Hydra

Set the public url so remote api commands don't return an unreachable link.
* Config -> Main -> External URL = `https://hydra.exampledomain.com`

Enable basic authorization.
* Config -> Authorization -> Auth Type = `HTTP Basic auth`

#### Sonarr

Add the local hydra indexer connection details.
* Settings -> Indexers -> Add = `Type: newsnab` `URL: http://hydra:5075`

Add the local nzbget download client connection details.
* Settings -> Download Client -> Add = `Type: nzbget` `Host: nzbget` `Port: 6789`

#### Radarr

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
* https://github.com/helderco/docker-gen
* https://github.com/JrCs/docker-letsencrypt-nginx-proxy-companion

## License

MIT License