# Docker: linux


A docker image for kernel patch development. A ``build.sh`` script will in a second step clone a staging tree. ``configs`` and ``staging`` tree will be setup outside the container, but shared with the container.  


## Build

```
$ cd ./docker

$ time docker build --no-cache --build-arg USER=$USER -t rubuschl/linux:$(date +%Y%m%d%H%M%S) .
    10m...
```

## Sources

Obtain the tag number from docker images as below  

```
$ docker images
    REPOSITORY               TAG                 IMAGE ID            CREATED             SIZE
    rubuschl/linux           20191203212934      70dce0bd5619        15 minutes ago      612MB
```

Obtain kernel sources or update

```
$ time docker run --rm -ti --user=$USER:$USER --workdir=/home/$USER -v $PWD/configs:/home/$USER/configs -v $PWD/linux:/home/$USER/linux rubuschl/linux:20191203212934
```


## Usage

Login into the docker container  

```
$ docker run --rm -ti --user=$USER:$USER --workdir=/home/$USER -v $PWD/configs:/home/$USER/configs -v $PWD/linux:/home/$USER/linux rubuschl/linux:20191203212934 /bin/bash
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



