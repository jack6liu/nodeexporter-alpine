#!/bin/bash
#
# variables
#
IMG='jack6liu/nodeexporter'
TAG='0.14.0'

#
# fuction
#

build() {
    echo ">> building ${IMG}:${TAG} <<"
    docker build . -t ${IMG}:${TAG}
    echo ">> tagging ${IMG}:latest <<"
    docker tag ${IMG}:${TAG} ${IMG}:latest
}

push() {
    echo ">> pushing ${IMG}:${TAG} <<"
    docker push ${IMG}:${TAG}
    echo ">> pushing ${IMG}:latest <<"
    docker push ${IMG}:latest
}

usage() {
    echo "Only 1 options accept, used for push image to docker hub"
    echo "Avalible options: -help, -build, -push, -all"
    echo "    -help,   display this help message"
    echo "    -build,  docker build and tag to latest, this is DEFAULT"
    echo "    -push,   only push to docker hub"
    echo "    -all,    build and then push to docker hub"
}

option=${option:='-help'}

if [ $# -ne 1 ]; then
    usage
    exit 1
fi

option=$1

case ${option} in
    -build)
        build
        ;;
    -push)
        push
        ;;
    -all)
        build
        push
        ;;
    -help)
        usage
        ;;
    *)
        usage
        ;;
esac

