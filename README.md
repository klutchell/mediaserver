# Docker Plex & Usenet Media Server #

## Description

This is a docker-based plex media server for ubuntu using pre-built public images.

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

## Installation
### Install Dependencies

Install [docker engine](https://docs.docker.com/engine/installation/):
```bash
$ curl -sSL get.docker.com | sh
```

### Clone Repo

Clone the repo to somewhere convenient with reasonable storage available:
```bash
$ git clone git@github.com:klutchell/mediaserver.git ~/mediaserver
```

### Initialize Stack

I've switched to [docker stack](https://docs.docker.com/engine/reference/commandline/stack/) where I was previously using docker-compose.
It requires we initialize a master node before adding services. I haven't tried multiple nodes yet.
```bash
$ docker stack init
```

## Configuration
### Configure Compose File

Edit the compose file with desired volume paths:
```bash
$ nano ~/mediaserver/docker-compose.yml
```
Symlinks are allowed and it makes it easier to point some volumes to large mount points.

### Create Environment Files

Create environment files from the sample environment files before editing each of them with desired values:
```bash
$ for env in ~/mediaserver/*.env.sample; do cp "${env}" "${env%.sample}"; done
$ nano ~/mediaserver/*.env
```
https://docs.docker.com/compose/compose-file/#/envfile

### Manual Configuration

I don't have these bits automated yet, but some of the services will to have their configuration edited manually in order to be reachable behind nginx.
Create the stack once in order to have these config files generated, then remove it to make the required edits. See **Create Stack** and **Remove Stack** below.

service | config file | new value
--- | --- | ---
hydra | `hydra/config/hydra/settings.cfg` | `"urlBase": "/hydra"`
hydra | `hydra/config/hydra/settings.cfg` | `"externalUrl": "https://app.your-domain.com/hydra"`
plexpy | `plexpy/config/config.ini` | `http_root = /plexpy`
plexpy | `plexpy/config/config.ini` | `pms_ip = plex`
plexpy | `plexpy/config/config.ini` | `pms_port = 32400`
radarr | `radarr/config/config.xml` | `<UrlBase>/radarr</UrlBase>`
sonarr | `sonarr/config/config.xml` | `<UrlBase>/sonarr</UrlBase>`
transmission | `transmission/config/settings.json` | `"rpc-url": "/transmission/"`
plex | `plex/config/Library/Application Support/Plex Media Server/Preferences.xml` | `ManualPortMappingPort="443"` 
plex | `plex/config/Library/Application Support/Plex Media Server/Preferences.xml` | `customConnections="https://plex.your-domain.com:443"`

Other manual configuration that should be done via the webui:
* sonarr & radarr: configure indexer to `http://hydra:5075/hydra`
* *tbd*

## Usage
### Create Stack

Create a new stack with all of our configured services in the compose file.
```bash
$ docker stack deploy --compose-file docker-compose.yml STACK
```

### Remove Stack

This will stop all containers and remove the stack. Useful for modifying multiple configuration files as described above.
```bash
$ docker stack rm STACK
```

### Update Stack

The deploy command should rebuild all the containers if required.
```bash
$ docker stack deploy --compose-file docker-compose.yml STACK
```

### Update A Service

As an example, this will pull the latest letsencrypt image and update the service.
```bash
$ docker service update --force --image linuxserver/letsencrypt STACK_letsencrypt
```

### Stop A Service

As an example, this will stop the letsencrypt service.
```bash
$ docker service scale STACK_letsencrypt=0
```

### Start A Service

As an example, this will start the letsencrypt service.
```bash
$ docker service scale STACK_letsencrypt=1
```

## Author

Kyle Harding <kylemharding@gmail.com>

## Credit

I give credit where it's due and would like to give a shoutout to the creators of the docker images used in this project:
* [portainer.io](http://portainer.io/)
* [plex.tv](https://www.plex.tv/)
* [linuxserver.io](https://www.linuxserver.io/)
