FROM debian:10
MAINTAINER Lothar Rubusch <lotophagon@protonmail.com>
WORKDIR /root
ENV DEBIAN_FRONTEND=noninteractive


################################################################################
## the USER is needed to make it available as --build-arg
## in case docker complains for a not set USER, perhaps you forgot to use --build-arg USER=$USER
ARG USER=""

## the branch
ARG KVERSION="v5.5"
ARG KDEFCONFIG_BRANCH="lothar/${KVERSION}-thinkpad-x1"


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
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8


################################################################################
## setup user and run stuff under user
RUN useradd "$USER" -m --password "$USER"
RUN usermod -a -G sudo "$USER"
RUN sed -i '/%sudo/s/.*/%sudo   ALL=NOPASSWD: ALL/' /etc/sudoers


################################################################################
## get sources
RUN cd /home/$USER && sudo su $USER -c "git clone -j4 --depth=1 --branch $KVERSION https://github.com/Rubusch/linux.git"
RUN cd /home/$USER/linux && sudo su $USER -c "git checkout $KVERSION -b $KVERSION"

## defconfigs
RUN cd /home/$USER && sudo su $USER -c "git clone -j4 --depth=1 --branch $KDEFCONFIG_BRANCH https://github.com/Rubusch/linux-defconfigs.git"
RUN cd /home/$USER/linux/arch/x86/configs && sudo su $USER -c "ln -s /home/user/linux-defconfigs/arch/x86/configs/* ."


################################################################################
## command mode
COPY build.sh /usr/local/bin/build.sh
CMD ["/bin/bash", "/usr/local/bin/build.sh"]
