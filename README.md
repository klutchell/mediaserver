# Docker Plex & Usenet Media Server #

docker-based plex media server using custom domains with tls

## Motivation

* host services at `<service>.<yourdomain>.com` over https
* run public maintained images with no modifications
* keep source repo small (~4 required files)
* require minimal configuration and setup (~15 env variables)
* attempt self-healing containers and dependencies (healthcheck, wait-for-it)
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
# install docker
# https://docs.docker.com/install/linux/docker-ce/debian/
curl -sSL get.docker.com | sh

# install docker compose
# https://docs.docker.com/compose/install/
sudo curl -L --fail https://github.com/docker/compose/releases/download/1.21.2/run.sh -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# clone mediaserver repo
mkdir mediaserver && cd mediaserver
git clone https://github.com/klutchell/mediaserver.git .

# download wait-for-it.sh from jlordiales's github fork
# this fork allows multiple services to be tested
curl -L --fail https://raw.githubusercontent.com/jlordiales/wait-for-it/master/wait-for-it.sh -o wait-for-it.sh
chmod +x wait-for-it.sh

# optionally install pre and post commit files
ln -s pre-commit .git/pre-commit
ln -s post-commit .git/post-commit

```

## Configure

```bash
# allow ports 80 and 443 through your firewall
# ufw example:
sudo ufw allow http https

# set environment variables in plex.env and common.env
nano plex.env common.env
```

## Deploy

```bash
# deploy containers with docker compose
docker-compose up -d
```

## Usage

* add hydra users for authentication under `Config -> Authorization`
* link containers internally via the service name & port
  * sonarr/radarr can reach hydra via `http://hydra:5076`
  * sonarr/radarr can reach nzbget via `http://nzbget:6789`

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
