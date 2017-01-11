# docker #

### Description ###

* my docker compose configuration files

### Usage ###

```bash
git clone git@github.com:klutchell/docker.git ~/.docker
sudo cp ~/.docker/graph.conf /etc/systemd/system/docker.service.d/graph.conf
sudo systemctl daemon-reload
sudo systemctl restart docker
~/.docker/bin/compose-pull
```

### Contributing ###

* n/a

### Author ###

* Kyle Harding <kylemharding@gmail.com>
