# pms-config #

### Description ###

* my plex media server configuration for ubuntu
* installs and runs the following docker images:
	* [plexinc/pms-docker](https://hub.docker.com/r/plexinc/pms-docker/)
	* [linuxserver/nzbget](https://hub.docker.com/r/linuxserver/nzbget/)
	* [linuxserver/sonarr](https://hub.docker.com/r/linuxserver/sonarr/)
	* [linuxserver/radarr](https://hub.docker.com/r/linuxserver/radarr/)
	* [linuxserver/plexpy](https://hub.docker.com/r/linuxserver/plexpy/)
	* [linuxserver/transmission](https://hub.docker.com/r/linuxserver/transmission/)
	* [titpetric/netdata](https://hub.docker.com/r/titpetric/netdata/)
	* [portainer/portainer](https://hub.docker.com/r/portainer/portainer/)
	* [linuxserver/hydra](https://hub.docker.com/r/linuxserver/hydra/)
	* [linuxserver/letsencrypt](https://hub.docker.com/r/linuxserver/letsencrypt/)
	* [linuxserver/muximux](https://hub.docker.com/r/linuxserver/muximux/)

### Usage ###

```bash
git clone git@github.com:klutchell/pms-config.git ~/pms
sudo ~/pms/bin/install
sudo ~/pms/bin/configure
~/pms/bin/pull
~/pms/bin/up
```

### Contributing ###

* n/a

### Author ###

* Kyle Harding <kylemharding@gmail.com>
