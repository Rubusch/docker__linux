#!/bin/sh
#set -x
die()
{
	echo "$@"
	exit 1
}

test -d "docker" || die "wrong directory, execute script from top level"
cd ./docker
docker run \
	--rm \
	--name linux-develop \
	-u $(id -u):$(id -g) \
	-i -t \
	--privileged \
	-e USER \
	--env-file .env \
	--group-add 20 \
	--mount type=bind,source=/home/user/.ssh,target=/home/${USER}/.ssh \
	--mount type=bind,source=$(pwd)/build_configs,target=/home/$USER/configs \
	-v ./workspace:/home/$USER/workspace \
	${USER}/linux-develop \
	/bin/bash
