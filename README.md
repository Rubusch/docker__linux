[![CircleCI](https://circleci.com/gh/Rubusch/docker__linux.svg?style=shield)](https://circleci.com/gh/Rubusch/docker__linux)
[![License: GPL v2](https://img.shields.io/badge/License-GPL%20v2-blue.svg)](https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html)


# Docker: linux for development

The container is a standalone container and builds on ubuntu standard containers  


## Preparation

Needed tools  

```
$ sudo apt-get install -y libffi-dev libssl-dev python3-dev python3-pyqt5 python3-pyqt5.qtwebengine python3 python3-pip
$ pip3 install docker-compose
```
Make sure, ``~/.local`` is within ``$PATH`` or re-link e.g. it to ``/usr/local``, and to have docker group setup correctly, e.g.  
```
$ sudo usermod -aG docker $USER
```

Make sure, ``~/.local`` is within ``$PATH`` or re-link e.g. it to ``/usr/local``, or setup python venv  


## Build

```
$ cd ./docker
$ echo "UID=$(id -u)" > ./.env
$ echo "GID=$(id -g)" >> ./.env
$ docker-compose build --no-cache
```


**NOTE** After first run, go to ``./docker/build_configs/.gitconfig`` or ``<docker>/home/USER/.gitconfig`` (same file, linked into the container) and fill out what is missing.  

The setup needs a **gmail email address** for patch delivery via ``git send-email``. Many other email providers are possible in general, too  

## Usage

```
$ cd docker
$ docker-compose -f ./docker-compose.yml run --rm linux-develop /bin/bash
docker$ build.sh
```
