#!/bin/bash
#
# Need bash, jq and curl
#
metric_name='docker_container_is_running'

# get all container lists and total numbers
container_info_list=`curl --silent --unix-socket /var/run/docker.sock http://localhost/containers/json?all=true`
total_container_number=`echo ${container_info_list} | jq -r '.[].Id' | wc -l`

# if there is no containers, skip this metric
if [[ ${total_container_number} -eq 0 ]]; then
    exit 0
fi

# output metric help and type
echo "# HELP ${metric_name} check the containers is running or not, possible values are running=0, exited=1, dead=2, paused=3, created=4, restarting=5, removing=6."
echo "# TYPE ${metric_name} counter"

cnt=0
while [ ${cnt} -lt ${total_container_number} ] ; do
    # get container info as metric labels
    id=`echo ${container_info_list} | jq -r .[${cnt}].Id`
    name=`echo ${container_info_list} | jq -r .[${cnt}].Names[0][1:]`
    image=`echo ${container_info_list} | jq -r .[${cnt}].Image`
    state=`echo ${container_info_list} | jq -r .[${cnt}].State`
    status=`echo ${container_info_list} | jq -r .[${cnt}].Status`
    created=`echo ${container_info_list} | jq -r .[${cnt}].Created`

    # set is_running according to container.state
    # possible state --> running=0, exited=1, dead=2, paused=3, created=4, restarting=5, removing=6
    case ${state,,} in
        running)
            is_running=0
            ;;
        exited)
            is_running=1
            ;;
        dead)
            is_running=2
            ;;
        paused)
            is_running=3
            ;;
        created)
            is_running=4
            ;;
        restarting)
            is_running=5
            ;;
        removing)
            is_running=6
            ;;
        *)
            is_running=9
            ;;
    esac

    # output to metric
    echo "${metric_name}{id=\"${id}\",name=\"${name}\",image=\"${image}\",state=\"${state}\",status=\"${status}\",created=\"${created}\"} ${is_running}"

    let cnt+=1
done
