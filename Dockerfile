#
# node_exporter
#
FROM        alpine:3.5
LABEL       vendor="jack6.liu"                                       \
            version="0.14.0"
ENV         LISTEN_PORT=${LISTEN_PORT:-'9100'}                       \
            NODE_EXPORTER_LISTEN_PORT=${NODE_EXPORTER_LISTEN_PORT:-'4321'}
COPY        files /files
RUN         apk update &&                                            \
            apk --no-cache add nginx gettext bash jq curl &&         \
            rm -f /etc/nginx/conf.d/* &&                             \
            mv /files/auth.conf /auth.conf &&                        \
            mv /files/auth.htpasswd /etc/nginx/ &&                   \
            mkdir -p /run/nginx/ &&                                  \
            chmod 777 -R /run/nginx/ &&                              \
            mv /files/node_exporter /bin/node_exporter &&            \
            chmod a+x /bin/node_exporter &&                          \
            mv /files/start_nodeexporter.sh /bin/start_nodeexporter.sh &&                    \
            chmod a+x /bin/start_nodeexporter.sh &&                  \
            mv /files/docker_container_is_running.sh /bin/docker_container_is_running.sh &&  \
            chmod +x /bin/docker_container_is_running.sh &&          \
            mv /files/docker_container_is_running_collector.sh /bin/docker_container_is_running_collector.sh && \
            chmod +x /bin/docker_container_is_running_collector.sh &&               \
            cat /files/docker_container_is_running_cronjob >> /etc/crontabs/root && \
            rm -rf /files &&                                         \
            rm -rf /var/cache/apk/*
EXPOSE      ${LISTEN_PORT}
ENTRYPOINT  ["/bin/start_nodeexporter.sh"]

