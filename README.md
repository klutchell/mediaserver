# Docker Plex & Usenet Media Server #

docker-based plex media server using custom domains with tls

## Motivation

* host services at `<service>.<yourdomain>.com` over https
* run public maintained images with no modifications
* keep source repo small (~5 required files)
* require minimal configuration and setup (~15 env variables)
* enforce http basic authentication with exceptions for api urls

## Features

* [plex](https://plex.tv)
* [hydra](https://github.com/theotherp/nzbhydra2)
* [sonarr](https://sonarr.tv)
* [radarr](https://radarr.video)
* [nzbget](https://nzbget.net)
* [transmission](https://transmissionbt.com)
* [caddy](https://caddyserver.com/)
* [duplicati](https://www.duplicati.com/)

## Requirements

* dedicated server or PC with plenty of storage (eg. [Kimsufi](https://www.kimsufi.com/ca/en/servers.xml))
* windows or linux x86/x64 os (not ARM) (eg. [Ubuntu Server x64](https://www.ubuntu.com/download/server))
* custom top-level domain with configurable sub-domains (eg. plex.mydomain.com)
* [cloudflare](https://www.cloudflare.com/) dns for automatic tls

## Pre-Install

1. login to [cloudflare](https://www.cloudflare.com/) and select your domain
2. select `Full (strict)` under `Crypto` -> `SSL`
3. add dns records for each service under `DNS` -> `DNS Records`

|Type|Name|Value|
|---|---|---|
|`A`|`plex.yourdomain.com`|`xxx.xxx.xxx.xxx`|
|`A`|`hydra.yourdomain.com`|`xxx.xxx.xxx.xxx`|
|`A`|`sonarr.yourdomain.com`|`xxx.xxx.xxx.xxx`|
|`A`|`radarr.yourdomain.com`|`xxx.xxx.xxx.xxx`|
|`A`|`nzbget.yourdomain.com`|`xxx.xxx.xxx.xxx`|
|`A`|`transmission.yourdomain.com`|`xxx.xxx.xxx.xxx`|
|`A`|`duplicati.yourdomain.com`|`xxx.xxx.xxx.xxx`|

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
# 1. allow ports 80 and 443 through your firewall
# ufw example:
sudo ufw allow http
sudo ufw allow https

# 2. set environment variables
nano plex.env common.env caddy.env
```

## Deploy

```bash
# 1. pull latest public images
docker-compose pull

# 2. build latest caddy with plugins
docker-compose build

# 3. deploy containers with docker compose
docker-compose up -d --remove-orphans
```

## Usage

Optionally, if you don't want to buy a domain or use Caddy as a proxy, you
can run the services in local mode with steps similar to the following:

```bash

# 1. move docker-compose.local.yml to docker-compose.yml
mv docker-compose.local.yml docker-compose.yml

# 2. open additional ports on your firewall
# ufw examples:
sudo ufw allow 32400/tcp    # plex (more may be required)
sudo ufw allow 6789/tcp     # nzbget
sudo ufw allow 8989/tcp     # sonarr
sudo ufw allow 7878/tcp     # radarr
sudo ufw allow 9091/tcp     # transmission
sudo ufw allow 5076/tcp     # hydra
sudo ufw allow 8200/tcp     # duplicati

# 3. pull latest public images
docker-compose pull

# 4. deploy containers with docker compose
docker-compose up -d --remove-orphans

```

## Tests

_TODO_

## Contributing

_TODO_

## Author

Kyle Harding <kylemharding@gmail.com>

## Acknowledgments

I didn't create any of these docker images myself, so credit goes to the
maintainers, and the app creators themselves.

## References

_TODO_

## License

[MIT License](./LICENSE)
