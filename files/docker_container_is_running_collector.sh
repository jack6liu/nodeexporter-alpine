#!/bin/bash
#
# assume docker_container_is_running.sh is located as /bin/docker_container_is_running.sh
#
# because crontab can run tasks every minute, cannot in serveral second,
#         so, let a script do tasks every ${SLEEP} seconds in a minute,
#         but, dont run the task at 60th second
SLEEP=5
let TOTAL=60/${SLEEP}
CNT=1

while [[ ${CNT} -le ${TOTAL} ]] ; do
    /bin/docker_container_is_running.sh > /textfile/docker_container_is_running.prom.$$
    mv -f /textfile/docker_container_is_running.prom.$$ /textfile/docker_container_is_running.prom
    rm -f /textfile/docker_container_is_running.prom.*
    sleep ${SLEEP}
    let CNT=CNT+1
done

