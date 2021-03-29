FROM debian:10
MAINTAINER Lothar Rubusch <l.rubusch@gmail.com>
ENV DEBIAN_FRONTEND=noninteractive


################################################################################
## the USER is needed to make it available as --build-arg
## in case docker complains for a not set USER, perhaps you forgot to use --build-arg USER=$USER
ARG USER=""

#WORKDIR /home/$USER


################################################################################
## set up apt fully functional
RUN apt-get update && apt-get upgrade -y && apt-get autoremove -y --purge
RUN apt-get install -y  \
    zlib1g-dev \
    g++ \
    build-essential \
    rsync \
    binutils \
    unzip \
    python \
    bzip2 \
    locales \
    libc6-dev \
    fakeroot \
    bin86 \
    udev \
    hdparm \
    xmlto \
    tree \
    colordiff \
    sudo

## for building documentation targets
RUN apt-get install -y  \
    kmod \
    cpio \
    imagemagick \
    graphviz \
    dvipng \
    fonts-noto-cjk \
    latexmk \
    librsvg2-bin \
    virtualenv \
    python3-sphinx \
    python3-sphinx-rtd-theme

## for building development environment
RUN apt-get install -y  \
    vim \
    libncurses5-dev \
    gcc \
    make \
    git-all \
    exuberant-ctags \
    libssl-dev \
    bison \
    flex \
    libelf-dev \
    bc

## my add ons for patch development
RUN apt-get install -y  \
    aptitude \
    tig \
    emacs-nox \
    codespell \
    python-ply \
    python-git


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
## get sources
## NOTE: this container will obtain sources in manually executed script (later), sources shall be shared between container and outside

## prepare paths
RUN mkdir -p /home/$USER/linux
RUN mkdir -p /home/$USER/configs

## reset permissions
RUN chown $USER:$USER -R /home/$USER


################################################################################
## set up tools
USER $USER

## documentation requirements (probably not needed due to package 'python3-sphinx')
#RUN cd /home/$USER/linux && /usr/bin/virtualenv sphinx_1.7.9
#RUN cd /home/$USER/linux && source sphinx_1.7.9/bin/activate && pip install -r ./Documentation/sphinx/requirements.txt && deactivate

## bash config
RUN cd /home/$USER && rm -f /home/$USER/.bashrc && ln -s /home/$USER/configs/.bashrc /home/$USER/

## vim config
RUN cd /home/$USER && rm -f /home/$USER/.vimrc && ln -s /home/$USER/configs/.vimrc /home/$USER/

## emacs config
RUN cd /home/$USER && rm -f /home/$USER/.emacs && ln -s /home/$USER/configs/.emacs /home/$USER/

## git config
RUN cd /home/$USER && rm -f /home/$USER/.gitconfig && ln -s /home/$USER/secrets/.gitconfig /home/$USER/


################################################################################
## command mode
USER root

## codespell: dictionary fix
RUN mkdir -p /usr/share/codespell
RUN ln -s /usr/lib/python3/dist-packages/codespell_lib/data/dictionary.txt /usr/share/codespell/dictionary.txt

## setup default script
COPY build.sh /usr/local/bin/build.sh
CMD ["/bin/bash", "/usr/local/bin/build.sh"]
