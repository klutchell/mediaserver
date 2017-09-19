# Docker Plex & Usenet Media Server #

## Description

This is a Docker-based Plex Media Server setup for ubuntu using public images from Docker Hub.
I didn't create any of these docker images myself, so credit goes to the linked authors.

* [plexinc/pms-docker](https://hub.docker.com/r/plexinc/pms-docker/)
* [portainer/portainer](https://hub.docker.com/r/portainer/portainer/)
* [linuxserver/nzbget](https://hub.docker.com/r/linuxserver/nzbget/)
* [linuxserver/sonarr](https://hub.docker.com/r/linuxserver/sonarr/)
* [linuxserver/radarr](https://hub.docker.com/r/linuxserver/radarr/)
* [linuxserver/plexpy](https://hub.docker.com/r/linuxserver/plexpy/)
* [linuxserver/transmission](https://hub.docker.com/r/linuxserver/transmission/)
* [linuxserver/hydra](https://hub.docker.com/r/linuxserver/hydra/)
* [helder/docker-gen](https://hub.docker.com/r/helder/docker-gen/)
* [jrcs/letsencrypt-nginx-proxy-companion](https://hub.docker.com/r/jrcs/letsencrypt-nginx-proxy-companion/)
* [nginx](https://hub.docker.com/_/nginx/)
* [firehol/netdata](https://hub.docker.com/r/firehol/netdata/)

## Benefits

While the advantages/disadvantages of using docker containers for web services
are covered in detail elsewhere, here's why I prefer this setup for my media server.

* only one application to install (docker engine)
* all my config and databases are stored in one place (or more if I prefer)
* migrating to a new server is painless
* uptime is reliable with docker stack

## Suggested Prerequisites

### Dedicated server

Since obviously PLEX requires a ton of space for media, I'm using a dedicated server with 2TB of storage.

You could also use an old PC, or a VPS with mounted storage. PLEX Cloud is now an option as well if you are
comfortable with your media on a cloud provider.

This guide does not work on any ARM platform (including Raspberry PI) because the images I've included are not
compiled for ARM. In the future I may make a branch with arm images substituted.

This guide does not cover mounting external storage (FUSE or otherwise) or initial OS setup.
That's on you to sort out.

### Debian OS

This guide assumes you are using **Ubuntu Server x64 16.04** or later.

It will likely work on other x86/x64 Debian distros but this is what I'm running.

### Custom domain

This guide assumes you own a custom domain with configurable sub-domains similar to the following.

  * `plex.yourdomain.com`
  * `plexpy.yourdomain.com`
  * `hydra.yourdomain.com`
  * `sonarr.yourdomain.com`
  * `radarr.yourdomain.com`
  * `nzbget.yourdomain.com`
  * `transmission.yourdomain.com`
  * `portainer.yourdomain.com`
  * `netdata.yourdomain.com`

A custom domain isn't expensive, and I'm using one from [namecheap](namecheap.com).

### CloudFlare

I'm also using [CloudFlare](https://cloudflare.com) (free) for my DNS provider,
but that should be considered optional.

## Installation
### Install Docker

Install docker engine if you don't already have it.
```bash
$ curl -sSL get.docker.com | sh
$ sudo usermod -aG docker "$(who am i | awk '{print $1}')"
```
_See https://docs.docker.com/engine/installation/ for additional installation options._

### Clone Repo

Clone the repo to somewhere convenient with reasonable storage available.
```bash
$ git clone git@github.com:klutchell/mediaserver.git ~/mediaserver
```
_You can change data and media paths in a later step._

## CloudFlare Configuration

I'm using CloudFlare for my DNS, since it's free and offers some features that you wouldn't
normally get with your domain registrar.

### DNS

Forward the following A-level domains to your server public IP address (where `12.34.56.78` is your
server public-facing address).

|Type|Name|Value|TTL|Status|
|---|---|---|---|---|
|`A`|`plex`|`12.34.56.78`|`Automatic`|`DNS and HTTP proxy (CDN)`|
|`A`|`plexpy`|`12.34.56.78`|`Automatic`|`DNS and HTTP proxy (CDN)`|
|`A`|`hydra`|`12.34.56.78`|`Automatic`|`DNS and HTTP proxy (CDN)`|
|`A`|`sonarr`|`12.34.56.78`|`Automatic`|`DNS and HTTP proxy (CDN)`|
|`A`|`radarr`|`12.34.56.78`|`Automatic`|`DNS and HTTP proxy (CDN)`|
|`A`|`nzbget`|`12.34.56.78`|`Automatic`|`DNS and HTTP proxy (CDN)`|
|`A`|`transmission`|`12.34.56.78`|`Automatic`|`DNS and HTTP proxy (CDN)`|
|`A`|`portainer`|`12.34.56.78`|`Automatic`|`DNS and HTTP proxy (CDN)`|
|`A`|`netdata`|`12.34.56.78`|`Automatic`|`DNS and HTTP proxy (CDN)`|

### Crypto

I haven't been able to get letsencrypt to renew certificates while `Full (strict)`
SSL is enabled on CloudFlare, so for first run or when adding new services set it
to `Flexible` until the certs have been obtained.

Any tips or workarounds for this are appreciated!

## Server Configuration

### Firewall

Allow HTTP (80) and HTTPS (443) through your firewall.

### Compose File

The docker-compose file in the project root defines the services that will be created.

The only thing I recommend changing in here are the local volume paths, especially
if the plex/media folder needs to be on an external drive. Symlinks are allowed
and it makes it easier to point some volumes to large mount points.
By default, most volumes are mounted to subdirectories of the project root.

* `./docker-compose.yml`

_See https://docs.docker.com/compose/compose-file/ for supported values._

### Environment Files

Most of the services have environment files that are sourced by the compose file.
Some of the fields are required and are populated with fake data so be sure to
review and update them as necessary.

* `./radarr/radarr.env`
* `./portainer/portainer.env`
* `./transmission/transmission.env`
* `./plexpy/plexpy.env`
* `./hydra/hydra.env`
* `./nginx/letsencrypt.env`
* `./plex/plex.env`
* `./nzbget/nzbget.env`
* `./sonarr/sonarr.env`
* `./netdata/netdata.env`

If you don't update these environment files with your domain and email at the very least,
letsencrypt will not be able to register your SSL certificates.

### HTTP Auth

It would be wise to protect most of your web services with http basic auth.
Create a htpasswd file for each web service you want to protect.
```bash
$ htpasswd -bc ./nginx/htpasswd/plexpy.yourdomain.com username password
$ htpasswd -bc ./nginx/htpasswd/sonarr.yourdomain.com username password
$ htpasswd -bc ./nginx/htpasswd/radarr.yourdomain.com username password
$ htpasswd -bc ./nginx/htpasswd/nzbget.yourdomain.com username password
$ htpasswd -bc ./nginx/htpasswd/transmission.yourdomain.com username password
$ htpasswd -bc ./nginx/htpasswd/netdata.yourdomain.com username password
```
Portainer, Plex, and Hydra all work better if built-in authentication is used
rather than http basic auth.

_See https://github.com/jwilder/nginx-proxy#basic-authentication-support for more info._

## Usage

### Deploy Stack

Deploy a new stack or update an existing stack with all of our configured services in the compose file.
```bash
$ bin/deploy-all
```

### Connect Services

#### Plexpy

Add the local plex media server connection details.
* Settings -> Plex Media Server -> Plex IP or Hostname = `plex`
* Settings -> Plex Media Server -> Plex Port = `32400`
* Settings -> Plex Media Server -> Use SSL = `true`

#### Hydra

Set the public url so remote api commands don't return an unreachable link.
* Config -> Main -> External URL = `https://hydra.yourdomain.com`

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

## References

* https://docs.docker.com/engine/installation/
* https://docs.docker.com/engine/reference/commandline/stack/
* https://docs.docker.com/compose/compose-file/
* https://github.com/plexinc/pms-docker
* https://github.com/JrCs/docker-letsencrypt-nginx-proxy-companion
* https://github.com/linuxserver/docker-hydra
* https://github.com/linuxserver/docker-nzbget
* https://github.com/linuxserver/docker-plexpy
* https://github.com/portainer/portainer
* https://github.com/linuxserver/docker-radarr
* https://github.com/linuxserver/docker-sonarr
* https://github.com/linuxserver/docker-transmission
* https://github.com/firehol/netdata/wiki
* https://github.com/helderco/docker-gen
