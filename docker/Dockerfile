FROM debian:10
MAINTAINER Lothar Rubusch <lotophagon@protonmail.com>
WORKDIR /root
ENV DEBIAN_FRONTEND=noninteractive


################################################################################
## the USER is needed to make it available as --build-arg
## in case docker complains for a not set USER, perhaps you forgot to use --build-arg USER=$USER
ARG USER=""

## the branch
#ARG BRANCH="lothar/kconfig"
ARG BRANCH="lothar/develop"


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
    bc \
    tig \
    aptitude \
    emacs

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
#RUN cd /home/$USER && sudo su $USER -c "git clone -j4 --depth=1 --branch $BRANCH https://github.com/Rubusch/linux.git linux"
RUN cd /home/$USER && sudo su $USER -c "git clone -b staging-testing git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git linux"

## prepare paths
RUN sudo su $USER -c "mkdir -p /home/$USER/output"

## documentation requirements (probably not needed due to package 'python3-sphinx')
#RUN cd /home/$USER/linux && sudo su $USER -c "/usr/bin/virtualenv sphinx_1.7.9"
#RUN cd /home/$USER/linux && sudo su $USER -c "source sphinx_1.7.9/bin/activate && pip install -r ./Documentation/sphinx/requirements.txt && deactivate"

## reset permissions
RUN chown $USER:$USER -R /home/$USER/output


################################################################################
## set up tools

## vim config
RUN cd /home/$USER && sudo su $USER -c "rm -f /home/$USER/.vimrc" && sudo su $USER -c "ln -s /home/$USER/output/.vimrc /home/$USER/"

## emacs config
RUN cd /home/$USER && sudo su $USER -c "rm -f /home/$USER/.emacs" && sudo su $USER -c "ln -s /home/$USER/output/.emacs /home/$USER/"

## git config
RUN cd /home/$USER && sudo su $USER -c "git config --global user.name \"Lothar Rubusch\""
RUN cd /home/$USER && sudo su $USER -c "git config --global user.email lotophagon@protonmail.com"


################################################################################
## command mode
COPY build.sh /usr/local/bin/build.sh
CMD ["/bin/bash", "/usr/local/bin/build.sh"]
