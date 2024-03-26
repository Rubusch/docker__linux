#!/bin/sh
#set -x
die()
{
	echo "FAILED! $@"
	exit 1
}

test -z "$HOME" && die "HOME is not set"
test -z "$USER" && die "USER is not set"
test -d "docker" || die "wrong directory, execute script from top level"

cd ./docker

if [ ! -z "$(docker images -q ${USER}/linux-develop)" ]; then
	docker build \
		--build-arg UID=$(id -u) \
		--build-arg GID=$(id -g) \
		--build-context context=./build_context \
		-t ${USER}/linux-develop \
		./build_context
	exit 0
fi

if [ ! -f .env ]; then
    echo "UID=$(id -u)" > .env
    echo "GID=$(id -g)" >> .env
fi

echo "now source the environment:"
echo "$ source ./workspace/source-me.sh"
docker run \
	--rm \
	--name linux-develop \
	-u $(id -u):$(id -g) \
	-it \
	--privileged \
	-e USER \
	--env-file .env \
	--group-add 20 \
	--mount type=bind,source=${HOME}/.ssh,target=/home/${USER}/.ssh \
	--mount type=bind,source=$(pwd)/build_configs,target=/home/$USER/configs \
	-v ./workspace:/home/$USER/workspace \
	${USER}/linux-develop \
	/bin/bash

