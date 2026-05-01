server {
    listen ${LISTEN_PORT};

    location /static {
        alias /vol/static;
    }

    location /recipe-api-app/ {
        rewrite ^/recipe-api-app(/.*)$ $1 break;
        uwsgi_pass           ${APP_HOST}:${APP_PORT};
        include              /etc/nginx/uwsgi_params;
        client_max_body_size 10M;
    }

    location / {
        uwsgi_pass           ${APP_HOST}:${APP_PORT};
        include              /etc/nginx/uwsgi_params;
        client_max_body_size 10M;
    }
}