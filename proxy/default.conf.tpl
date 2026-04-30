server {
    listen ${LISTEN_PORT};

    location /static {
        alias /vol/static;
    }

    location /recipe-api-app/ {
        uwsgi_pass           ${APP_HOST}:${APP_PORT};
        include              /etc/nginx/uwsgi_params;
        client_max_body_size 10M;
        rewrite              ^/recipe-api-app/(.*) /$1 break;
    }

    location / {
        uwsgi_pass           ${APP_HOST}:${APP_PORT};
        include              /etc/nginx/uwsgi_params;
        client_max_body_size 10M;
    }
}