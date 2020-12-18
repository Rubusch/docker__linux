[![CircleCI](https://circleci.com/gh/Rubusch/docker__linux.svg?style=shield)](https://circleci.com/gh/Rubusch/docker__linux)
[![License: GPL v2](https://img.shields.io/badge/License-GPL%20v2-blue.svg)](https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html)


# Docker: linux for patches

My docker image for patch development via ``git send-mail`` (needs gmail)  


## Build

**NOTE** Replace ``gmail user name`` and ``email@gmail.com`` with your gmail credentials  


```
$ cd ./docker

$ time docker build --build-arg USER=$USER --build-arg GMAIL_USER="<gmail user name>" --build-arg GMAIL=<email@gmail.com> -t rubuschl/linuxpatches:$(date +%Y%m%d%H%M%S) .
```

## Usage

**NOTE** The data configured inside the container are not persistent!! The linux source clone, though will be performed on the mounted folder, thus will persist.  

```
$ docker images
    REPOSITORY               TAG                 IMAGE ID            CREATED             SIZE
    rubuschl/linuxpatches    20191203212934      70dce0bd5619        15 minutes ago      612MB

$ time docker run --rm -ti --user=$USER:$USER --workdir=/home/$USER -v $PWD/configs:/home/$USER/configs -v $PWD/linux:/home/$USER/linux rubuschl/linuxpatches:20191203212934 /bin/bash

docker $> git config --global sendemail.smtppass <GMAIL PASSWORD>

docker $> build.sh
```

Provide your defconfig, work on the source and build the kernel. Create the patch as normal via ``git send-mail``.  
