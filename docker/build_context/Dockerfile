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
	apt-file \
	psmisc \
	graphviz \
	u-boot-tools \
	tree \
	mc \
	colordiff \
	tig \
	dos2unix \
	emacs \
	vim \
	chrpath \
	diffstat \
	gawk \
	texinfo \
	libsdl1.2-dev \
	xterm \
	screen \
	locales \
	sudo \
	bc \
	libelf-dev \
	python3-all \
	rsync \
	binutils \
	bzip2 \
	libc6-dev \
	fakeroot \
	udev \
	hdparm \
	xmlto \
	curl \
	bin86 \
	gcc \
	net-tools \
	ncurses-dev \
	openssl \
	libssl-dev \
	flex \
	bison \
	autoconf \
	libtool \
	zlib1g-dev \
	gcc-multilib \
	build-essential \
	automake \
	pax \
	g++ \
	device-tree-compiler \
	make \
	libncurses5-dev \
	python3-pip \
	tar \
	unzip \
	gzip \
	util-linux \
	patch

## container essentials
RUN apt-get install -y \
	python3-dialog \
	mercurial \
	libc6-i386 \
	aptitude \
	bsdmainutils \
	i2c-tools \
	zstd \
	expect \
	lz4 \
	iproute2 \
	tftpd \
	libselinux1 \
	wget \
	socat \
	tofrodos \
	debianutils \
	iputils-ping \
	libegl1-mesa \
	pylint \
	python3 \
	python2 \
	cpio \
	gnupg \
	zlib1g:i386 \
	haveged \
	perl \
	lib32stdc++6 \
	libgtk2.0-0:i386 \
	libfontconfig1:i386 \
	libx11-6:i386 \
	libxext6:i386 \
	libxrender1:i386 \
	libsm6:i386 \
	xinetd \
	xz-utils \
	python3-git \
	python3-jinja2 \
	python3-pexpect \
	liberror-perl \
	mtd-utils \
	xtrans-dev \
	libxcb-randr0-dev \
	libxcb-xtest0-dev \
	libxcb-xinerama0-dev \
	libxcb-shape0-dev \
	libxcb-xkb-dev \
	openssh-server \
	sysvinit-utils \
	google-perftools \
	libncurses5 \
	libncursesw5-dev \
	libncurses5:i386 \
	libtinfo5 \
	libstdc++6:i386 \
	libgtk2.0-0:i386 \
	dpkg-dev:i386 \
	ocl-icd-libopencl1 \
	opencl-headers \
	ocl-icd-opencl-dev \
	x11-apps \
	emacs-goodies-el \
	emacs-goodies-extra-el \
	exuberant-ctags \
	doxygen

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
