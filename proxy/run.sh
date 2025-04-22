#!/bin/sh

set -e

envsubst < /etc/nginx/default.conf.tpl > /etc/nginx/conf.d/default.conf

# Start Nginx in the background
nginx

# Wait a bit to ensure Nginx is running
sleep 5

# Run Certbot to get/renew SSL certificates
certbot --nginx -d codemydream.in -d www.codemydream.in --agree-tos --no-eff-email --email codemydream@gmail.com || true

# Reload Nginx to apply the SSL certificates
nginx -s reload

# Keep the container running
tail -f /var/log/nginx/access.log