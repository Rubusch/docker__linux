[![CircleCI](https://circleci.com/gh/Rubusch/docker__linux.svg?style=shield)](https://circleci.com/gh/Rubusch/docker__linux)
[![License: GPL v2](https://img.shields.io/badge/License-GPL%20v2-blue.svg)](https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html)


# Docker: linux for patches


A docker image for kernel development and creating community patches.  


## Build

The setup needs a gmail email address for patch delivery via ``git send-email``. Many other email providers are possible in general, too  

**NOTE** Replace ``gmail user name``, ``email@gmail.com`` and ``gmail password`` with your gmail credentials  

**NOTE** For the gamil passwords containing ``<`` and ``>`` i.e. use escaped ``\\\<`` and ``\\\>``, in any case don't use quotes.  

```
$ cd ./docker

$ time docker build --no-cache --build-arg USER=$USER --build-arg GMAIL_USER="<gmail user name>" --build-arg GMAIL=<email@gmail.com> --build-arg GMAIL_PASSW=<gmail password> -t rubuschl/linuxpatches:$(date +%Y%m%d%H%M%S) .
    10m...
```

## Usage

```
$ docker images
    REPOSITORY               TAG                 IMAGE ID            CREATED             SIZE
    rubuschl/linuxpatches    20191203212934      70dce0bd5619        15 minutes ago      612MB

$ docker run --rm -ti --user=$USER:$USER --workdir=/home/$USER -v $PWD/configs:/home/$USER/configs -v $PWD/linux:/home/$USER/linux rubuschl/linuxpatches:20191203212934 /bin/bash

docker $> build.sh
```

## Miscellaneous

Obtain the current config as a starting point  

```
$ zcat /proc/config.gz > .config
```

Build the for debian as follows  

```
$ make -j8 deb-pkg all
```

Make sure to backup your work also outside the container.  
