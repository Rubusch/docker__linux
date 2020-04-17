# Docker: linux-thinkpad-x1-20kh-ct01ww


A docker image/container description for building the kernel for my thinkpad x1 carbon (20kh ct01ww)  


## Build

```
$ cd ./docker

$ time docker build --no-cache --build-arg USER=$USER -t rubuschl/linux:$(date +%Y%m%d%H%M%S) .
    10m...
```


Build the kernel, obtain the tag e.g. **20191203212934** from docker images  

```
$ docker images
    REPOSITORY               TAG                 IMAGE ID            CREATED             SIZE
    rubuschl/linux           20191203212934      70dce0bd5619        15 minutes ago      612MB
```


Either start the container using the tag e.g. **20191203212934** for building the linux deb package  

```
$ time docker run -ti --rm -v $PWD/configs:/home/$USER/configs -v $PWD/output:/home/$USER/output --user=$USER:$USER --workdir=/home/$USER rubuschl/linux:20191203212934
```

Or, enter the container as follows and build inside the container  

```
$ docker run -ti --rm -v $PWD/configs:/home/$USER/configs -v $PWD/output:/home/$USER/output --user=$USER:$USER --workdir=/home/$USER rubuschl/linux:20191203212934 /bin/bash

docker$ time build.sh
```



## Installation

* First install the linux-headers, then the linux-image.
* All resulting install packages are found in **output** as **.deb** packages.
