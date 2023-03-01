[![CircleCI](https://circleci.com/gh/Rubusch/docker__linux.svg?style=shield)](https://circleci.com/gh/Rubusch/docker__linux)
[![License: GPL v2](https://img.shields.io/badge/License-GPL%20v2-blue.svg)](https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html)


# Docker: linux for patches

The container is a standalone container and builds on ubuntu standard containers.  


## Preparation

Needed tools.  

```
$ sudo apt-get install -y libffi-dev libssl-dev python3-dev python3-pyqt5 python3-pyqt5.qtwebengine python3 python3-pip
$ pip3 install docker-compose
```
Make sure, ``~/.local`` is within ``$PATH`` or re-link e.g. it to ``/usr/local``, and to have docker group setup correctly, e.g.  
```
$ sudo usermod -aG docker $USER
```

Make sure, ``~/.local`` is within ``$PATH`` or re-link e.g. it to ``/usr/local``, or setup python venv.  


## Build

The setup needs a **gmail email address** for patch delivery via ``git send-email``. Many other email providers are possible in general, too  

```
$ echo "UID=$(id -u)" > ./docker/.env
$ echo "GID=$(id -g)" >> ./docker/.env
$ cd ./docker
$ docker-compose up -d --remove-orphans
```

**NOTE** After first run, go to ``docker/secrets/.gitconfig`` or in the container ``/home/USER/.gitconfig`` (same file), and fill out what is missing.  


## Usage

```
$ cd docker
$ docker-compose -f ./docker-compose.yml run --rm linux /bin/bash
docker$ build.sh
```

## Cleanup

Remove orphaned containers  
```
$ cd ./docker
$ docker-compose up -d --remove-orphans
```

Remove dangling container images, etc.  
```
$ docker system prune -f
```

Remove an docker image  
```
$ docker images
    REPOSITORY               TAG        IMAGE ID       CREATED         SIZE
    user/linux               20211028   8b0855782faf   11 months ago   2.99GB
$ docker rmi -f 8b0855782faf
```

Check via docker-compose (also offers possibility to remove an image)  
```
$ docker-compose ps
```

For more consult the specific help and manpages.  
