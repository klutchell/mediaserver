# Docker Plex & Usenet Media Server #

docker-based plex media server for debian os x86/x64

my goal was to use as many publicly maintained images as possible without modifications

|service|image|
|---|---|
|[plex](https://plex.tv)|[plexinc/pms-docker](https://hub.docker.com/r/plexinc/pms-docker/)|
|[tautulli](http://tautulli.com/)|[tautulli/tautulli](https://hub.docker.com/r/tautulli/tautulli/)|
|[hydra](github.com/theotherp/nzbhydra)|[linuxserver/hydra](https://hub.docker.com/r/linuxserver/hydra/)|
|[sonarr](sonarr.tv)|[linuxserver/sonarr](https://hub.docker.com/r/linuxserver/sonarr/)|
|[radarr](radarr.video)|[linuxserver/radarr](https://hub.docker.com/r/linuxserver/radarr/)|
|[nzbget](nzbget.net)|[linuxserver/nzbget](https://hub.docker.com/r/linuxserver/nzbget/)|
|[transmission](transmissionbt.com)|[linuxserver/transmission](https://hub.docker.com/r/linuxserver/transmission/)|
|[caddy](https://caddyserver.com/)|[abiosoft/caddy-docker](https://hub.docker.com/r/abiosoft/caddy/)|

## Getting Started

### Prerequisites

* (recommended) dedicated server with plenty of storage
(_tested with [Kimsufi](https://www.kimsufi.com/ca/en/servers.xml)_)
* custom domain with configurable sub-domains
(_tested with [namecheap](https://www.namecheap.com/)_)
* [cloudflare DNS](https://www.cloudflare.com/) with strict ssl
* (recommended) debian os (not ARM)
(_tested with [Ubuntu Server](https://www.ubuntu.com/download/server) x64 16.04_)

### Install

```bash
# install docker
curl -sSL get.docker.com | sh

# install docker compose
sudo curl -L --fail https://github.com/docker/compose/releases/download/1.21.2/run.sh -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# clone mediaserver repo
mkdir mediaserver && cd mediaserver
git clone git@github.com:klutchell/mediaserver.git .

# download wait-for-it.sh from jlordiales's github fork
# this fork allows multiple services to be tested
curl -o wait-for-it.sh "https://raw.githubusercontent.com/jlordiales/wait-for-it/master/wait-for-it.sh"
chmod +x wait-for-it.sh
```

### Configure

#### Cloudflare

* DNS -> DNS Records

|Type|Name|Value|
|---|---|---|
|`A`|`plex.yourdomain.com`|`xxx.xxx.xxx.xxx`|
|`A`|`tautulli.yourdomain.com`|`xxx.xxx.xxx.xxx`|
|`A`|`hydra.yourdomain.com`|`xxx.xxx.xxx.xxx`|
|`A`|`sonarr.yourdomain.com`|`xxx.xxx.xxx.xxx`|
|`A`|`radarr.yourdomain.com`|`xxx.xxx.xxx.xxx`|
|`A`|`nzbget.yourdomain.com`|`xxx.xxx.xxx.xxx`|
|`A`|`transmission.yourdomain.com`|`xxx.xxx.xxx.xxx`|
* Crypto -> SSL = `Full (strict)`

#### Open Firewall Ports

* allow HTTP (80) and HTTPS (443) through your firewall
```bash
# ufw example
sudo ufw allow http https
```

#### Configure Services

**common.env**
* Set `PUID` and `PGID` to the output of `id -u` and `id -g` respectively
* Set `TZ` to your local [unix timezone](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)

**caddy.env**
* Set `ACME_AGREE` to `true` if you agree to the [Letsencrypt TOS](https://docs.google.com/viewer?url=https%3A%2F%2Fletsencrypt.org%2Fdocuments%2F2017.11.15-LE-SA-v1.2.pdf&pdf=true)
* Set `CLOUDFLARE_EMAIL` to your registered Cloudflare email address
* Set `CLOUDFLARE_API_KEY` to your [Cloudflare api key](https://support.cloudflare.com/hc/en-us/articles/200167836-Where-do-I-find-my-Cloudflare-API-key-)

**plex.env**
* Set `ADVERTISE_IP` to `https://plex.yourdomain.com:443`
* Set `PLEX_UID` and `PLEX_GID` to the output of `id -u` and `id -g` respectively
* Set `PLEX_CLAIM` to a new token obtained at https://www.plex.tv/claim

**Caddyfile**
* Add your custom domain to each of the opening blocks above `gzip`
* Add a password to all of the `basicauth` lines

## Deploy

```bash
docker-compose up -d
```

## Usage

**Tautulli**
* Settings -> Plex Media Server -> Plex IP Address or Hostname = `plex`
* Settings -> Plex Media Server -> Plex Port = `32400`
* Settings -> Web Interface -> `HTTP Username: admin` `HTTP Password: xxxxxxxx`

**Hydra**
* Config -> Main -> External URL = `https://hydra.mydomain.com`
* Config -> Authorization -> Auth type = `HTTP Basic auth` or `Login form`
* Config -> Authorization -> Add new user = `Username: admin` `Password: xxxxxxxx`

**Radarr/Sonarr**
* Settings -> Indexers -> Add = `Type: newsnab` `URL: http://hydra:5075`
* Settings -> Download Client -> Add = `Type: nzbget` `Host: nzbget` `Port: 6789`

## Author

Kyle Harding <kylemharding@gmail.com>

## Acknowledgments

I didn't create any of these docker images myself, so credit goes to the
maintainers, and the app creators themselves.

## License

MIT License