#!/bin/bash
server(){
    if [[ "$#" -gt '1' ]]; then
        case "$2" in
        '-v' | '--version')
            SERVER_VERSION='1'
            ;;
        '-i' | '--install')
            SERVER_INSTALL='1'
            ;;
        '-rm' | '--remove')
            SERVER_REMOVE='1'
            ;;
        '-u' | '--update')
            SERVER_UPDATE='1'
            ;;
        *)
            echo -e "\e[0;32m$0 $1\e[0m: unknown option \e[1;31m$2\e[0m, See: \e[1;34m$0 help\e[0m"
            exit 1
            ;;
        esac
    fi
    [[ "$SERVER_VERSION" -eq '1' ]] && server_version && local_version
    [[ "$SERVER_INSTALL" -eq '1' ]] && server_install
    [[ "$SERVER_REMOVE" -eq '1' ]] && server_remove
    [[ "$SERVER_UPDATE" -eq '1' ]] && server_update
}

server_version(){
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
local_server_version(){
    if [ ! $(type -P frps) ]; then
        error 'Frps not installed.'
    else
        FRPS_VERSION=$(frps -v)
        info "current frps version: \e[1;33mv$FRPS_VERSION\e[0m"
    fi
}

server_install(){
    server_version
    download_latest_release
    tar -zxf ${DOWNLOAD_FILE}
    mv ${DOWNLOAD_DIR}/frps /usr/bin/
    if [ ! -d '/etc/frp/' ];then
        mkdir -p /etc/frp/
    fi
    mv ${DOWNLOAD_DIR}/frps_full.ini /etc/frp/
    mv ${DOWNLOAD_DIR}/frps.ini /etc/frp/
    mv ${DOWNLOAD_DIR}/systemd/frps.service /usr/lib/systemd/system/
    systemctl daemon-reload
    info 'Frps installed successfully.'
}

server_remove(){
    if systemctl disable --now frps.service;then
        rm -rf /usr/lib/systemd/system/frps.service
        info 'Disable service and remove.'
    fi
    if rm -rf /etc/frp/;then
        info 'remove config file.'
    fi
    info 'Frps removed successfully.'
}

server_update(){
    server_version
    local_server_version
    if [ -f /usr/lib/systemd/system/frps.service ];then
        systemctl stop frps.service
        download_latest_release
        tar -zxvf ${DOWNLOAD_FILE}
        mv -f ${DOWNLOAD_DIR}/frps /usr/bin/
        systemctl start frps.service
    fi
    info 'Update Frps succeeded.'
}

