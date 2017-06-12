#!/bin/bash
NAME=${NAME:='demo'}
PORT=${PORT:='9100'}
IMG='jack6liu/nodeexporter'
TAG='0.14.0'

if [[ "$1" ]]; then
    NAME=$1
fi
if [[ "$2" ]]; then
    PORT=$2
fi

echo ">> run ${NAME} and listen on ${PORT} <<"
docker run -d                                           \
           --name ${NAME}                               \
           --hostname ${NAME}                           \
           -v "/proc:/host/proc"                        \
           -v "/sys:/host/sys"                          \
           -v "/:/rootfs"                               \
           -v /var/run/docker.sock:/var/run/docker.sock:ro       \
           -v $(pwd):/textfile                          \
           -p ${PORT}:9100                              \
           ${IMG}:${TAG}                                \
           -collector.procfs /host/proc                 \
           -collector.sysfs /host/sys                   \
           -collector.filesystem.ignored-mount-points "^/(sys|proc|dev|host|etc)($|/)" \
           -collector.textfile.directory "/textfile"
