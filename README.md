[![CircleCI](https://circleci.com/gh/Rubusch/docker__linux.svg?style=shield)](https://circleci.com/gh/Rubusch/docker__linux)
[![License: GPL v2](https://img.shields.io/badge/License-GPL%20v2-blue.svg)](https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html)


# Docker: linux for development

The container is a standalone container and builds on ubuntu standard containers  

## Build

```
$ ./setup.sh
```

**NOTE** After first run, go to ``./docker/build_configs/.gitconfig`` or ``<docker>/home/USER/.gitconfig`` (same file, linked into the container) and fill out what is missing.  

The setup needs a **gmail email address** for patch delivery via ``git send-email``. Many other email providers are possible in general, too  

## Usage

```
$ ./setup.sh
$ cd ./workspace
$ source ./source-me.sh
docker$ build.sh
```

## Issues

issue: fatal error: asm/compiler.h: No such file or directory `#include <asm/compiler.h>`

fix: source the environment file first!
```
$ make clean && make
    make -C /usr/src/linux M=/home/user/workspace/github__c_linux/010__basics/17__cdev-with-class-and-fops-and-userspace-app clean
    make[1]: Entering directory '/home/user/workspace/linux_aarch64-linux-gnu-rpi-6.6.y'
    make[1]: Leaving directory '/home/user/workspace/linux_aarch64-linux-gnu-rpi-6.6.y'
    find  -type f -name \*~ -delete
    rm -f *.elf
    make -C /usr/src/linux M=/home/user/workspace/github__c_linux/010__basics/17__cdev-with-class-and-fops-and-userspace-app modules
    make[1]: Entering directory '/home/user/workspace/linux_aarch64-linux-gnu-rpi-6.6.y'
    warning: the compiler differs from the one used to build the kernel
      The kernel was built by: aarch64-linux-gnu-gcc (Ubuntu 9.4.0-1ubuntu1~20.04.2) 9.4.0
      You are using:           gcc (Ubuntu 9.4.0-1ubuntu1~20.04.2) 9.4.0
      CC [M]  /home/user/workspace/github__c_linux/010__basics/17__cdev-with-class-and-fops-and-userspace-app/hellochardev.o
    In file included from <command-line>:
    ././include/linux/compiler_types.h:167:10: fatal error: asm/compiler.h: No such file or directory
      167 | #include <asm/compiler.h>
          |          ^~~~~~~~~~~~~~~~
    compilation terminated.
    make[3]: *** [scripts/Makefile.build:243: /home/user/workspace/github__c_linux/010__basics/17__cdev-with-class-and-fops-and-userspace-app/hellochardev.o] Error 1
    make[2]: *** [/home/user/workspace/linux_aarch64-linux-gnu-rpi-6.6.y/Makefile:1913: /home/user/workspace/github__c_linux/010__basics/17__cdev-with-class-and-fops-and-userspace-app] Error 2
    make[1]: *** [Makefile:234: __sub-make] Error 2
    make[1]: Leaving directory '/home/user/workspace/linux_aarch64-linux-gnu-rpi-6.6.y'
    make: *** [Makefile:15: module] Error 2

$ . ~/workspace/source-me.sh
```
