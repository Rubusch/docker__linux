FROM debian:10
MAINTAINER Lothar Rubusch <lotophagon@protonmail.com>
WORKDIR /root
ENV DEBIAN_FRONTEND=noninteractive


################################################################################
## the USER is needed to make it available as --build-arg
## in case docker complains for a not set USER, perhaps you forgot to use --build-arg USER=$USER
ARG USER=""

## the branch
ARG KVERSION="lothar/v5.4-thinkpad-x1"
ARG KDEFCONFIG_NAME="lothars_defconfig"


################################################################################
## set up apt fully functional
RUN apt-get update && apt-get upgrade -y && apt-get autoremove -y --purge

RUN apt-get install -y  \
    libncurses5-dev \
    zlib1g-dev \
    git-core \
    make \
    gcc \
    g++ \
    build-essential \
    flex \
    bison \
    rsync \
    binutils \
    unzip \
    python \
    bzip2 \
    libssl-dev \
    locales \
    libc6-dev \
    fakeroot \
    bin86 \
    udev \
    bc \
    kmod \
    cpio \
    hdparm \
    libncursesw5-dev \
    xmlto \
    vim \
    sudo

################################################################################
## locale settings
RUN locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

## locale-hack, needed for debian since locale-gen <arg> seems not to work
RUN sed -i '/^#.* en_US.UTF-8.* /s/^#//' /etc/locale.gen
RUN locale-gen


################################################################################
## setup user and run stuff under user
RUN useradd "$USER" -m --password "$USER"
RUN usermod -a -G sudo "$USER"
RUN sed -i '/%sudo/s/.*/%sudo   ALL=NOPASSWD: ALL/' /etc/sudoers


################################################################################
## set up configs
RUN sudo su $USER -c "mkdir -p /home/$USER/configs"
RUN chown $USER:$USER -R /home/$USER/configs

## bash config
RUN cd /home/$USER && sudo su $USER -c "rm -f /home/$USER/.bashrc" && sudo su $USER -c "ln -s /home/$USER/configs/.bashrc /home/$USER/"

## vim config
RUN cd /home/$USER && sudo su $USER -c "rm -f /home/$USER/.vimrc" && sudo su $USER -c "ln -s /home/$USER/configs/.vimrc /home/$USER/"

## emacs config
RUN cd /home/$USER && sudo su $USER -c "rm -f /home/$USER/.emacs" && sudo su $USER -c "ln -s /home/$USER/configs/.emacs /home/$USER/"

## get sources
RUN cd /home/$USER && sudo su $USER -c "git config --global http.sslVerify false"
RUN cd /home/$USER && sudo su $USER -c "git config --global http.postBuffer 1048576000"
RUN cd /home/$USER && sudo su $USER -c "git clone -j4 --depth=1 --branch $KVERSION https://github.com/Rubusch/linux.git"
RUN cd /home/$USER/linux && sudo su $USER -c "git checkout $KVERSION -b $KVERSION || true"

## get defconfigs
## NB: is done separately in build.sh


################################################################################
## command mode
COPY build.sh /usr/local/bin/build.sh
CMD ["/bin/bash", "/usr/local/bin/build.sh"]
