#!/usr/bin/env bash

CODERID=1000

if [[ $EUID -ne ${CODERID} ]]; then
    echo "running script with user id ${CODERID} - " "$0" "$@"
    sudo -u `sudo getent passwd ${CODERID} | cut -d':' -f1` -E "$0" "$@"
    exit
fi

VERSION="${VERSION:-latest}"

IMAGE="codercom/code-server:${VERSION}"

CODERNAME=`getent passwd ${CODERID} | cut -d':' -f1`

echo "Running as user `id -u`:`id -g`"
echo "Pulling image: ${IMAGE}"
docker pull ${IMAGE}
echo "Starting code-server"
docker network create code-server-net 2>/dev/null || true
docker container rm -f code-server 2>/dev/null || true;
test -d /home/${CODERNAME}/.config || sudo -u ${CODERNAME} mkdir -p /home/${CODERNAME}/.config
test -d /home/${CODERNAME}/source || sudo -u ${CODERNAME} mkdir -p /home/${CODERNAME}/source
docker run --rm --name code-server \
	--stop-timeout 60 \
	--network code-server-net \
	--user $(id -u):$(id -g) \
	-p 10.0.0.65:8080:8080 \
	-v /home/${CODERNAME}/.config:/home/coder/.config \
	-v /home/${CODERNAME}/source:/home/coder/project \
	-e "DOCKER_USER=${CODERNAME}" \
	${IMAGE} ;

