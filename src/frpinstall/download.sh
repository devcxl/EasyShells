#!/bin/bash
# 下载最新版本frp
download_latest_release() {
    VERSION_NUMBER=$(echo "${RELEASE_VERSION}" | sed 's/v//g')
    DOWNLOAD_FILE="frp_${VERSION_NUMBER}_linux_${MACHINE}.tar.gz"
    DOWNLOAD_DIR="frp_${VERSION_NUMBER}_linux_${MACHINE}"
    DOWNLOAD_LINK="https://github.com/fatedier/frp/releases/download/${RELEASE_VERSION}/frp_${VERSION_NUMBER}_linux_${MACHINE}.tar.gz"
    if [ -f "$DOWNLOAD_FILE" ]; then
        info "${DOWNLOAD_FILE} already exists."
    else
        info "Download from ${DOWNLOAD_LINK}."
        if ! wget "$DOWNLOAD_LINK"; then
            error "Failed to download ${DOWNLOAD_LINK}, please check your network"
        fi
    fi
    if [ ! $(type -P tar) ];then
        install_software 'tar'
    fi
    if [ ! $(type -P gzip) ];then
        install_software 'gzip'
    fi
}
