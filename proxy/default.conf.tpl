server {
    listen ${LISTEN_PORT};

    # Redirect HTTP to HTTPS (this should be on port 80)
    if ($scheme = http) {
        return 301 https://$host$request_uri;
    }

    location /static {
        alias /vol/static;
    }

    location / {
        uwsgi_pass              ${APP_HOST}:${APP_PORT};
        include                 /etc/nginx/uwsgi_params;
        client_max_body_size    10M;
    }
}

# HTTPS server block (this should be on port 443)
server {
    listen 443 ssl;
    server_name codemydream.in www.codemydream.in;

    ssl_certificate /etc/letsencrypt/live/codemydream.in/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/codemydream.in/privkey.pem;

    # Static file location
    location /static {
        alias /vol/static;
    }

    # Reverse proxy to application
    location / {
        uwsgi_pass              ${APP_HOST}:${APP_PORT};
        include                 /etc/nginx/uwsgi_params;
        client_max_body_size    10M;
    }
}