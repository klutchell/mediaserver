# Docker Media Server #

## Description

This is a docker-based plex media server for ubuntu using pre-built public images.
It pulls and runs the following docker images via [docker-compose](https://github.com/docker/compose):

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

## Installing

```bash
git clone git@github.com:klutchell/compose-mediaserver.git ~/mediaserver
sudo ~/mediaserver/bin/install
```

## Running

```bash
cp ~/mediaserver/compose.env.sample ~/mediaserver/compose.env
~/mediaserver/bin/pull
~/mediaserver/bin/up
```

## Author

Kyle Harding <kylemharding@gmail.com>

## Credit

I give credit where it's due and would like to give a shoutout to the creators of the docker images used in this project:
* [portainer.io](http://portainer.io/)
* [plex.tv](https://www.plex.tv/)
* [linuxserver.io](https://www.linuxserver.io/)