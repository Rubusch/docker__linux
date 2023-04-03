################################################################################
## ATTENTION: standalone container
##
################################################################################
FROM ubuntu:22.04 AS ubu2204
MAINTAINER Lothar Rubusch <l.rubusch@gmail.com>
ENV DEBIAN_FRONTEND=noninteractive

################################################################################
## the USER is needed to make it available as --build-arg
ARG USER="${USER}"
ARG UID="${UID}"
ARG GID="${GID}"
ENV MY_CONFIGS="/home/$USER/configs"

################################################################################
## set up apt fully functional
USER root
RUN dpkg --add-architecture i386
RUN apt-get update && apt-get autoremove -y --purge

## development
RUN apt-get install -y \
	binutils \
	bzip2 \
	xz-utils \
	libc6-dev \
	fakeroot \
	xterm \
	locales \
	sudo \
	bc \
	curl \
	wget \
	bin86 \
	ncurses-dev \
	libssl-dev \
	flex \
	bison \
	autoconf \
	libtool \
	libtool-bin \
	make \
	libncurses5-dev \
	openssl \
	zlib1g-dev \
	gcc-multilib \
	build-essential \
	automake \
	pax \
	g++ \
	gcc \
	expect \
	socat \
	tree \
	mc \
	rsync \
	screen \
	colordiff \
	dos2unix \
	gnupg \
	chrpath \
	diffstat \
	gawk \
	net-tools \
	tig \
	apt-file \
	aptitude \
	texinfo \
	libsdl1.2-dev \
	libelf-dev \
	python3-all \
	psmisc \
	udev \
	hdparm \
	xmlto \
	u-boot-tools \
	device-tree-compiler \
	i2c-tools \
	mtd-utils \
	perl \
	python3 \
	python3-pip \
	tar \
	unzip \
	gzip \
	cpio \
	util-linux \
	patch \
	debianutils \
	graphviz \
	doxygen \
	xinetd \
	tftpd \
	tftp \
	emacs \
	emacs-goodies-el \
	emacs-goodies-extra-el \
	exuberant-ctags \
	vim

## special - git
RUN apt-get install -y git-all

################################################################################
## system settings

## set shell to bash instead of dash non-interactively
## ref: https://superuser.com/questions/715722/how-to-do-dpkg-reconfigure-dash-as-bash-automatically
RUN echo "dash dash/sh boolean false" | debconf-set-selections
RUN DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash

## locale settings
USER root
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

################################################################################
## user settings
USER root
RUN groupadd -g "$GID" "$USER"
RUN useradd -m -u "$UID" -g "$GID" -s /bin/bash "$USER"
RUN usermod -a -G "sudo" "$USER"
RUN sed -i '/%sudo/s/.*/%sudo   ALL=NOPASSWD: ALL/' /etc/sudoers
RUN mkdir -p /usr/local
RUN chown -R "${USER}":"${USER}" /usr/local
RUN mkdir -p /opt
RUN chown -R "${USER}":"${USER}" /opt
RUN adduser "$USER" dialout

################################################################################
## tftp server
USER root
RUN echo -e '\
service tftp\n\
    {\n\
    protocol = udp\n\
    port = 69\n\
    socket_type = dgram\n\
    wait = yes\n\
    user = nobody\n\
    server = /usr/sbin/in.tftpd\n\
    server_args = /tftpboot\n\
    disable = no\n\
    }\n\
' > /etc/xinetd.d/tftp

RUN mkdir /tftpboot
RUN chmod -R 777 /tftpboot
RUN chown -R nobody /tftpboot
RUN /etc/init.d/xinetd stop tftp
RUN /etc/init.d/xinetd start tftp

################################################################################
## configs
USER ${USER}
WORKDIR /home/${USER}
RUN rm -rf .local
RUN ln -s /usr/local .local

## bash config
RUN rm -f /home/$USER/.bashrc && ln -s ${MY_CONFIGS}/.bashrc /home/$USER/

## vim config
RUN rm -f /home/$USER/.vimrc && ln -s ${MY_CONFIGS}/.vimrc /home/$USER/

## emacs config
RUN rm -f /home/$USER/.emacs && ln -s ${MY_CONFIGS}/.emacs /home/$USER/

## user
RUN echo "export USER=${USER}" >> /home/$USER/.profile

## ssh preparations
RUN mkdir -p /home/$USER/.ssh

################################################################################
## apt
USER root
RUN apt-get update && apt-get autoremove -y --purge
RUN apt-get install -y latexmk
RUN apt-get install -y librsvg2-bin
RUN apt-get install -y virtualenv
RUN apt-get install -y python3-sphinx
RUN apt-get install -y python3-sphinx-rtd-theme
RUN apt-get install -y python3-ply
RUN apt-get install -y python3-git

################################################################################
## sources
USER root

## mountpoints
RUN mkdir -p /home/$USER/workspace
RUN mkdir -p /home/$USER/configs

## reset permissions
RUN chown $USER:$USER -R /home/$USER/

################################################################################
## crypto
#USER root
#RUN apt-get install -y libkcapi-dev

################################################################################
## command mode
USER root

## codespell: dictionary fix
RUN mkdir -p /usr/share/codespell
RUN ln -s /usr/lib/python3/dist-packages/codespell_lib/data/dictionary.txt /usr/share/codespell/dictionary.txt

################################################################################
## command mode
USER ${USER}
WORKDIR /home/$USER
COPY *.sh /usr/local/bin/
CMD ["/bin/bash", "/usr/local/bin/build.sh"]
