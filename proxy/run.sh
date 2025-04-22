#!/bin/sh
set -e

# Generate config with SSL settings
envsubst '${LISTEN_PORT} ${APP_HOST} ${APP_PORT}' \
  < /etc/nginx/default.conf.tpl > /etc/nginx/conf.d/default.conf

# Start Nginx
exec nginx -g "daemon off;"