#!/bin/bash
relay(){
    bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh)
    bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-dat-release.sh)
    
    # download config template
    curl -o $V2RAY_CONFIG_PATH -L https://raw.githubusercontent.com/devcxl/EasyShells/master/src/v2rayinstall/template/relayConfig.json.template

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


    if [ -z "$OUT_DOMAIN" ]; then
        error "\$OUT_DOMAIN not be null."
    fi
    sed -i "s/{OUT_DOMAIN}/$OUT_DOMAIN/g" $V2RAY_CONFIG_PATH


    if [ -z "$OUT_PORT" ]; then
        error "\$OUT_PORT not be null."
    fi
    sed -i "s/{OUT_PORT}/$OUT_PORT/g" $V2RAY_CONFIG_PATH


    if [ -z "$OUT_UUID" ]; then
        error "\$OUT_UUID not be null."
    fi
    sed -i "s/{OUT_UUID}/$OUT_UUID/g" $V2RAY_CONFIG_PATH


    if [ -z "$OUT_WS_PATH" ]; then
        error "\$OUT_WS_PATH not be null."
    fi
    sed -i "s/{OUT_WS_PATH}/$OUT_WS_PATH/g" $V2RAY_CONFIG_PATH

    # warn: v2ray version must > 5
    if  v2ray test -c $V2RAY_CONFIG_PATH ;then
        info 'config.json verify successful.'
        systemctl enable --now v2ray
    fi

    systemctl enable --now nginx


}