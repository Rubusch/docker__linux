FROM debian:10
MAINTAINER Lothar Rubusch <lotophagon@protonmail.com>
WORKDIR /root
ENV DEBIAN_FRONTEND=noninteractive


################################################################################
## the USER is needed to make it available as --build-arg
## in case docker complains for a not set USER, perhaps you forgot to use --build-arg USER=$USER
ARG USER=""


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
    imagemagick \
    graphviz \
    dvipng \
    fonts-noto-cjk \
    latexmk \
    librsvg2-bin \
    virtualenv \
    python3-sphinx

## for building development environment
RUN apt-get install -y  \
    vim \
    libncurses5-dev \
    gcc \
    make \
    git \
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
## NOTE: this container will obtain sources in manually executed script (later), sources shall be shared between container and outside

## prepare paths
RUN sudo su $USER -c "mkdir -p /home/$USER/linux"
RUN sudo su $USER -c "mkdir -p /home/$USER/configs"

## documentation requirements (probably not needed due to package 'python3-sphinx')
#RUN cd /home/$USER/linux && sudo su $USER -c "/usr/bin/virtualenv sphinx_1.7.9"
#RUN cd /home/$USER/linux && sudo su $USER -c "source sphinx_1.7.9/bin/activate && pip install -r ./Documentation/sphinx/requirements.txt && deactivate"

## reset permissions
RUN chown $USER:$USER -R /home/$USER/linux
RUN chown $USER:$USER -R /home/$USER/configs


################################################################################
## set up tools

## bash config
RUN cd /home/$USER && sudo su $USER -c "rm -f /home/$USER/.bashrc" && sudo su $USER -c "ln -s /home/$USER/configs/.bashrc /home/$USER/"

## vim config
RUN cd /home/$USER && sudo su $USER -c "rm -f /home/$USER/.vimrc" && sudo su $USER -c "ln -s /home/$USER/configs/.vimrc /home/$USER/"

## emacs config
RUN cd /home/$USER && sudo su $USER -c "rm -f /home/$USER/.emacs" && sudo su $USER -c "ln -s /home/$USER/configs/.emacs /home/$USER/"

## git config
RUN cd /home/$USER && sudo su $USER -c "git config --global user.name \"Lothar Rubusch\""
RUN cd /home/$USER && sudo su $USER -c "git config --global user.email lotophagon@protonmail.com"
RUN cd /home/$USER && sudo su $USER -c "git config --global alias.st status"
RUN cd /home/$USER && sudo su $USER -c "git config --global alias.ci commit"
RUN cd /home/$USER && sudo su $USER -c "git config --global alias.co checkout"
RUN cd /home/$USER && sudo su $USER -c "git config --global alias.br branch"



################################################################################
## command mode
COPY build.sh /usr/local/bin/build.sh
CMD ["/bin/bash", "/usr/local/bin/build.sh"]
