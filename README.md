# Docker: linux-thinkpad-x1-20kh-ct01ww


A docker image/container description for building the kernel for my thinkpad x1 carbon (20kh ct01ww)


## Build

```
$ cd ./docker

$ time docker build --no-cache --build-arg USER=$USER -t rubuschl/linux:$(date +%Y%m%d%H%M%S) .
    10m...
```


Build the kernel, obtain the tag number from docker images

```
$ docker images
    REPOSITORY               TAG                 IMAGE ID            CREATED             SIZE
    rubuschl/linux           20191203212934      70dce0bd5619        15 minutes ago      612MB

$ time docker run --rm -ti --user=$USER:$USER --workdir=/home/$USER -v $PWD/output:/mnt rubuschl/linux:20191203212934
```


## Debug

```
$ docker run -ti rubuschl/thinkpad-kernel /bin/bash
docker$ ./build.sh
```
