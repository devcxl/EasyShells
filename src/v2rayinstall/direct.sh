#!/bin/bash
direct(){
    bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh)
    bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-dat-release.sh)
    install_software 'python3' 
    install_software 'python3-venv' 
    install_software 'libaugeas0' 
    install_software 'nginx'

    python3 -m venv /opt/certbot/
    /opt/certbot/bin/pip install --upgrade pip
    /opt/certbot/bin/pip install certbot certbot
    ln -s /opt/certbot/bin/certbot /usr/bin/certbot
    certbot certonly --webroot --webroot-path /usr/share/nginx/html

}