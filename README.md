# Docker Plex & Usenet Media Server #

docker-based plex & usenet media server

## Motivation

* run public maintained images with no modifications
* keep source repo small (2 required files)
* require minimal configuration and setup

## Features

* [Plex](https://hub.docker.com/r/linuxserver/plex/) organizes video, music and photos from personal media libraries and streams them to smart TVs, streaming boxes and mobile devices. This container is packaged as a standalone Plex Media Server.
* [NZBGet](https://hub.docker.com/r/linuxserver/nzbget/) is a usenet downloader, written in C++ and designed with performance in mind to achieve maximum download speed by using very little system resources.
* [Sonarr](https://hub.docker.com/r/linuxserver/sonarr/) (formerly NZBdrone) is a PVR for usenet and bittorrent users. It can monitor multiple RSS feeds for new episodes of your favorite shows and will grab, sort and rename them. It can also be configured to automatically upgrade the quality of files already downloaded when a better quality format becomes available.
* [Radarr](https://hub.docker.com/r/linuxserver/radarr/) - A fork of Sonarr to work with movies à la Couchpotato.
* [NZBHydra](https://hub.docker.com/r/linuxserver/hydra2/) 2 is a meta search application for NZB indexers, the "spiritual successor" to NZBmegasearcH, and an evolution of the original application NZBHydra . It provides easy access to a number of raw and newznab based indexers.
* [Duplicati](https://hub.docker.com/r/linuxserver/duplicati/) works with standard protocols like FTP, SSH, WebDAV as well as popular services like Microsoft OneDrive, Amazon Cloud Drive & S3, Google Drive, box.com, Mega, hubiC and many others.

## Requirements

* dedicated server or PC with plenty of storage
* windows or linux x86/x64 os (not ARM)

## Install

```bash
# 1. install docker
# https://docs.docker.com/install/linux/docker-ce/debian/
curl -sSL get.docker.com | sh

# 2. install docker-compose
# https://docs.docker.com/compose/install/#install-compose
sudo curl -L --fail https://github.com/docker/compose/releases/download/1.23.1/run.sh -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# 3. clone mediaserver repo
git clone https://github.com/klutchell/mediaserver.git
```

## Configure

```bash
# copy env.sample to .env
cp env.sample .env

# fill all required variables in .env
nano .env
```

## Deploy

```bash
# 1. pull latest public images
docker-compose pull

# 2. deploy containers with docker compose
docker-compose up -d --remove-orphans
```

## Usage

* Log into each service and enable http authentication

## Author

Kyle Harding <kylemharding@gmail.com>

## Acknowledgments

I didn't create any of these docker images myself, so credit goes to the
maintainers, and the app creators.

* [linuxserver.io](https://linuxserver.io/)

## License

[MIT License](./LICENSE)
