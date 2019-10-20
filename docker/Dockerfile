FROM ubuntu:19.04

WORKDIR /root

RUN apt-get update && apt-get upgrade -y && apt-get autoremove -y --purge && \
    apt-get install -y  libncurses5-dev zlib1g-dev git-core make gcc g++ build-essential flex binutils unzip python bzip2 libssl-dev locales && \
    apt-get install -y  libc6-dev fakeroot bin86 kernel-package udev hdparm libncursesw5-dev xmlto


RUN locale-gen en_US.UTF-8

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

#ENV BUILDDISTRO 'debian'
#ENV BUILDARCH 'amd64'


## get sources
RUN export KVERSION=v5.3 && \
    git clone -j4 --depth=1 --branch $KVERSION https://github.com/Rubusch/linux.git && \
    git clone -j4 --depth=1 --branch $KVERSION https://github.com/Rubusch/linux-defconfigs.git

## copy build.sh
COPY build.sh /root/build.sh

CMD ["/bin/bash", "/root/build.sh"]
