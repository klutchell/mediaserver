# Docker Plex & Usenet Media Server

docker-based plex & usenet media server using custom subdomains over https

## Motivation

- host each service as a subdomain of a personal domain over https
- run public maintained images with no modifications
- require minimal configuration and setup

## Features

- [Plex](https://plex.tv/) organizes video, music and photos from personal media libraries and streams them to smart TVs, streaming boxes and mobile devices.
- [NZBGet](https://nzbget.net/) is a usenet downloader, written in C++ and designed with performance in mind to achieve maximum download speed by using very little system resources.
- [Sonarr](https://sonarr.tv/) (formerly NZBdrone) is a PVR for usenet and bittorrent users. It can monitor multiple RSS feeds for new episodes of your favorite shows and will grab, sort and rename them. It can also be configured to automatically upgrade the quality of files already downloaded when a better quality format becomes available.
- [Radarr](https://radarr.video/) - A fork of Sonarr to work with movies à la Couchpotato.
- [NZBHydra2](https://github.com/theotherp/nzbhydra2) is a meta search application for NZB indexers, the "spiritual successor" to NZBmegasearcH, and an evolution of the original application NZBHydra.
- [Traefik](https://traefik.io/) is a modern HTTP reverse proxy and load balancer that makes deploying microservices easy.

## Requirements

- dedicated server or PC with plenty of storage
- personal top-level domain with configurable sub-domains (eg. plex.example.com)

The following subdomains should point to the public IP of your server.

- `plex.example.com`
- `nzbget.example.com`
- `sonarr.example.com`
- `radarr.example.com`
- `hydra.example.com`
- `traefik.example.com`

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

Add credentials for basic http auth. The first user added requires `htpasswd -c`
in order to create the password file. Subsequent users should only use `htpasswd` to avoid
overwriting the file.

```bash
docker-compose exec traefik apk add --no-cache apache2-utils
docker-compose exec traefik htpasswd -c /etc/traefik/.htpasswd <user1>
docker-compose exec traefik htpasswd /etc/traefik/.htpasswd <user2>
```

NZBGet ships with basic auth enabled by default, so you will get double prompted unless you turn that off.

```bash
docker-compose exec nzbget sed 's/ControlUsername=.*/ControlUsername=/' -i /config/nzbget.conf
docker-compose exec nzbget sed 's/ControlPassword=.*/ControlPassword=/' -i /config/nzbget.conf
docker-compose restart nzbget
```

Now only your provided htpasswd credentials will be needed, and not the default NZBGet credentials.

## Extras

- [Nextcloud](https://nextcloud.com/)
- [MariaDB](https://mariadb.com/)
- [Ghost](https://ghost.org/)
- [Duplicati](https://www.duplicati.com/)
- [Netdata](https://www.netdata.cloud/)

Create a link in order to append the extras compose file to future docker-compose commands.

```bash
ln -s docker-compose.extras.yml docker-compose.override.yml
```

Load extra services now that both compose files are linked. Optionally remove the unwanted services first.

```bash
docker-compose pull
docker-compose up -d
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

[Buy me a beer](https://kyles-tip-jar.myshopify.com/cart/31356319498262:1?channel=buy_button)

[Buy me a craft beer](https://kyles-tip-jar.myshopify.com/cart/31356317859862:1?channel=buy_button)

## Acknowledgments

I didn't create any of these docker images myself, so credit goes to the
maintainers, and the original software creators.

- <https://hub.docker.com/r/plexinc/pms-docker/>
- <https://hub.docker.com/r/linuxserver/nzbget/>
- <https://hub.docker.com/r/linuxserver/sonarr/>
- <https://hub.docker.com/r/linuxserver/radarr/>
- <https://hub.docker.com/r/linuxserver/nzbhydra2/>
- <https://hub.docker.com/_/traefik/>
- <https://hub.docker.com/_/nextcloud/>
- <https://hub.docker.com/_/ghost/>
- <https://hub.docker.com/r/linuxserver/duplicati/>
- <https://hub.docker.com/r/netdata/netdata/>
- <https://hub.docker.com/_/mariadb/>

## License

[MIT License](./LICENSE)
