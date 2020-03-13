FROM debian:10
#FROM debian:testing
MAINTAINER Lothar Rubusch <l.rubusch@gmail.com>
ENV DEBIAN_FRONTEND=noninteractive


################################################################################
## the USER is needed to make it available as --build-arg
## in case docker complains for a not set USER, perhaps you forgot to use --build-arg USER=$USER
ARG USER="${USER}"


################################################################################
## set up apt fully functional

RUN apt-get update && apt-get upgrade -y && apt-get autoremove -y --purge

## container essentials - linux build, patch creation
RUN apt-get install -y locales
RUN apt-get install -y zlib1g-dev
RUN apt-get install -y g++
RUN apt-get install -y build-essential
RUN apt-get install -y sudo
RUN apt-get install -y libssl-dev
RUN apt-get install -y bison
RUN apt-get install -y flex
RUN apt-get install -y bc
RUN apt-get install -y libncurses5-dev
RUN apt-get install -y libelf-dev
RUN apt-get install -y python3-all
RUN apt-get install -y rsync
RUN apt-get install -y binutils
RUN apt-get install -y unzip
RUN apt-get install -y bzip2
RUN apt-get install -y make
RUN apt-get install -y gcc
RUN apt-get install -y cpio
RUN apt-get install -y libc6-dev
RUN apt-get install -y fakeroot
RUN apt-get install -y udev
RUN apt-get install -y hdparm
RUN apt-get install -y xmlto
RUN apt-get install -y perl
RUN apt-get install -y wget
RUN apt-get install -y curl
RUN apt-get install -y bin86

## kernel - generate documentation
RUN apt-get install -y doxygen
RUN apt-get install -y kmod
RUN apt-get install -y imagemagick
RUN apt-get install -y dvipng
RUN apt-get install -y fonts-noto-cjk
RUN apt-get install -y latexmk
RUN apt-get install -y librsvg2-bin
RUN apt-get install -y virtualenv
RUN apt-get install -y python3-sphinx
RUN apt-get install -y python3-sphinx-rtd-theme
RUN apt-get install -y python3-ply
RUN apt-get install -y python3-git

## special - coccinelle
RUN apt-get install -y libpython2.7-dev
RUN apt-get install -y pkg-config
RUN apt-get install -y ocaml-native-compilers
RUN apt-get install -y ocaml-findlib
RUN apt-get install -y menhir
RUN apt-get install -y libmenhir-ocaml-dev
RUN apt-get install -y libpcre-ocaml-dev
RUN apt-get install -y libparmap-ocaml-dev
RUN apt-get install -y texlive-fonts-extra
RUN apt-get install -y autoconf
RUN apt-get install -y libtool
RUN apt-get install -y libtool-bin

## special - security
RUN apt-get install -y libkcapi-dev

## special - i2c (this actually is a build container)
#RUN apt-get install -y i2c-tools

## special - git
## FIXME: currently broken!
#RUN apt-get install -y git-all

## kernel - development, tools
RUN apt-get install -y aptitude
RUN apt-get install -y bsdmainutils
RUN apt-get install -y device-tree-compiler
RUN apt-get install -y graphviz
RUN apt-get install -y coccinelle
RUN apt-get install -y codespell
RUN apt-get install -y clang-format
RUN apt-get install -y clang-tools
RUN apt-get install -y clang-tidy
RUN apt-get install -y exuberant-ctags
RUN apt-get install -y tree
RUN apt-get install -y mc
RUN apt-get install -y colordiff
RUN apt-get install -y tig
RUN apt-get install -y dos2unix
RUN apt-get install -y emacs-nox
RUN apt-get install -y vim


################################################################################
## locale sttings
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
RUN chown $USER:$USER -R /usr/local


################################################################################
## set up tools
USER $USER
WORKDIR /home/$USER

## bash config
RUN rm -f /home/$USER/.bashrc && ln -s /home/$USER/configs/.bashrc /home/$USER/

## vim config
RUN rm -f /home/$USER/.vimrc && ln -s /home/$USER/configs/.vimrc /home/$USER/

## emacs config
RUN rm -f /home/$USER/.emacs && ln -s /home/$USER/configs/.emacs /home/$USER/

################################################################################
## documentation requirements (probably not needed due to package 'python3-sphinx')
USER $USER
WORKDIR /home/$USER/linux

#RUN /usr/bin/virtualenv sphinx_1.7.9
#RUN source sphinx_1.7.9/bin/activate && pip install -r ./Documentation/sphinx/requirements.txt && deactivate


################################################################################
## coccinelle
USER $USER
WORKDIR /home/$USER

RUN git clone https://github.com/coccinelle/coccinelle.git

WORKDIR /home/$USER/coccinelle

RUN ./autogen
#RUN ./configure
RUN ./configure --disable-documentation --disable-dtls
RUN make

USER root
WORKDIR /home/$USER/coccinelle
RUN make install


################################################################################
## command mode
USER root
WORKDIR /home/$USER

## codespell: dictionary fix
RUN mkdir -p /usr/share/codespell
RUN ln -s /usr/lib/python3/dist-packages/codespell_lib/data/dictionary.txt /usr/share/codespell/dictionary.txt

## setup default script
COPY build.sh /usr/local/bin/build.sh
CMD ["/bin/bash", "/usr/local/bin/build.sh"]
