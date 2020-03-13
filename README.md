[![CircleCI](https://circleci.com/gh/Rubusch/docker__linux.svg?style=shield)](https://circleci.com/gh/Rubusch/docker__linux)
[![License: GPL v2](https://img.shields.io/badge/License-GPL%20v2-blue.svg)](https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html)


# Docker: linux for patches


## Tools Needed

```
$ sudo curl -L "https://github.com/docker/compose/releases/download/1.28.6/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
$ sudo chmod a+x /usr/local/bin/docker-compose
```

NB: Where 1.28.6 is the latest version (currently not supported by devian/ubuntu package management)  


## Build

The setup needs a gmail email address for patch delivery via ``git send-email``. Many other email providers are possible in general, too  


```
$ cd ./docker
$ docker-compose up
```

**NOTE** After first run, go to ``docker/secrets/.gitconfig`` or in the container ``/home/USER/.gitconfig`` (same file), and fill out what is missing.  

## Usage

```
$ docker-compose -f ./docker-compose.yml run --rm linux /bin/bash

$ build.sh
```
