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
check_if_running_as_root() {
    # If you want to run as another user, please modify $UID to be owned by this user
    if [[ "$UID" -ne '0' ]]; then
        echo "WARNING: The user currently executing this script is not root. You may encounter the insufficient privilege error."
        read -r -p "Are you sure you want to continue? [y/n] " cont_without_been_root
        if [[ "${cont_without_been_root:0:1}" = 'y' ]]; then
            echo "Continuing the installation with current user..."
        else
            echo "Not running with root, exiting..."
            exit 1
        fi
    fi
}
# 检查系统架构与包管理器
identify_the_operating_system_and_architecture() {
    if [[ "$(uname)" == 'Linux' ]]; then
        case "$(uname -m)" in
        'i386' | 'i686')
            MACHINE='386'
            ;;
        'amd64' | 'x86_64')
            MACHINE='amd64'
            ;;
        'armv5tel' | 'armv6l' | 'armv7' | 'armv7l')
            MACHINE='arm'
            ;;
        'armv8' | 'aarch64')
            MACHINE='arm64'
            ;;
        'mips')
            MACHINE='mips32'
            ;;
        'mipsle')
            MACHINE='mips32le'
            ;;
        'mips64')
            MACHINE='mips64'
            ;;
        'mips64le')
            MACHINE='mips64le'
            ;;
        *)
            error "The architecture is not supported."
            ;;
        esac
        if [[ ! -f '/etc/os-release' ]]; then
            error "Don't use outdated Linux distributions."
        fi
        if [[ -d /run/systemd/system ]] || grep -q systemd <(ls -l /sbin/init); then
            true
        else
            error "Only Linux distributions using systemd are supported."
        fi
        if [[ "$(type -P apt)" ]]; then
            PACKAGE_MANAGEMENT_INSTALL='apt -y --no-install-recommends install'
            PACKAGE_MANAGEMENT_REMOVE='apt purge'
        elif [[ "$(type -P dnf)" ]]; then
            PACKAGE_MANAGEMENT_INSTALL='dnf -y install'
            PACKAGE_MANAGEMENT_REMOVE='dnf remove'
            EPEL_FLAG='1'
        elif [[ "$(type -P yum)" ]]; then
            PACKAGE_MANAGEMENT_INSTALL='yum -y install'
            PACKAGE_MANAGEMENT_REMOVE='yum remove'
            EPEL_FLAG='1'
        elif [[ "$(type -P zypper)" ]]; then
            PACKAGE_MANAGEMENT_INSTALL='zypper install -y --no-recommends'
            PACKAGE_MANAGEMENT_REMOVE='zypper remove'
        elif [[ "$(type -P pacman)" ]]; then
            PACKAGE_MANAGEMENT_INSTALL='pacman -Syu --noconfirm'
            PACKAGE_MANAGEMENT_REMOVE='pacman -Rsn'
        else
            error "The script does not support the package manager in this operating system."
        fi
    else
        error "This operating system is not supported."
    fi
}
# 使用系统包管理器安装软件
install_software() {
    package_name="$1"
    if ${PACKAGE_MANAGEMENT_INSTALL} "$package_name"; then
        info "$package_name is installed."
    else
        error "Installation of $package_name failed, please check your network."
    fi
}
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
help() {
    sed "s/%name%/$0/g" <<EOF
[%name%] Usage: %name% <Command> <option>
help                    使用帮助
server                  FRPS相关option:
    -i  --install       安装FRPS服务
    -rm --remove        卸载FRPS服务
    -v  --version       FRPS最新版本 / FRPS本地版本 信息
    -u  --update        更新FRPS至最新版本
client                  FRPC相关option:
    -i  --install       安装FRPC服务
    -rm --remove        卸载FRPC服务
    -v  --version       FRPC最新版本 / FRPC本地版本 信息
    -u  --update        更新FRPC至最新版本
EOF
}
#deps:common/color.sh
#deps:frpinstall/check_if_running_as_root.sh
#deps:frpinstall/identify_the_operating_system_and_architecture.sh
#deps:frpinstall/download.sh
#deps:frpinstall/client.sh
#deps:frpinstall/server.sh
#deps:frpinstall/help.sh
main() {
    # 检查root权限
    check_if_running_as_root
    # 检查系统架构以及包管理器
    identify_the_operating_system_and_architecture
    # 接收参数
    if [[ "$#" -gt '0' ]]; then
        case "$1" in
        'server')
            SERVER='1'
            ;;
        'client')
            CLIENT='1'
            ;;
        '-h' | '--help' | 'help')
            HELP='1'
            ;;
        *)
            echo -e "\e[0;32m$0\e[0m: unknown command \e[1;31m$1\e[0m, See: \e[1;34m$0 help\e[0m"
            exit 1
            ;;
        esac
    else
        echo -e "\e[0;32m$0\e[0m: See: \e[1;34m$0 help\e[0m"
    fi
    [[ "$SERVER" -eq '1' ]] && server "$@"
    [[ "$CLIENT" -eq '1' ]] && client "$@"
    [[ "$HELP" -eq '1' ]] && help
}
main "$@"
