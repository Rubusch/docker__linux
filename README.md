[![CircleCI](https://circleci.com/gh/Rubusch/docker__linux.svg?style=shield)](https://circleci.com/gh/Rubusch/docker__linux)
[![License: GPL v2](https://img.shields.io/badge/License-GPL%20v2-blue.svg)](https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html)


# Docker: linux for development

The container is a standalone container and builds on ubuntu standard containers.  


## Preparation

Needed tools.  

```
$ sudo apt-get install -y libffi-dev libssl-dev python3-dev python3-pyqt5 python3-pyqt5.qtwebengine python3 python3-pip
$ pip3 install docker-compose
```
Make sure, ``~/.local`` is within ``$PATH`` or re-link e.g. it to ``/usr/local``, and to have docker group setup correctly, e.g.  
```
$ sudo usermod -aG docker $USER
```

Make sure, ``~/.local`` is within ``$PATH`` or re-link e.g. it to ``/usr/local``, or setup python venv.  


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
$ docker-compose -f ./docker-compose.yml run --rm linux-develop
```

Build manually:  

```
$ cd docker
$ docker-compose -f ./docker-compose.yml run --rm linux-develop /bin/bash
docker$ build.sh
```

## RPI: Manual Linux Installation on the RPI

ref: https://www.raspberrypi.com/documentation/computers/linux_kernel.html  

The build will try to build .deb packages, anyway manually the installation for the RPI should be as follows.  
```
# make -j4 Image.gz modules dtbs
# sudo make modules_install
# sudo cp arch/arm64/boot/dts/broadcom/*.dtb /boot/
# sudo cp arch/arm64/boot/dts/overlays/*.dtb* /boot/overlays/
# sudo cp arch/arm64/boot/dts/overlays/README /boot/overlays/
# sudo cp arch/arm64/boot/Image.gz /boot/$KERNEL.img
```

NB: configure to boot the specific kernel in "/boot/config.txt", i.e. set a name in the kernel config  
```
$ sudo vi /boot/config.txt
    ...
    [pi4]
    kernel=vmlinuz-6.3.0-rc6-v8+
    ...
```

## Issues

Remove orphaned containers  
```
$ cd ./docker
$ docker-compose up -d --remove-orphans

$ docker-compose ps

$ docker-compose down
```

Remove dangling container images, etc.  
```
$ docker system prune -f
```

Remove an docker image  
```
$ docker images
    REPOSITORY               TAG        IMAGE ID       CREATED         SIZE
    user/linux               20211028   8b0855782faf   11 months ago   2.99GB
$ docker rmi -f 8b0855782faf
```

Check via docker-compose (also offers possibility to remove an image)  
```
$ docker-compose ps
```

For more consult the specific help and manpages.  

#### issue: getcwd: cannot access parent directories  

```
$ build.sh
    + 00_devenv.sh /home/user/workspace /home/user/configs
    shell-init: error retrieving current directory: getcwd: cannot access parent directories: No such file or directory
```
fix: change to ``/home/<user>``, then execute build.sh  


#### issue: uses unknown compression for member 'control.tar.zst', giving up   
```
$ dpkg -i foo.deb
```

fix: re-pack .deb file to use xz instead of zstd, example  
```
$ mkdir deb-temp
$ cd deb-temp
$ ar x ../some.deb
$ zstd -d *.zst
$ rm *.zst
$ xz *.tar
$ ar r ../some.deb debian-binary control.tar.xz data.tar.xz
$ cd ..
$ dpkg -i ./some.deb
```


#### issue: won't compile due to GLIBC version

When compiling out-of-source kernel modules the compilation of the module stops with an error similar

```
/lib/x86_64-linux-gnu/libc.so.6: version `GLIBC_2.33' not found
/lib/x86_64-linux-gnu/libc.so.6: version `GLIBC_2.34' not found
```

fix: issue due to build artifacts of different toolchain

Typically this happens for the tools around the kernel sources, when building the docker container on ubu 22.04 (GLIBC_2.35 or around), then compiling the kernel source and switching to another container build on 20.04 (GLIBC_2.31) e.g. because RPI3b needs GLIBC_2.31 for userspace stuff. The solution is re-build the linux sources with the current toolchain.
