# Docker Plex & Usenet Media Server #

docker-based plex & usenet media server using custom subdomains with tls

## Motivation

- host each service as a subdomain of a personal domain over https
- run public maintained images with no modifications
- require minimal configuration and setup

## Features

- [Plex](https://hub.docker.com/r/plexinc/pms-docker) organizes video, music and photos from personal media libraries and streams them to smart TVs, streaming boxes and mobile devices. This container is packaged as a standalone Plex Media Server.
- [NZBGet](https://hub.docker.com/r/linuxserver/nzbget/) is a usenet downloader, written in C++ and designed with performance in mind to achieve maximum download speed by using very little system resources.
- [Sonarr](https://hub.docker.com/r/linuxserver/sonarr/) (formerly NZBdrone) is a PVR for usenet and bittorrent users. It can monitor multiple RSS feeds for new episodes of your favorite shows and will grab, sort and rename them. It can also be configured to automatically upgrade the quality of files already downloaded when a better quality format becomes available.
- [Radarr](https://hub.docker.com/r/linuxserver/radarr/) - A fork of Sonarr to work with movies à la Couchpotato.
- [NZBHydra](https://hub.docker.com/r/linuxserver/hydra2/) 2 is a meta search application for NZB indexers, the "spiritual successor" to NZBmegasearcH, and an evolution of the original application NZBHydra . It provides easy access to a number of raw and newznab based indexers.
- [Traefik](https://hub.docker.com/_/traefik/) is a modern HTTP reverse proxy and load balancer that makes deploying microservices easy.

## Requirements

- dedicated server or PC with plenty of storage
- windows or linux x86/x64 os (not ARM)
- personal top-level domain with configurable sub-domains (eg. plex.mydomain.com)

The following subdomains should point to the public IP of your server.

- `plex.mydomain.com`
- `nzbget.mydomain.com`
- `sonarr.mydomain.com`
- `radarr.mydomain.com`
- `hydra.mydomain.com`
- `traefik.mydomain.com`

## Installation

1. fork and clone the mediaserver repo

2. install [docker](https://docs.docker.com/install/linux/docker-ce/debian/)

3. install [docker-compose](https://docs.docker.com/compose/install/#install-compose)

4. copy `env.sample` to `.env` and fill all required fields.

```bash
cp env.sample .env && nano .env
```

## Deployment

Pull and deploy containers with docker-compose.

```bash
docker-compose pull
docker-compose up -d
```

## Extras

Create a link in order to append the extras compose file to future docker-compose commands.

```bash
ln -s docker-compose.extras.yml docker-compose.override.yml
```

Load extra services now that both compose files are linked. Optionally remove the unwanted services first.

```bash
docker-compose pull
docker-compose up -d
```

Add http credentials for services using `basicauth` in the middlewares labels definition.

```bash
docker-compose exec traefik /bin/sh

apk add --no-cache apache2-utils
htpasswd /etc/traefik/.htpasswd <username>
```

Manually create mysql databases & users for nextcloud and ghost.

```bash
docker-compose exec mariadb mysql -u root -p

mysql> CREATE DATABASE nextcloud;
mysql> CREATE USER 'nextcloud'@'%' IDENTIFIED BY 'NEXTCLOUD_DB_PASSWORD';
mysql> GRANT ALL PRIVILEGES ON nextcloud.* TO 'nextcloud'@'%';
mysql> FLUSH PRIVILEGES;
mysql> SHOW GRANTS FOR 'nextcloud'@'%';

mysql> CREATE DATABASE ghost;
mysql> CREATE USER 'ghost'@'%' IDENTIFIED BY 'GHOST_DB_PASSWORD';
mysql> GRANT ALL PRIVILEGES ON ghost.* TO 'ghost'@'%';
mysql> FLUSH PRIVILEGES;
mysql> SHOW GRANTS FOR 'ghost'@'%';
```

Fix nextcloud database warnings.

```bash
docker-compose exec -u www-data nextcloud php occ maintenance:mode --on
docker-compose exec -u www-data nextcloud php occ db:add-missing-indices
docker-compose exec -u www-data nextcloud php occ db:convert-filecache-bigint
docker-compose exec -u www-data nextcloud php occ maintenance:mode --off
```

## Author

Kyle Harding <https://klutchell.dev>

## Acknowledgments

I didn't create any of these docker images myself, so credit goes to the
maintainers, and the original software creators.

- [plex.tv](https://plex.tv/)
- [linuxserver.io](https://linuxserver.io/)
- [nzbget.net](https://nzbget.net/)
- [sonarr.tv](https://sonarr.tv/)
- [radarr.video](https://radarr.video/)
- [nzbhydra.com](https://nzbhydra.com/)
- [traefik.io](https://traefik.io/)
- [nextcloud.com](https://nextcloud.com/)
- [mariadb.com](https://mariadb.com/)
- [ghost.org](https://ghost.org/)
- [duplicati.com](https://www.duplicati.com/)
- [netdata.cloud](https://www.netdata.cloud/)
- [nginx.com](https://nginx.com)

## License

[MIT License](./LICENSE)
