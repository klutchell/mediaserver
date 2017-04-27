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

## Dependencies

Install [docker engine](https://docs.docker.com/engine/installation/):
```bash
$ curl -sSL get.docker.com | sh
```

## Installing

Clone the repo to somewhere convenient with reasonable storage available:
```bash
$ git clone --recursive -j8 git@github.com:klutchell/compose-mediaserver.git ~/mediaserver
```

## Configuration

Edit `docker-compose.yml` with desired volume paths. Symlinks are allowed and it makes it easier to point some volumes to large mount points.
```bash
$ nano ~/mediaserver/docker-compose.yml`
```

Copy the `*.env.sample` files to `*.env` before editing each of them with desired values.
https://docs.docker.com/compose/compose-file/#/envfile
```bash
$ for env in ~/mediaserver/*.env.sample; do cp "${env}" "${env%.sample}"; done
$ nano ~/mediaserver/*.env
```

## Running

Pull the latest images from docker hub and start them with docker stack deploy:
```bash
$ docker stack init
$ docker stack deploy --compose-file docker-compose.yml STACK
```

## Author

Kyle Harding <kylemharding@gmail.com>

## Credit

I give credit where it's due and would like to give a shoutout to the creators of the docker images used in this project:
* [portainer.io](http://portainer.io/)
* [plex.tv](https://www.plex.tv/)
* [linuxserver.io](https://www.linuxserver.io/)
