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
- [Prowlarr](https://github.com/Prowlarr/Prowlarr) is a indexer manager/proxy built on the popular arr .net/reactjs base stack to integrate with your various PVR apps.
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

## Authorization

There are currently two methods of authentication enabled, and I recommend using them
both if the Letsencrypt configuration is in use. If it's not exposed to the Internet you can
remove one or both of these middlewares from `docker-compose.letsencrypt.yml`.

### ipallowlist

This is our first layer of security, and probably the most important.

If you are using mediaserver locally and are not exposing any ports to the Internet, you can skip
this section or set `IPALLOWLIST=0.0.0.0/0,::/0` in your `.env` file.

To avoid unauthorized users from even seeing our login pages, we should set the `IPALLOWLIST` to
only IP ranges that we want to explictly allow access.

Access from any other IP will result in "403 Forbidden" giving you some peice of mind!

This functionality can be enabled/disabled per service in `docker-compose.letsencrypt.yml`
with the `ipallowlist` middleware.

By default Plex, Jellyfin, Ombi, and NZBHydra2 will allow all traffic.

### basicauth

This functionality can be enabled/disabled per service in `docker-compose.letsencrypt.yml`
with the `basicauth` middleware.

Users can be added to basic auth in 2 ways. If both methods are used they are merged and the
htpasswd file takes priority.

1. Add users in your `.env` file with the `BASICAUTH_USERS` variable.

2. Add users via htpasswd file in the traefik service.

The first user added requires `htpasswd -c` in order to create the password file.
Subsequent users should only use `htpasswd` to avoid overwriting the file.

```bash
docker-compose exec traefik apk add --no-cache apache2-utils
docker-compose exec traefik htpasswd -c /etc/traefik/.htpasswd <user1>
docker-compose exec traefik htpasswd /etc/traefik/.htpasswd <user2>
```

By default only Duplicati and Netdata have basic http auth enabled.

For the remaining services I suggest enabling the built-in authentication via the app.
This avoids the need to add manual exceptions for API access where required and simplifies our proxy rules.

For Sonarr, Radarr, Prowlar you can enable authentication under Settings->General->Security.

For Nzbget the default credentials are `nzbget:tegbzn6789` and can be changed under Settings->Security.

For NZBHydra2 you can add users under Config->Authorization.  

## Author

Kyle Harding <https://klutchell.dev>

[Buy me a beer](https://buymeacoffee.com/klutchell)

## Acknowledgments

I didn't create any of these docker images myself, so credit goes to the
maintainers, and the original software creators.

- <https://hub.docker.com/r/linuxserver/plex/>
- <https://hub.docker.com/r/linuxserver/nzbget/>
- <https://hub.docker.com/r/linuxserver/sonarr/>
- <https://hub.docker.com/r/linuxserver/radarr/>
- <https://hub.docker.com/r/linuxserver/prowlarr/>
- <https://hub.docker.com/r/linuxserver/nzbhydra2/>
- <https://hub.docker.com/r/linuxserver/ombi>
- <https://hub.docker.com/r/linuxserver/duplicati/>
- <https://hub.docker.com/r/netdata/netdata/>
- <https://hub.docker.com/_/traefik/>
