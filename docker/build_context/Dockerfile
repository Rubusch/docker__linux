################################################################################
## ATTENTION: multistage build
##
## based on current USER and TAG, DOCKER_BASE
##
################################################################################
## base image settings
ARG USER="${USER}"
ARG DOCKER_BASE="ubu2204"
ARG DOCKER_BASE_TAG="ubu2204-20221011"    


################################################################################
## base image
FROM ${USER}/${DOCKER_BASE}:${DOCKER_BASE_TAG} AS linux
MAINTAINER Lothar Rubusch <l.rubusch@gmail.com>
ENV DEBIAN_FRONTEND=noninteractive


################################################################################
## environment (applied ARG/ENV must come after FROM declaration)
ARG USER="${USER}"


################################################################################
## container additionals
USER root

#RUN dpkg --add-architecture i386
RUN apt update
RUN apt install -y \
	expect \
	zstd


################################################################################
## apt
USER root
RUN apt-get update && apt-get upgrade -y && apt-get autoremove -y --purge
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
