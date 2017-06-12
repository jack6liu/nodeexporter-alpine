# nodeexporter-alpine

prometheus nodeexporter with shell script for checking docker instance running state

## features

- http basic_auth enabled, the default username is `nodeexporter` with password `nodeexporter`
- a shell script with and cronjob for checking docker instance running state every 5 seconds, and using the textfile exporter for exporting metrics
- metric name is `docker_container_is_running`

## environment variables

- LISTEN_PORT for nginx reverse proxy listening on, default is `9100`
- NODE_EXPORTER_LISTEN_PORT for nodeexporter listen on inside the container, default is `4321`

## sample usage

check the `run-demo.sh`

```bash
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

```