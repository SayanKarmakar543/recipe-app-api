#!/bin/sh
set -e

# First, generate a basic nginx config without SSL
envsubst '${LISTEN_PORT} ${APP_HOST} ${APP_PORT}' < /etc/nginx/default.conf.tpl > /etc/nginx/conf.d/default.conf

# Start nginx temporarily in background
nginx -g "daemon on;"

# Run certbot only if certificates don't exist
if [ ! -f /etc/letsencrypt/live/codemydream.in/fullchain.pem ]; then
  echo "Obtaining SSL certificates..."
  certbot --nginx -d codemydream.in -d www.codemydream.in \
    --non-interactive --agree-tos \
    --email codemydream@gmail.com --no-eff-email || true
fi

# Stop the temporary nginx process
nginx -s quit

# Generate final config with SSL settings
envsubst '${LISTEN_PORT} ${APP_HOST} ${APP_PORT}' < /etc/nginx/default.conf.tpl > /etc/nginx/conf.d/default.conf

# Start nginx in foreground
nginx -g "daemon off;"