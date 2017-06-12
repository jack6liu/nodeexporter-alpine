#!/bin/sh
#
#
# start crond
crond

# prepare config files for nginx
envsubst < /auth.conf > /etc/nginx/conf.d/auth.conf

#
# nginx start with default /etc/nginx/nginx.conf
#nginx -g "daemon off;"
nginx

#
# start node_exporter with optional args from CMD 'docker run commands'
/bin/node_exporter -web.listen-address 127.0.0.1:${NODE_EXPORTER_LISTEN_PORT} $@

