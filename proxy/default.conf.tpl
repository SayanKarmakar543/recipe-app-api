server {
    listen ${LISTEN_PORT};

    location /static {
        alias /vol/static;
    }

    location /recipe-api-app {
        uwsgi_pass           ${APP_HOST}:${APP_PORT};
        include              /etc/nginx/uwsgi_params;
        uwsgi_param          SCRIPT_NAME /recipe-api-app;
        uwsgi_modifier1      30;
        client_max_body_size 10M;
    }

    location / {
        uwsgi_pass           ${APP_HOST}:${APP_PORT};
        include              /etc/nginx/uwsgi_params;
        client_max_body_size 10M;
    }
}