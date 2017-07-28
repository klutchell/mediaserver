yourdomain# Docker Plex & Usenet Media Server #

## Description

This is a Docker-based Plex Media Server setup for ubuntu using public images from Docker Hub.
I didn't create any of these docker images myself, so credit goes to the linked authors.

* [plexinc/pms-docker](https://hub.docker.com/r/plexinc/pms-docker/)
* [portainer/portainer](https://hub.docker.com/r/portainer/portainer/)
* [linuxserver/nzbget](https://hub.docker.com/r/linuxserver/nzbget/)
* [linuxserver/sonarr](https://hub.docker.com/r/linuxserver/sonarr/)
* [linuxserver/radarr](https://hub.docker.com/r/linuxserver/radarr/)
* [linuxserver/plexpy](https://hub.docker.com/r/linuxserver/plexpy/)
* [linuxserver/transmission](https://hub.docker.com/r/linuxserver/transmission/)
* [linuxserver/hydra](https://hub.docker.com/r/linuxserver/hydra/)
* [jwilder/docker-gen](https://hub.docker.com/r/jwilder/docker-gen/)
* [jrcs/letsencrypt-nginx-proxy-companion](https://hub.docker.com/r/jrcs/letsencrypt-nginx-proxy-companion/)
* [nginx](https://hub.docker.com/_/nginx/)

## Benefits

While the advantages/disadvantages of using docker containers for web services
are covered in detail elsewhere, here's why I prefer this setup for my media server.

* only one application to install (docker engine)
* all my config and databases are stored in one place (or more if I prefer)
* migrating to a new server is painless
* uptime is reliable with docker stack

## Requirements

### Operating system
These instructions assume you are using **Ubuntu x64 16.04** or later.

It may work on other distros but this is what I'm running :)

### Custom domain

These instructions assume you own a custom domain with configurable sub-domains.
A domain isn't expensive, and I'm using one from [namecheap](namecheap.com). Free subdomain
services can also be used but the configuration would have to be adjusted a bit.

### CloudFlare

I'm also using [CloudFlare](https://cloudflare.com) to improve performance,
but that should be considered optional.

## Installation
### Install Docker

Install docker engine.
```bash
$ curl -sSL get.docker.com | sh
$ sudo usermod -aG docker "$(who am i | awk '{print $1}')"
```
_See https://docs.docker.com/engine/installation/ for additional installation options._

### Clone Repo

Clone the repo to somewhere convenient with reasonable storage available.
```bash
$ git clone git@github.com:klutchell/mediaserver.git ~/mediaserver
```
_You can change data and media paths in a later step._

### Initialize Swarm

I've switched to docker stack where I was previously using docker-compose.
It requires we initialize a master swarm node before adding services to the stack.
I haven't tried multiple nodes yet.
```bash
$ docker swarm init
```
_See https://docs.docker.com/engine/reference/commandline/stack/ for additonal
command line options._

## Configuration

### Compose File

The docker-compose file in the project root defines the services that will be created.

The only thing I recommend changing in here are the local volume paths, especially
if the plex/media folder needs to be on an external drive. Symlinks are allowed
and it makes it easier to point some volumes to large mount points.
By default, most volumes are mounted to subdirectories of the project root.

```bash
$ nano ./docker-compose.yml
```

_See https://docs.docker.com/compose/compose-file/ for supported values._

### Environment Files
Most of the services have environment files that are sourced by the compose file.
Some of the fields are required and are populated with fake data so be sure to
review and update them as necessary.

* `./radarr/radarr.env`
* `./portainer/portainer.env`
* `./transmission/transmission.env`
* `./plexpy/plexpy.env`
* `./hydra/hydra.env`
* `./nginx/letsencrypt.env`
* `./plex/plex.env`
* `./nzbget/nzbget.env`
* `./sonarr/sonarr.env`

#### Example 1

```bash
# https://github.com/linuxserver/docker-radarr

# Provide the desired id that the container should use when running.
# This is helpful to maintain ownership of the config files and databases.
# Run id `whoami` to find the ID of your current user and group.
PUID=1000
PGID=1000

# Set the desired timezone for the container.
# Run `cat /etc/timezone` to find the timezone of the host os.
TZ=America/New_York

# Provide the public-facing domain to use for this service.
# Specify multiple hosts with a comma delimiter.
# See https://github.com/jwilder/nginx-proxy
VIRTUAL_HOST=radarr.yourdomain.com

# Provide the internal container service port to forward traffic via proxy
# This port will not be public-facing, it is used by nginx for reverse-proxy.
# See https://github.com/jwilder/nginx-proxy
VIRTUAL_PORT=7878

# The LETSENCRYPT_HOST variable most likely needs to be the same as
# the VIRTUAL_HOST variable and must be publicly reachable domains.
# Specify multiple hosts with a comma delimiter.
# See https://github.com/JrCs/docker-letsencrypt-nginx-proxy-companion
LETSENCRYPT_HOST=radarr.yourdomain.com
LETSENCRYPT_EMAIL=youremail@gmail.com
```

#### Example 2

```bash
# https://github.com/plexinc/pms-docker

# Change ownership of config directory to the plex user. Defaults to true.
# If you are certain permissions are already set such that the plex user within
# the container can read/write data in it's config directory, you can set this
# to false to speed up the first run of the container.
#CHANGE_CONFIG_DIR_OWNERSHIP=true

# IP/netmask entries which allow access to the server without requiring authorization.
# We recommend you set this only if you do not sign in your server.
# For example 192.168.1.0/24,172.16.0.0/16 will allow access to the
# entire 192.168.1.x range and the 172.16.x.x range.
#ALLOWED_NETWORKS=192.168.1.0/24,172.16.0.0/16

# The user id of the plex user created inside the container.
# Run id `whoami` to find the ID of your current user and group.
PLEX_UID=1000

# The group id of the plex group created inside the container
# Run id `whoami` to find the ID of your current user and group.
PLEX_GID=1000

# Set the timezone inside the container.
# For example: Europe/London.
# The complete list can be found here: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
# Run `cat /etc/timezone` to find the timezone of the host os.
TZ=America/New_York

# The claim token for the server to obtain a real server token.
# If not provided, server is will not be automatically logged in.
# If server is already logged in, this parameter is ignored.
# You can obtain a claim token to login your server to your plex account by visiting https://www.plex.tv/claim.
PLEX_CLAIM=

# Provide the public-facing domain to use for this service.
# Specify multiple hosts with a comma delimiter.
# See https://github.com/jwilder/nginx-proxy
VIRTUAL_HOST=plex.yourdomain.com

# Provide the internal container service port to forward traffic via proxy
# This port will not be public-facing, it is used by nginx for reverse-proxy.
# See https://github.com/jwilder/nginx-proxy
VIRTUAL_PORT=32400

# The LETSENCRYPT_HOST variable most likely needs to be the same as
# the VIRTUAL_HOST variable and must be publicly reachable domains.
# Specify multiple hosts with a comma delimiter.
# See https://github.com/JrCs/docker-letsencrypt-nginx-proxy-companion
LETSENCRYPT_HOST=plex.yourdomain.com
LETSENCRYPT_EMAIL=youremail@gmail.com
```

### Plex Settings

Set the remote mapping port to 443 and set secure connections to preferred.
* Settings -> Server -> Remote Access -> Manually specify public port = `443`
* Settings -> Server -> Network -> Custom server access URLs = `https://plex.yourdomain:443`
* Settings -> Server -> Network -> Secure connections = `Preferred`

If the web interface isn't available, here are the same settings in the config file.
* `./plex/config/Library/Application Support/Plex Media Server/Preferences.xml`
  * `ManualPortMappingMode="1"`
  * `ManualPortMappingPort="443"`
  * `customConnections="https://plex.yourdomain.com:443"`
  * `secureConnections="1"`

_[Create](#create-stack) the stack once in order to have this config file generated._

### Plexpy Settings

Add the local plex media server connection details.
* Settings -> Plex Media Server -> Plex IP or Hostname = `plex`
* Settings -> Plex Media Server -> Plex Port = `32400`
* Settings -> Plex Media Server -> Use SSL = `true`

### Hydra Settings

Set the public url so remote api commands don't return an unreachable link.
* Config -> External URL = `https://hydra.yourdomain.com`

### Sonarr Settings

Add the local hydra indexer connection details.
* Settings -> Indexers -> Add = `Type: newsnab` `URL: http://hydra:5075/hydra`

Add the local nzbget download client connection details.
* Settings -> Download Client -> Add = `Type: nzbget` `Host: nzbget` `Port: 6789`

### Radarr Settings

Add the local hydra indexer connection details.
* Settings -> Indexers -> Add = `Type: newsnab` `URL: http://hydra:5075/hydra`

Add the local nzbget download client connection details.
* Settings -> Download Client -> Add = `Type: nzbget` `Host: nzbget` `Port: 6789`

### Firewall Settings

Although docker will automatically add some firewall rules, I find some services still work better
if http/https traffic is allowed manually through UFW.
```bash
$ sudo ufw allow http
$ sudo ufw allow https
```

### CloudFlare Settings

* Crypto->SSL = `Full (strict)`
* Firewall disabled if an abnormal amount of load is expected
* Forward the following A-level domains to your server public IP address:
  * `plex.yourdomain.com`
  * `plexpy.yourdomain.com`
  * `hydra.yourdomain.com`
  * `sonarr.yourdomain.com`
  * `radarr.yourdomain.com`
  * `nzbget.yourdomain.com`
  * `transmission.yourdomain.com`
  * `portainer.yourdomain.com`

## Usage
### Create Stack

Create a new stack with all of our configured services in the compose file.
```bash
$ docker stack deploy --compose-file docker-compose.yml mediaserver
```

### Update Stack

The same deploy command will pull the latest images and update containers as needed.
```bash
$ docker stack deploy --compose-file docker-compose.yml mediaserver
```
This step will leave the old containers and images behind. You can cleanup with the following command.
```bash
$ docker system prune
```

### Remove Stack

This will stop all containers and remove the stack. Useful for modifying multiple configuration files as described above.
```bash
$ docker stack rm mediaserver
```

### Stop A Service

As an example, this will stop the nzbget service.
```bash
$ docker service scale mediaserver_nzbget=0
```

### Start A Service

As an example, this will start the nzbget service.
```bash
$ docker service scale mediaserver_nzbget=1
```

### Update A Service

As an example, this will pull the latest nzbget image and update the service.
```bash
$ docker service update --force --image linuxserver/nzbget mediaserver_nzbget
```

### View Service Logs

As an example, this will tail the nzbget service logs.
```bash
$ docker service logs -f mediaserver_nzbget
```

## Author

Kyle Harding <kylemharding@gmail.com>

## References

* https://docs.docker.com/engine/installation/
* https://docs.docker.com/engine/reference/commandline/stack/
* https://docs.docker.com/compose/compose-file/
* https://github.com/plexinc/pms-docker
* https://github.com/JrCs/docker-letsencrypt-nginx-proxy-companion
* https://github.com/linuxserver/docker-hydra
* https://github.com/linuxserver/docker-nzbget
* https://github.com/linuxserver/docker-plexpy
* https://github.com/portainer/portainer
* https://github.com/linuxserver/docker-radarr
* https://github.com/linuxserver/docker-sonarr
* https://github.com/linuxserver/docker-transmission
