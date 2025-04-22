#!/bin/sh

set -e

envsubst < /etc/nginx/default.conf.tpl > /etc/nginx/conf.d/default.conf

# Check if certificates exist, if not, obtain them
if [ ! -f /etc/letsencrypt/live/codemydream.in/fullchain.pem ]; then
    echo "No SSL certificates found. Obtaining new ones..."
    certbot --nginx -d codemydream.in -d www.codemydream.in \
        --non-interactive --agree-tos \
        --email codemydream@gmail.com --no-eff-email || true
fi

# Start Nginx
nginx -g "daemon off;"