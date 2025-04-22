#!/bin/sh
set -e

# Generate initial config without SSL
envsubst '${LISTEN_PORT} ${APP_HOST} ${APP_PORT}' < /etc/nginx/default.conf.tpl > /etc/nginx/conf.d/default.conf

# Start Nginx temporarily
nginx -g "daemon on;"

# Get certificates if they don't exist
if [ ! -f /etc/letsencrypt/live/codemydream.in/fullchain.pem ]; then
  echo "Obtaining SSL certificates..."
  certbot --nginx -d codemydream.in -d www.codemydream.in \
    --non-interactive --agree-tos \
    --email codemydream@gmail.com || true
fi

# Stop temporary Nginx
nginx -s quit

# Generate final config with SSL
envsubst '${LISTEN_PORT} ${APP_HOST} ${APP_PORT}' < /etc/nginx/default.conf.tpl > /etc/nginx/conf.d/default.conf

# Start Nginx properly
exec nginx -g "daemon off;"