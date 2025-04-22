# HTTP server block (port 80)
server {
    listen 80;
    server_name codemydream.in www.codemydream.in;

    # Redirect all HTTP requests to HTTPS
    return 301 https://$host$request_uri;
}

# HTTPS server block (port 443)
server {
    listen 443 ssl;
    server_name codemydream.in www.codemydream.in;

    ssl_certificate /etc/letsencrypt/live/codemydream.in/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/codemydream.in/privkey.pem;

    # SSL configuration
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_prefer_server_ciphers on;
    ssl_ciphers "EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH";

    # Static files
    location /static {
        alias /vol/static;
    }

    # Django app
    location / {
        uwsgi_pass ${APP_HOST}:${APP_PORT};
        include /etc/nginx/uwsgi_params;
        client_max_body_size 10M;
    }
}