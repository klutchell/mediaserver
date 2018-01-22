# Docker Plex & Usenet Media Server #

This is a Docker-based Plex Media Server setup for ubuntu using public images from Docker Hub.

The following services are enabled by default:

|service|published url|
|---|---|
|[plex](plex.tv)|`plex.exampledomain.com`|
|[tautulli](jonnywong16.github.io/plexpy/)|`tautulli.exampledomain.com`|
|[hydra](github.com/theotherp/nzbhydra)|`hydra.exampledomain.com`|
|[sonarr](sonarr.tv)|`sonarr.exampledomain.com`|
|[radarr](radarr.video)|`radarr.exampledomain.com`|
|[nzbget](nzbget.net)|`nzbget.exampledomain.com`|
|[transmission](transmissionbt.com)|`transmission.exampledomain.com`|

## Getting Started

### Prerequisites

#### Custom domain

This guide assumes you own a custom domain (eg. `exampledomain.com`) with configurable
sub-domains (eg. `plex.exampledomain.com`).

A custom domain isn't expensive, and I'm using one from [namecheap](namecheap.com).

#### Dedicated server

Since obviously PLEX requires a ton of space for media, I'm using a dedicated server with 2TB of storage.

You could also use an old PC, or a VPS with mounted storage. PLEX Cloud is now an option as well if you are
comfortable with your media on a cloud provider.

This guide does not work on any ARM platform (including Raspberry PI) because the images I've included are not
compiled for ARM. In the future I may make a branch with arm images substituted.

This guide does not cover mounting external storage (FUSE or otherwise) or initial OS setup.
That's on you to sort out.

#### Debian OS

This guide assumes you are using a recent Debian-based OS.

_Tested with Ubuntu Server x64 16.04._

### Installation

#### 1. Clone Repo

Clone the repo to somewhere convenient with reasonable storage available.

```bash
$ git clone git@github.com:klutchell/mediaserver.git ~/mediaserver
```

_You can change data and media paths in a later step._

#### 2. Install Docker

See https://docs.docker.com/engine/installation/ for installation options.

_Tested with Docker version 17.09.0-ce._

### Configuration

#### 1. Forward DNS

I'm using CloudFlare for my DNS, since it's free and offers some features that you wouldn't
normally get with your domain registrar. These steps should be similar for other DNS providers though.

Forward the following A-level domains to your server public IP address (where `12.34.56.78` is your
server public-facing address).

|Type|Name|Value|TTL|Status|
|---|---|---|---|---|
|`A`|`plex`|`12.34.56.78`|`Automatic`|`DNS and HTTP proxy (CDN)`|
|`A`|`tautulli`|`12.34.56.78`|`Automatic`|`DNS and HTTP proxy (CDN)`|
|`A`|`hydra`|`12.34.56.78`|`Automatic`|`DNS and HTTP proxy (CDN)`|
|`A`|`sonarr`|`12.34.56.78`|`Automatic`|`DNS and HTTP proxy (CDN)`|
|`A`|`radarr`|`12.34.56.78`|`Automatic`|`DNS and HTTP proxy (CDN)`|
|`A`|`nzbget`|`12.34.56.78`|`Automatic`|`DNS and HTTP proxy (CDN)`|
|`A`|`transmission`|`12.34.56.78`|`Automatic`|`DNS and HTTP proxy (CDN)`|

**_Note for CloudFlare users_**

_I haven't been able to get letsencrypt to renew certificates while `Full (strict)`
SSL is enabled on CloudFlare, so for first run or when adding new services set it
to `Flexible` until the certs have been obtained.
Any tips or workarounds for this are appreciated!_

#### 2. Open Firewall Ports

Allow HTTP (80) and HTTPS (443) through your firewall. For UFW, it can be done with
this command.

```bash
$ sudo ufw allow http https
```

#### 3. Edit Compose File

The docker-compose file in the project root defines the services that will be created.

```bash
$ nano ./docker-compose.yml
```

From here you can:
* change volume paths (softlinks are allowed)
* remove unwanted services (keep nginx + docker-gen + letsencrypt)
* add new services

_See https://docs.docker.com/compose/compose-file/ for supported values._

#### 4. Set Environment Parameters

Most of the services require environment (.env) files that are sourced by the compose file.
I've included .env.example files for each of the default services.

For convenience, this script will iterate over the .env.example files and prompt for new values.

```bash
$ ./bin/set-env
```

#### 5. Enable HTTP Auth

It would be wise to protect most of your web services with http basic auth.
Create a htpasswd file for each web service you want to protect.

```bash
$ htpasswd -bc ./nginx/htpasswd/sonarr.exampledomain.com username password
$ htpasswd -bc ./nginx/htpasswd/radarr.exampledomain.com username password
$ htpasswd -bc ./nginx/htpasswd/nzbget.exampledomain.com username password
$ htpasswd -bc ./nginx/htpasswd/transmission.exampledomain.com username password
```

_Tautulli, Plex, and Hydra all work better if built-in authentication is used
rather than http basic auth._

_See https://github.com/jwilder/nginx-proxy#basic-authentication-support for more info._

## Deployment

### Deploy Stack

Deploy a new stack or update an existing stack with all of our configured services in the compose file.

```bash
$ ./bin/deploy-all
```

### Connect Services

#### Tautulli

Add the local plex media server connection details.
* Settings -> Plex Media Server -> Plex IP or Hostname = `plex`
* Settings -> Plex Media Server -> Plex Port = `32400`
* Settings -> Plex Media Server -> Use SSL = `true`

#### Hydra

Set the public url so remote api commands don't return an unreachable link.
* Config -> Main -> External URL = `https://hydra.exampledomain.com`

Enable built-in authorization so services using the API key still have full access
and are not blocked by HTTP basic auth.
* Config -> Authorization -> Auth Type = `Login form`

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

* https://hub.docker.com/r/plexinc/pms-docker/
* https://hub.docker.com/r/linuxserver/nzbget/
* https://hub.docker.com/r/linuxserver/sonarr/
* https://hub.docker.com/r/linuxserver/radarr/
* https://hub.docker.com/r/shiggins8/tautulli/
* https://hub.docker.com/r/linuxserver/transmission/
* https://hub.docker.com/r/linuxserver/hydra/
* https://hub.docker.com/r/helder/docker-gen/
* https://hub.docker.com/r/jrcs/letsencrypt-nginx-proxy-companion/
* https://hub.docker.com/_/nginx/

## License

MIT License