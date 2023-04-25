#!/bin/bash
direct(){
    # install v2ray-core
    bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh)
    bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-dat-release.sh)
    
    # install deps
    install_software 'nginx'

    # download config template
    curl -o $V2RAY_CONFIG_PATH -L https://raw.githubusercontent.com/devcxl/EasyShells/master/src/v2rayinstall/template/directConfig.json.template
    
    # configure config
    if [ -z "$IN_PORT" ]; then
        random_port
        IN_PORT=$random_port
    fi
    sed -i "s/{IN_PORT}/$IN_PORT/g" $V2RAY_CONFIG_PATH

    if [ -z "$IN_UUID" ]; then
        IN_UUID=$(cat /proc/sys/kernel/random/uuid)
    fi
    sed -i "s/{IN_UUID}/$IN_UUID/g" $V2RAY_CONFIG_PATH

    if [ -z "$IN_WS_PATH" ]; then
        IN_WS_PATH=$(openssl rand -hex 16)
    fi
    sed -i "s/{IN_WS_PATH}/$IN_WS_PATH/g" $V2RAY_CONFIG_PATH

    curl -o $NGINX_CONFIG_PATH -L https://raw.githubusercontent.com/devcxl/EasyShells/master/src/v2rayinstall/template/v2ray.conf.template

    if [ -z "$SERVER_DOMAIN" ]; then
        error '$SERVER_DOMAIN not be null.'
    fi
    sed -i "s/{SERVER_DOMAIN}/$SERVER_DOMAIN/g" $NGINX_CONFIG_PATH
    sed -i "s/{IN_PORT}/$IN_PORT/g" $NGINX_CONFIG_PATH
    sed -i "s/{IN_WS_PATH}/$IN_WS_PATH/g" $NGINX_CONFIG_PATH

    if [ -z "$TLS_FLAG" ]; then
        warn 'Are you sure not to use TLS encryption?'
    else
        install_software 'python3'

        if ! install_software 'python3-venv';then
            warn 'install python3-venv error'
        fi
        if ! install_software 'libaugeas0';then
            warn 'install libaugeas0 error'
        fi
        if ! install_software 'augeas-libs';then
            warn 'install augeas-libs error'
        fi
        python3 -m venv /opt/certbot/
        /opt/certbot/bin/pip install --upgrade pip
        /opt/certbot/bin/pip install certbot certbot
        ln -s /opt/certbot/bin/certbot /usr/bin/certbot
        certbot certonly --webroot --webroot-path /usr/share/nginx/html -d $SERVER_DOMAIN
    fi

    # warn: v2ray version must > 5
    if  v2ray test -c $V2RAY_CONFIG_PATH ;then
        info 'config.json verify successful.'
        systemctl enable --now v2ray
    fi

    systemctl enable --now nginx

}