#!/bin/bash
generaor_nginx_conf() {
    cat <<EOF >/etc/nginx/conf.d/${SERVER_DOMAIN}.conf
server {
    listen 80;
    listen [::]:80;
    server_name ${SERVER_DOMAIN};
    location / {
        root /tmp/${SERVER_DOMAIN}/;
        index index.html;
    }
}
EOF

    if nginx -t; then
        nginx -s reload
    else
        error "nginx config error"
    fi
}
