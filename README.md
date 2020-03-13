# Docker: linux


A docker image/container description for kernel development  


## Build

```
$ cd ./docker

$ time docker build --no-cache --build-arg USER=$USER -t rubuschl/linux:$(date +%Y%m%d%H%M%S) .
    10m...
```

## Usage

Obtain the tag number from docker images as below  

```
$ docker images
    REPOSITORY               TAG                 IMAGE ID            CREATED             SIZE
    rubuschl/linux           20191203212934      70dce0bd5619        15 minutes ago      612MB
```

Login into the docker container  

```
$ docker run --rm -ti --user=$USER:$USER --workdir=/home/$USER -v $PWD/output:/home/$USER/output rubuschl/linux:20191203212934 /bin/bash
```

Obtain the current config as a starting point  

```
$ zcat /proc/config.gz > .config
```

Generate _TAGS_ file  

```
$ make tags
```

Build the kernel for debian as follows  

```
$ make -j8 deb-pkg all
```

Make sure to backup your work also outside the container.  



