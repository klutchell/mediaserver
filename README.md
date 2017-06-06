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
* [linuxserver/letsencrypt](https://hub.docker.com/r/linuxserver/letsencrypt/)

## Benefits

While the advantages/disadvantages of using docker containers for web services
are covered in detail elsewhere, here's why I prefer this setup for my media server.

* only one application to install (docker engine)
* all my config and databases are stored in one place (or more if I prefer)
* migrating to a new server is painless
* uptime is reliable with docker stack

## Requirements

### Operating system
These instructions assume you are using **Ubuntu x64 16.04** or later.

It may work on other distros but this is what I'm running :)

### Custom domain
These instructions assume you own a custom domain with `plex.` and `app.` as subdomains.

The idea is that once configured, all your services will be available at the
following urls:
* `plex.<your-domain>.com`
* `app.<your-domain>.com/plexpy`
* `app.<your-domain>.com/hydra`
* `app.<your-domain>.com/sonarr`
* `app.<your-domain>.com/radarr`
* `app.<your-domain>.com/nzbget`
* `app.<your-domain>.com/transmission`
* `app.<your-domain>.com/portainer`

If you want to avoid this you can still use most of the project features, but you
will have to adjust the [letsencrypt configuration](#letsencrypt) a bit.

### CloudFlare

I'm also using [CloudFlare](https://cloudflare.com) to improve plex performance,
but that should be considered optional.

## Installation
### Install Docker

Install docker engine.
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

### Initialize Swarm

I've switched to docker stack where I was previously using docker-compose.
It requires we initialize a master swarm node before adding services to the stack.
I haven't tried multiple nodes yet.
```bash
$ docker swarm init
```
_See https://docs.docker.com/engine/reference/commandline/stack/ for additonal
command line options._

## Configuration

### Docker Compose

The docker-compose file in the project root defines the services that will be created.

The only thing I recommend changing in here are the local volume paths, especially
if the plex/media folder needs to be on an external drive. Symlinks are allowed
and it makes it easier to point some volumes to large mount points.
By default, most volumes are mounted to subdirectories of the project root.

`docker-compose.yml`

_See https://docs.docker.com/compose/compose-file/ for supported values._

### User/Group
Provide the desired id that the containers should use when running.
This is helpful to maintain ownership of the config files and databases.

`common.env`
* `PUID=<your-usr-id>`
* `PGID=<your-grp-id>`

_Run `id -u` and `id -g` to find the ID of your current user and group._

### Letsencrypt
Provide the environment variables required by the letsencrypt image.

`letsencrypt.env`
* `EMAIL=<your-email>.com`
* `URL=<your-domain>.com`
* `SUBDOMAINS=plex,app`
* `ONLY_SUBDOMAINS=true`

_See https://github.com/linuxserver/docker-letsencrypt for a description of
each field._

Hopefully you don't have to change these if you are using the [expected sub-domains](#custom-domain),
but here they are just in case.
* `./letsencrypt/config/nginx/site-confs/default`
* `./letsencrypt/config/nginx/site-confs/plex.conf`
* `./letsencrypt/config/nginx/auth.conf`
* `./letsencrypt/config/nginx/nginx.conf`
* `./letsencrypt/config/nginx/proxy.conf`
* `./letsencrypt/config/nginx/ssl.conf`

_See https://github.com/toomuchio/plex-nginx-reverseproxy for additional plex
reverse-proxy suggestions._

### Plex
Provide the environment variables required by the plex image.

`plex.env`
* `PLEX_UID=<your-usr-id>`
* `PLEX_GID=<your-grp-id>`
* `PLEX_CLAIM=<your-claim-token>`

_See https://github.com/plexinc/pms-docker for a description of each field._

Set the remote mapping port to 443 and set secure connections to preferred.

`./plex/config/Library/Application Support/Plex Media Server/Preferences.xml`
* `ManualPortMappingMode="1"`
* `ManualPortMappingPort="443"`
* `customConnections="https://plex.<your-domain>.com:443"`
* `secureConnections="1"`

_[Create](#create-stack) the stack once in order to have this config file generated._

If the web interface is available you can change some settings from there.
* Settings -> Server -> Remote Access -> Manually specify public port = `443`
* Settings -> Server -> Network -> Custom server access URLs = `https://plex.<your-domain>:443`
* Settings -> Server -> Network -> Secure connections = `Preferred`

### Plexpy
Set the base-url so it can be used with our nginx proxy. Also set the plex server details.

`./plexpy/config/config.ini`
* `http_root = /plexpy`
* `pms_ip = plex`
* `pms_port = 32400`
* `pms_ssl = 1`

_[Create](#create-stack) the stack once in order to have this config file generated._

If the web interface is available you can change some settings from there.
* Settings -> Web Interface -> HTTP Root = `/plexpy`
* Settings -> Plex Media Server -> Plex IP or Hostname = `plex`
* Settings -> Plex Media Server -> Plex Port = `32400`
* Settings -> Plex Media Server -> Use SSL = `true`

### Hydra
Set the base-url so it can be used with our nginx proxy.

`./hydra/config/hydra/settings.cfg`
* `"urlBase": "/hydra"`
* `"externalUrl": "https://app.<your-domain>.com/hydra"`

_[Create](#create-stack) the stack once in order to have this config file generated._

If the web interface is available you can change some settings from there.
* Config -> URL base = `/hydra`
* Config -> External URL = `https://app.<your-domain>.com/hydra`

### Sonarr
Set the base-url so it can be used with our nginx proxy.

`./sonarr/config/config.xml`
* `<UrlBase>/sonarr</UrlBase>`

_[Create](#create-stack) the stack once in order to have this config file generated._

If the web interface is available you can change some settings from there.
* Settings -> General -> URL Base = `/sonarr`
* Settings -> Indexers -> Add = `Type: newsnab` `URL: http://hydra:5075/hydra`
* Settings -> Download Client -> Add = `Type: nzbget` `Host: nzbget` `Port: 6789`

### Radarr
Set the base-url so it can be used with our nginx proxy.

`./radarr/config/config.xml`
* `<UrlBase>/radarr</UrlBase>`

_[Create](#create-stack) the stack once in order to have this config file generated._

If the web interface is available you can change some settings from there.
* Settings -> General -> URL Base = `/radarr`
* Settings -> Indexers -> Add `Type: newsnab` `URL: http://hydra:5075/hydra`
* Settings -> Download Client -> Add `Type: nzbget` `Host: nzbget` `Port: 6789`

### Transmission
Set the base-url so it can be used with our nginx proxy.

`./transmission/config/settings.json`
* `"rpc-url": "/transmission/"`

_[Create](#create-stack) the stack once in order to have this config file generated._

### Nzbget

Nzbget manages to be reachable even without changing the base-url, but here's the
config location.

`./nzbget/config/nzbget.conf`

_[Create](#create-stack) the stack once in order to have this config file generated._

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

* http://portainer.io/
* https://www.plex.tv/
* https://www.linuxserver.io/
* https://nginx.com
* https://cloudflare.com
* https://docs.docker.com/engine/installation/
* https://docs.docker.com/engine/reference/commandline/stack/
* https://docs.docker.com/compose/compose-file/
* https://github.com/plexinc/pms-docker
* https://github.com/linuxserver/docker-letsencrypt
* https://github.com/toomuchio/plex-nginx-reverseproxy
* https://hub.docker.com/r/plexinc/pms-docker/
* https://hub.docker.com/r/portainer/portainer/
* https://hub.docker.com/r/linuxserver/nzbget/
* https://hub.docker.com/r/linuxserver/sonarr/
* https://hub.docker.com/r/linuxserver/radarr/
* https://hub.docker.com/r/linuxserver/plexpy/
* https://hub.docker.com/r/linuxserver/transmission/
* https://hub.docker.com/r/linuxserver/hydra/
* https://hub.docker.com/r/linuxserver/letsencrypt/
