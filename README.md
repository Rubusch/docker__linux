# Docker: linux for patches


A docker image for patch development. A ``build.sh`` script will in a second step clone a staging tree. ``configs`` and ``staging`` tree will be setup outside the container, but shared with the container.  


## Build

The setup needs a gmail email address for patch delivery via ``git send-email``. Many other email providers are possible in general, too  

**NOTE** Replace ``gmail user name``, ``email@gmail.com`` and ``gmail password`` with your gmail credentials  

**NOTE** For the gamil passwords containing ``<`` and ``>`` i.e. use escaped ``\\\<`` and ``\\\>``, in any case don't use quotes.  

```
$ cd ./docker

$ time docker build --no-cache --build-arg USER=$USER --build-arg GMAIL_USER="<gmail user name>" --build-arg GMAIL=<email@gmail.com> --build-arg GMAIL_PASSW=<gmail password> -t rubuschl/linuxpatches:$(date +%Y%m%d%H%M%S) .
    10m...
```

## Sources

Obtain the tag number from docker images as below  

```
$ docker images
    REPOSITORY               TAG                 IMAGE ID            CREATED             SIZE
    rubuschl/linuxpatches    20191203212934      70dce0bd5619        15 minutes ago      612MB
```

Obtain sources or update on the container tag, e.g. **20191203212934**  

```
$ time docker run --rm -ti --user=$USER:$USER --workdir=/home/$USER -v $PWD/configs:/home/$USER/configs -v $PWD/linux:/home/$USER/linux rubuschl/linuxpatches:20191203212934
```


## Usage

Login into the docker container, e.g. **20191203212934**  

```
$ docker run --rm -ti --user=$USER:$USER --workdir=/home/$USER -v $PWD/configs:/home/$USER/configs -v $PWD/linux:/home/$USER/linux rubuschl/linuxpatches:20191203212934 /bin/bash
```

Obtain the current config as a starting point  

```
$ zcat /proc/config.gz > .config
```

Build the for debian as follows  

```
$ make -j8 deb-pkg all
```

Make sure to backup your work also outside the container.  
