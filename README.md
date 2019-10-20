# The docker__linux-thinkpad-x1-20kh-ct01ww

A docker image/container description for building the kernel for my thinkpad x1 carbon (20kh ct01ww)


## Build

```
$ time docker build --no-cache --tag v5.3 -t rubuschl/thinkpad-kernel .
$ time docker run -ti --rm -v $PWD/output:/mnt rubuschl/thinkpad-kernel
```


## Debug

```
$ docker run -ti rubuschl/thinkpad-kernel /bin/bash
docker$ ./build.sh
```
