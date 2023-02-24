#!/bin/bash
client(){
    if [[ "$#" -gt '1' ]]; then
        case "$2" in
        '-v' | '--version')
            CLIENT_VERSION='1'
            ;;
        '-i' | '--install')
            CLIENT_INSTALL='1'
            ;;
        '-rm' | '--remove')
            CLIENT_REMOVE='1'
            ;;
        '-u' | '--update')
            CLIENT_UPDATE='1'
            ;;
        *)
            echo -e "\e[0;32m$0 $1\e[0m: unknown option \e[1;31m$2\e[0m, See: \e[1;34m$0 help\e[0m"
            exit 1
            ;;
        esac
    fi
    [[ "$CLIENT_VERSION" -eq '1' ]] && client_version && local_version
    [[ "$CLIENT_INSTALL" -eq '1' ]] && client_install
    [[ "$CLIENT_REMOVE" -eq '1' ]] && client_remove
    [[ "$CLIENT_UPDATE" -eq '1' ]] && client_update
}

client_version(){
    TMP_FILE="$(mktemp)"
    if ! curl -sS -H "Accept: application/vnd.github.v3+json" -o "$TMP_FILE" 'https://api.github.com/repos/fatedier/frp/releases/latest'; then
        rm "$TMP_FILE"
        error 'Failed to get release list, please check your network.'
    fi
    RELEASE_LATEST="$(sed 'y/,/\n/' "$TMP_FILE" | grep 'tag_name' | awk -F '"' '{print $4}')"
    rm "$TMP_FILE"
    RELEASE_VERSION="v${RELEASE_LATEST#v}"
    info "latest version: \e[1;34m$RELEASE_VERSION\e[0m"
}
local_client_version(){
    if [ ! $(type -P frpc) ]; then
        error 'Frps not installed.'
    else
        FRPC_VERSION=$(frpc -v)
        info "current frpc version: \e[1;33mv$FRPC_VERSION\e[0m"
    fi
}

client_install(){
    client_version
    download_latest_release
    tar -zxf ${DOWNLOAD_FILE}
    mv ${DOWNLOAD_DIR}/frpc /usr/bin/
    if [ ! -d '/etc/frp/' ];then
        mkdir -p /etc/frp/
    fi
    mv ${DOWNLOAD_DIR}/frpc_full.ini /etc/frp/
    mv ${DOWNLOAD_DIR}/frpc.ini /etc/frp/
    mv ${DOWNLOAD_DIR}/systemd/frpc.service /usr/lib/systemd/system/
    systemctl daemon-reload
    info 'Frps installed successfully.'
}

client_remove(){
    if systemctl disable --now frpc.service;then
        rm -rf /usr/lib/systemd/system/frpc.service
        info 'Disable service and remove.'
    fi
    if rm -rf /etc/frp/;then
        info 'remove config file.'
    fi
    info 'Frps removed successfully.'
}

client_update(){
    client_version
    local_client_version
    if [ "$RELEASE_VERSION" != "$FRPC_VERSION" ];then
        if [ -f /usr/lib/systemd/system/frpc.service ];then
            systemctl stop frpc.service
            download_latest_release
            tar -zxvf ${DOWNLOAD_FILE}
            mv -f ${DOWNLOAD_DIR}/frpc /usr/bin/
            systemctl start frpc.service
        fi
    else
        info 'The current version is the latest version'
    fi
    info 'Update Frps succeeded.'
}

