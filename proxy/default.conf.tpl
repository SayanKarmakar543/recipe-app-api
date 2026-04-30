server {
    listen ${LISTEN_PORT};

    location /static {
        alias /vol/static;
    }

    location ~ ^/recipe-api-app/(.*)$ {
        uwsgi_pass           ${APP_HOST}:${APP_PORT};
        include              /etc/nginx/uwsgi_params;
        client_max_body_size 10M;
        uwsgi_param          PATH_INFO /$1;
        uwsgi_param          SCRIPT_NAME /recipe-api-app;
    }

    location / {
        uwsgi_pass           ${APP_HOST}:${APP_PORT};
        include              /etc/nginx/uwsgi_params;
        client_max_body_size 10M;
    }
}