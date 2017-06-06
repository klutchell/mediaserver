# Docker Plex & Usenet Media Server #

## Description

This is a Docker-based Plex Media Server setup for ubuntu using public images from Docker Hub.
I didn't create any of these docker images myself, so credit goes to the linked authors.

Image | Size | Version
--- | --- | ---
[plexinc/pms-docker](https://hub.docker.com/r/plexinc/pms-docker/) | [![](https://images.microbadger.com/badges/image/plexinc/pms-docker.svg)](https://microbadger.com/images/plexinc/pms-docker) | [![](https://images.microbadger.com/badges/version/plexinc/pms-docker.svg)](https://microbadger.com/images/plexinc/pms-docker)
[portainer/portainer](https://hub.docker.com/r/portainer/portainer/) | [![](https://images.microbadger.com/badges/image/portainer/portainer.svg)](https://microbadger.com/images/portainer/portainer) | [![](https://images.microbadger.com/badges/version/portainer/portainer.svg)](https://microbadger.com/images/portainer/portainer)
[linuxserver/nzbget](https://hub.docker.com/r/linuxserver/nzbget/) | [![](https://images.microbadger.com/badges/image/linuxserver/nzbget.svg)](https://microbadger.com/images/linuxserver/nzbget) | [![](https://images.microbadger.com/badges/version/linuxserver/nzbget.svg)](https://microbadger.com/images/linuxserver/nzbget)
[linuxserver/sonarr](https://hub.docker.com/r/linuxserver/sonarr/) | [![](https://images.microbadger.com/badges/image/linuxserver/sonarr.svg)](https://microbadger.com/images/linuxserver/sonarr) | [![](https://images.microbadger.com/badges/version/linuxserver/sonarr.svg)](https://microbadger.com/images/linuxserver/sonarr)
[linuxserver/radarr](https://hub.docker.com/r/linuxserver/radarr/) | [![](https://images.microbadger.com/badges/image/linuxserver/radarr.svg)](https://microbadger.com/images/linuxserver/radarr) | [![](https://images.microbadger.com/badges/version/linuxserver/radarr.svg)](https://microbadger.com/images/linuxserver/radarr)
[linuxserver/plexpy](https://hub.docker.com/r/linuxserver/plexpy/) | [![](https://images.microbadger.com/badges/image/linuxserver/plexpy.svg)](https://microbadger.com/images/linuxserver/plexpy) | [![](https://images.microbadger.com/badges/version/linuxserver/plexpy.svg)](https://microbadger.com/images/linuxserver/plexpy)
[linuxserver/transmission](https://hub.docker.com/r/linuxserver/transmission/) | [![](https://images.microbadger.com/badges/image/linuxserver/transmission.svg)](https://microbadger.com/images/linuxserver/transmission) | [![](https://images.microbadger.com/badges/version/linuxserver/transmission.svg)](https://microbadger.com/images/linuxserver/transmission)
[linuxserver/hydra](https://hub.docker.com/r/linuxserver/hydra/) | [![](https://images.microbadger.com/badges/image/linuxserver/hydra.svg)](https://microbadger.com/images/linuxserver/hydra) | [![](https://images.microbadger.com/badges/version/linuxserver/hydra.svg)](https://microbadger.com/images/linuxserver/hydra)
[linuxserver/letsencrypt](https://hub.docker.com/r/linuxserver/letsencrypt/) | [![](https://images.microbadger.com/badges/image/linuxserver/letsencrypt.svg)](https://microbadger.com/images/linuxserver/letsencrypt "linuxserver/letsencrypt") | [![](https://images.microbadger.com/badges/version/linuxserver/letsencrypt.svg)](https://microbadger.com/images/linuxserver/letsencrypt)

## Requirements

### Operating system
These instructions assume you are using **Ubuntu x64 16.04** or later.

It may work on other distros but this is what I'm running :)

### Custom domain
These instructions assume you own a custom domain with `plex.` and `app.` as subdomains.

The idea is that once configured, all your services will be available at the
following urls:
* plex: `plex.<your-domain>.com`
* plexpy: `app.<your-domain>.com/plexpy`
* hydra: `app.<your-domain>.com/hydra`
* sonarr: `app.<your-domain>.com/sonarr`
* radarr: `app.<your-domain>.com/radarr`
* nzbget: `app.<your-domain>.com/nzbget`
* transmission: `app.<your-domain>.com/transmission`
* portainer: `app.<your-domain>.com/portainer`

I'm also using [CloudFlare](cloudflare.com), but that should be considered optional.

If you want to avoid this you can still use most of the project features, but you
will have to adjust the letsencrypt configuration a little bit.

## Installation
### Install Docker

Install [docker engine](https://docs.docker.com/engine/installation/).
```bash
$ curl -sSL get.docker.com | sh
```

### Clone Repo

Clone the repo to somewhere convenient with reasonable storage available.
```bash
$ git clone git@github.com:klutchell/mediaserver.git ~/mediaserver
```
You can change data and media paths in a later step.

### Initialize Swarm

I've switched to [docker stack](https://docs.docker.com/engine/reference/commandline/stack/) where I was previously using docker-compose.
It requires we initialize a master swarm node before adding services to the stack.
I haven't tried multiple nodes yet.
```bash
$ docker swarm init
```

## Configuration

### Docker Compose

The docker-compose file in the project root defines the services that will be created.

The only thing I recommend changing in here are the local volume paths, especially
if the plex/media folder needs to be on an external drive. Symlinks are allowed
and it makes it easier to point some volumes to large mount points.
By default, most volumes are mounted to subdirectories of the project root.

* `docker-compose.yml`

_See https://docs.docker.com/compose/compose-file/ for supported values._

### User ID
Provide the desired id that the containers should use when running.
This is helpful to maintain ownership of the config files and databases.
* `common.env`
  * `PUID=1000`
  * `PGID=1000`

_Run `id -u` to find the ID of your current user._
_Run `id -g` to find the ID of your current group._

### Letsencrypt
Provide the environment variables required by the letsencrypt image.
* `letsencrypt.env`
  * `EMAIL=<your-email>.com`
  * `URL=<your-domain>.com`
  * `SUBDOMAINS=plex,app`
  * `ONLY_SUBDOMAINS=true`

_See https://github.com/linuxserver/docker-letsencrypt for a description of
each field._

### Plex
Provide the environment variables required by the plex image.
* `plex.env`
  * `PLEX_UID=1000`
  * `PLEX_GID=1000`
  * `PLEX_CLAIM=<your-claim-token>`

_See https://github.com/plexinc/pms-docker for a description of each field._

Set the remote mapping port to 443 and set secure connections to preferred.
* `./plex/config/Library/Application Support/Plex Media Server/Preferences.xml`
  * `ManualPortMappingMode="1"`
  * `ManualPortMappingPort="443"`
  * `customConnections="https://plex.<your-domain>.com:443"`
  * `secureConnections="1"`

_[Create](#Create Stack) the stack once in order to have this config file generated,
then [remove](#Remove Stack) it to make the required edits._

If the web interface is available you can change some settings from there.
* Settings -> Server -> Remote Access -> Manually specify public port = `443`
* Settings -> Server -> Network -> Custom server access URLs = `https://plex.<your-domain>:443`
* Settings -> Server -> Network -> Secure connections = `Preferred`

### Plexpy
Set the base-url so it can be used with our nginx proxy. Also set the plex server details.
* `./plexpy/config/config.ini`
  * `http_root = /plexpy`
  * `pms_ip = plex`
  * `pms_port = 32400`
  * `pms_ssl = 1`

_[Create](#Create Stack) the stack once in order to have this config file generated,
then [remove](#Remove Stack) it to make the required edits._

If the web interface is available you can change some settings from there.
* Settings -> Web Interface -> HTTP Root = `/plexpy`
* Settings -> Plex Media Server -> Plex IP or Hostname = `plex`
* Settings -> Plex Media Server -> Plex Port = `32400`
* Settings -> Plex Media Server -> Use SSL = `true`

### Hydra
Set the base-url so it can be used with our nginx proxy.
* `./hydra/config/hydra/settings.cfg`
  * `"urlBase": "/hydra"`
  * `"externalUrl": "https://app.<your-domain>.com/hydra"`

_[Create](#Create Stack) the stack once in order to have this config file generated,
then [remove](#Remove Stack) it to make the required edits._

If the web interface is available you can change some settings from there.
* Config -> URL base = `/hydra`
* Config -> External URL = `https://app.<your-domain>.com/hydra`

### Sonarr
Set the base-url so it can be used with our nginx proxy.
* `./sonarr/config/config.xml`
  * `<UrlBase>/sonarr</UrlBase>`

_[Create](#Create Stack) the stack once in order to have this config file generated,
then [remove](#Remove Stack) it to make the required edits._

If the web interface is available you can change some settings from there.
* Settings -> General -> URL Base = `/sonarr`
* Settings -> Indexers -> Add = `Type: newsnab` `URL: http://hydra:5075/hydra`
* Settings -> Download Client -> Add = `Type: nzbget` `Host: nzbget` `Port: 6789`

### Radarr
Set the base-url so it can be used with our nginx proxy.
* `./radarr/config/config.xml`
  * `<UrlBase>/radarr</UrlBase>`

_[Create](#Create Stack) the stack once in order to have this config file generated,
then [remove](#Remove Stack) it to make the required edits._

If the web interface is available you can change some settings from there.
* Settings -> General -> URL Base = `/radarr`
* Settings -> Indexers -> Add `Type: newsnab` `URL: http://hydra:5075/hydra`
* Settings -> Download Client -> Add `Type: nzbget` `Host: nzbget` `Port: 6789`

### Transmission
Set the base-url so it can be used with our nginx proxy.
* `./transmission/config/settings.json`
  * `"rpc-url": "/transmission/"`

_[Create](#Create Stack) the stack once in order to have this config file generated,
then [remove](#Remove Stack) it to make the required edits._

### Nzbget

* `./nzbget/config/nzbget.conf`

_[Create](#Create Stack) the stack once in order to have this config file generated,
then [remove](#Remove Stack) it to make the required edits._

### Portainer

_tbd_

### UFW
Although docker will automatically add some firewall rules, I find some services still work better
if http/https traffic is allowed manually through UFW.
```bash
$ sudo ufw allow http
$ sudo ufw allow https
```

### CloudFlare (optional)
* SSL set to at least Full
* Firewall disabled if an abnormal amount of load is expected

## Usage
### Create Stack

Create a new stack with all of our configured services in the compose file.
```bash
$ docker stack deploy --compose-file docker-compose.yml mediaserver
```

### Update Stack

The same deploy command will pull the latest images and update containers as needed.
```bash
$ docker stack deploy --compose-file docker-compose.yml mediaserver
```
This step will leave the old containers and images behind. You can cleanup with the following command.
```bash
$ docker system prune
```

### Remove Stack

This will stop all containers and remove the stack. Useful for modifying multiple configuration files as described above.
```bash
$ docker stack rm mediaserver
```

### Stop A Service

As an example, this will stop the letsencrypt service.
```bash
$ docker service scale mediaserver_letsencrypt=0
```

### Start A Service

As an example, this will start the letsencrypt service.
```bash
$ docker service scale mediaserver_letsencrypt=1
```

### Update A Service

As an example, this will pull the latest letsencrypt image and update the service.
```bash
$ docker service update --force --image linuxserver/letsencrypt mediaserver_letsencrypt
```

## Author

Kyle Harding <kylemharding@gmail.com>

## References

* [compose-file](https://docs.docker.com/compose/compose-file/)
* [plex-nginx-reverseproxy](https://github.com/toomuchio/plex-nginx-reverseproxy)
* [portainer.io](http://portainer.io/)
* [plex.tv](https://www.plex.tv/)
* [linuxserver.io](https://www.linuxserver.io/)
