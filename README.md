# Docker Plex & Usenet Media Server

docker-based plex & usenet media server using custom subdomains over https

## Motivation

- host each service as a subdomain of a personal domain with letsencrypt
- run public maintained images with no modifications
- require minimal configuration and setup

## Features

- [Plex](https://plex.tv/) organizes video, music and photos from personal media libraries and streams them to smart TVs, streaming boxes and mobile devices.
- [NZBGet](https://nzbget.net/) is a usenet downloader, written in C++ and designed with performance in mind to achieve maximum download speed by using very little system resources.
- [Sonarr](https://sonarr.tv/) (formerly NZBdrone) is a PVR for usenet and bittorrent users. It can monitor multiple RSS feeds for new episodes of your favorite shows and will grab, sort and rename them. It can also be configured to automatically upgrade the quality of files already downloaded when a better quality format becomes available.
- [Radarr](https://radarr.video/) - A fork of Sonarr to work with movies à la Couchpotato.
- [NZBHydra2](https://github.com/theotherp/nzbhydra2) is a meta search application for NZB indexers, the "spiritual successor" to NZBmegasearcH, and an evolution of the original application NZBHydra.
- [Ombi](https://ombi.io/) is a self-hosted web application that automatically gives your shared Plex or Emby users the ability to request content by themselves.
- [Netdata](https://www.netdata.cloud/) - Troubleshoot slowdowns and anomalies in your infrastructure with thousands of metrics, interactive visualizations, and insightful health alarms.
- [Duplicati](https://www.duplicati.com/) - Free backup software to store encrypted backups online.
- [Traefik](https://traefik.io/) is a modern HTTP reverse proxy and load balancer that makes deploying microservices easy.

## Requirements

- dedicated server or PC with plenty of storage
- [docker](https://docs.docker.com/install/linux/docker-ce/debian/) and [docker-compose](https://docs.docker.com/compose/install/#install-compose)
- (optional) personal domain with configurable sub-domains (eg. plex.example.com)

## Direct Configuration

Copy `env.sample` to `.env` and populate all fields in the `COMMON` section.

Create a link in order to append `docker-compose.direct.yml` to future docker-compose commands.

```bash
ln -sf docker-compose.direct.yml docker-compose.override.yml
```

Review the merged configs by running `docker-compose config`.

## Letsencrypt Configuration

Copy `env.sample` to `.env` and populate all fields in the `COMMON` and `LETSENCRYPT` sections.

Create a link in order to append `docker-compose.letsencrypt.yml` to future docker-compose commands.

```bash
ln -sf docker-compose.letsencrypt.yml docker-compose.override.yml
```

Review the merged configs by running `docker-compose config`.

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

NZBGet ships with basic auth enabled by default, so you will get prompted twice unless you turn that off.

```bash
docker-compose exec nzbget sed 's/ControlUsername=.*/ControlUsername=/' -i /config/nzbget.conf
docker-compose exec nzbget sed 's/ControlPassword=.*/ControlPassword=/' -i /config/nzbget.conf
docker-compose restart nzbget
```

Now only your provided htpasswd credentials will be needed, and not the default NZBGet credentials.

## Migration

I recommend rsync for transferring media from one server to another.

However, transferring the docker volumes is not quite as straight forward. Here's a method that worked for me.

<https://www.guidodiepen.nl/2016/05/transfer-docker-data-volume-to-another-host/>

```bash
docker run --rm -v <SOURCE_DATA_VOLUME_NAME>:/from alpine ash -c "cd /from ; tar -cf - . " | \
    ssh <TARGET_HOST> 'docker run --rm -i -v <TARGET_DATA_VOLUME_NAME>:/to alpine ash -c "cd /to ; tar -xpvf - " '
```

## Author

Kyle Harding <https://klutchell.dev>

<a href="https://www.buymeacoffee.com/klutchell" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/default-orange.png" alt="Buy Me A Coffee" style="height: 51px !important;width: 217px !important;" ></a>

## Acknowledgments

I didn't create any of these docker images myself, so credit goes to the
maintainers, and the original software creators.

- <https://hub.docker.com/r/linuxserver/plex/>
- <https://hub.docker.com/r/linuxserver/nzbget/>
- <https://hub.docker.com/r/linuxserver/sonarr/>
- <https://hub.docker.com/r/linuxserver/radarr/>
- <https://hub.docker.com/r/linuxserver/nzbhydra2/>
- <https://hub.docker.com/r/linuxserver/ombi>
- <https://hub.docker.com/r/linuxserver/duplicati/>
- <https://hub.docker.com/r/netdata/netdata/>
- <https://hub.docker.com/_/traefik/>


## License

[MIT License](./LICENSE)
