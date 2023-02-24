#!/bin/bash
lightgreen='\e[1;32m'
lightred='\e[1;31m'
red='\e[0;31m'
lightyellow='\e[1;33m'
NC='\e[0m'
bold=`tput bold`
normal=`tput sgr0`
info(){
    echo -e "${lightgreen}info:${NC} ${bold}$1${normal}"
}
error(){
    echo -e "${lightred}error:${NC} ${bold}$1${normal}"
    exit 1
}
warn(){
    echo -e "${lightyellow}warn:${NC} ${bold}$1${normal}"
}
debug(){
    echo -e "${lightyellow}debug:${NC} ${bold}------=========$1=========------${normal}"
}
# 默认安装位置
INSTALL_DIR="$HOME/apps/"
get_download_url(){
    # 通过curl模拟请求获取最新版本vscode实际下载地址
    RE302=$(curl -s 'https://code.visualstudio.com/sha/download?build=stable&os=linux-x64' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:95.0) Gecko/20100101 Firefox/95.0' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8' -H 'Accept-Language: zh-CN' -H 'Accept-Encoding: gzip, deflate, br' -H 'DNT: 1' -H 'Connection: keep-alive' -H 'Upgrade-Insecure-Requests: 1' -H 'Sec-Fetch-Dest: document' -H 'Sec-Fetch-Mode: navigate' -H 'Sec-Fetch-Site: none' -H 'Sec-Fetch-User: ?1' -H 'Pragma: no-cache' -H 'Cache-Control: no-cache')
    DOWNLOAD_LINK=$(echo $RE302 | grep -Eo "(https?|ftp|file)://[-A-Za-z0-9+&@#/%?=~_|\!:,.;]+[-A-Za-z0-9+&@#/%=~_|]" | head -1)
}
download(){
    info "Donwloading VsCode ... $DOWNLOAD_LINK"
    if [ -f /tmp/vscode.tar.gz ];then
        info "vscode.tar.gz is exist."
    else
        if ! curl -o "/tmp/vscode.tar.gz" "$DOWNLOAD_LINK"; then
            rm "/tmp/vscode.tar.gz"
            error 'Download VsCode Failed. Please try again.'
        fi
    fi
}
install(){
    info "Installing VsCode ... $INSTALL_DIR"
    if [ -d $INSTALL_DIR ];then
        if tar -C $INSTALL_DIR -xzvf /tmp/vscode.tar.gz;then
            info "The installation is complete!"
            rm "/tmp/vscode.tar.gz"
        else
            error "Installation failed!"
        fi
    else
        if ! mkdir "$INSTALL_DIR"; then
            info "Directory created successfully!"
            tar -C $INSTALL_DIR -xzvf /tmp/vscode.tar.gz
            info "The installation is complete!"
            rm "/tmp/vscode.tar.gz"
        else
            error "Directory creation failed!"
        fi
    fi
}
#deps:common/color.sh
main(){
    get_download_url
    download
    install
}
# usage: bash <(curl -L https://cdn.jsdelivr.net/gh/devcxl/EasyShells@master/releases/vscode-update.sh)