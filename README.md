# Docker: linux-thinkpad-x1-20kh-ct01ww


A docker container description for building the kernel for my thinkpad x1 carbon (20kh ct01ww)  
* uses lothar's github / linux  
* uses lothar's github / linux defconfigs  


## Build

```
$ cd ./docker

$ time docker build --no-cache --build-arg USER=$USER -t rubuschl/linux:$(date +%Y%m%d%H%M%S) .
    10m...
```


## Usage

```
$ docker images
    REPOSITORY               TAG                 IMAGE ID            CREATED             SIZE
    rubuschl/linux           20191203212934      70dce0bd5619        15 minutes ago      612MB
    ...

$ docker run -ti --rm --user=$USER:$USER --workdir=/home/$USER -v $PWD/configs:/home/$USER/configs -v $PWD/output:/home/$USER/output rubuschl/linux:20191203212934 /bin/bash

docker $> time build.sh
```



## Installation

* First install the linux-headers, then the linux-image.  
* All resulting install packages are found in **output** as **.deb** packages.  
