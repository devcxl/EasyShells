#!/bin/bash
generator_ssl_cert() {
    # register
    if /usr/local/bin/certbot register --agree-tos -m $EMAIL; then
        info "$EMAIL register successful!"
    fi

    if /usr/local/bin/certbot certonly --webroot --webroot-path /tmp/${SERVER_DOMAIN}/ -d $SERVER_DOMAIN; then
        info "$SERVER_DOMAIN tls installed!"
    fi
}
