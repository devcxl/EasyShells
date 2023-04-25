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
        MACHINE='32'
        ;;
      'amd64' | 'x86_64')
        MACHINE='64'
        ;;
      'armv5tel')
        MACHINE='arm32-v5'
        ;;
      'armv6l')
        MACHINE='arm32-v6'
        grep Features /proc/cpuinfo | grep -qw 'vfp' || MACHINE='arm32-v5'
        ;;
      'armv7' | 'armv7l')
        MACHINE='arm32-v7a'
        grep Features /proc/cpuinfo | grep -qw 'vfp' || MACHINE='arm32-v5'
        ;;
      'armv8' | 'aarch64')
        MACHINE='arm64-v8a'
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
      'ppc64')
        MACHINE='ppc64'
        ;;
      'ppc64le')
        MACHINE='ppc64le'
        ;;
      'riscv64')
        MACHINE='riscv64'
        ;;
      's390x')
        MACHINE='s390x'
        ;;
      *)
        echo "error: The architecture is not supported."
        exit 1
        ;;
    esac
    if [[ ! -f '/etc/os-release' ]]; then
      echo "error: Don't use outdated Linux distributions."
      exit 1
    fi
    if [[ -d /run/systemd/system ]] || grep -q systemd <(ls -l /sbin/init); then
      true
    else
      echo "error: Only Linux distributions using systemd are supported."
      exit 1
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
      echo "error: The script does not support the package manager in this operating system."
      exit 1
    fi
  else
    echo "error: This operating system is not supported."
    exit 1
  fi
}
# 使用系统包管理器安装软件
install_software() {
    package_name="$1"
    if ${PACKAGE_MANAGEMENT_INSTALL} "$package_name"; then
        echo "info: $package_name is installed."
    else
        echo "error: Installation of $package_name failed, please check your network."
        exit 1
    fi
}
V2RAY_CONFIG_PATH='/usr/local/etc/v2ray/config.json'
NGINX_CONFIG_PATH='/etc/nginx/conf.d/v2ray.conf'
param_parse(){
    while [[ "$#" -gt '0' ]]; do
        case $1 in
        'relay')
            RELAY='1'
            ;;
        'direct')
            DIRECT='1'
            ;;
        '-h' | '--help' | '-help' | 'help')
            HELP='1'
            ;;
        '-p' | '--in-port')
            IN_PORT="${2:?error: IN_PORT error.}"
            shift
            ;;
        '-uid' | '--in-uuid')
            IN_UUID="${2:?error: IN_UUID error.}"
            shift
            ;;
        '-path' | '--in-websocket-path')
            IN_WS_PATH="${2:?error: IN_WS_PATH error.}"
            shift
            ;;
        '-D' | '--out-domain')
            OUT_DOMAIN="${2:?error: OUT_DOMAIN error.}"
            shift
            ;;
        '-P' | '--out-port')
            OUT_PORT="${2:?error: OUT_PORT error.}"
            shift
            ;;
        '-UID' | '--out-uuid' )
            OUT_UUID="${2:?error: OUT_UUID error.}"
            shift
            ;;
        '-PATH' | '--out-websocket-path' )
            OUT_WS_PATH="${2:?error: OUT_WS_PATH error.}"
            shift
            ;;
        '-d' | '--domain'  )
            SERVER_DOMAIN="${2:?error: SERVER_DOMAIN error.}"
            shift
            ;;
        '-t' | '--tls' )
            TLS_FLAG=1
            ;;
        *)
            error "$0: unknown option $1"
            ;;
        esac
        shift
    done
}
random_port(){
    # 生成一个本机随机可用的端口号
    while true; do
    random_port=$((RANDOM % 65536))
    if ! echo "" | nc -w 1 -v localhost $rand >/dev/null 2>&1; then
        return $random_port
    fi
    done
}
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
    info "port: $IN_PORT ,uuid: $IN_UUID ,ws-path: /$IN_WS_PATH"
    # warn: v2ray version must > 5
    if  v2ray test -c $V2RAY_CONFIG_PATH ;then
        info 'config.json verify successful.'
        systemctl enable --now v2ray
    fi
    systemctl enable --now nginx
}
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
        IN_WS_PATH=/$(openssl rand -hex 16)
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
        install_software 'python3-venv'
        install_software 'libaugeas0'
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
help() {
cat <<EOF
[v2rayinstall] Usage: v2rayinstall <Command> <option>
-h | --help | -help | help        使用帮助
relay                             为中转服务器安装VMESS+WS类型的代理服务
    -p    | --in-port             中转服务器的端口      default: random_port
    -i    | --in-uuid             中转服务器的UUID账户  default: random_uuid
    -path | --in-websocket-path   中转服务器的WebSocket路径 default: 'openssl rand -hex 16'
    -D    | --out-domain          被中转服务器的域名
    -P    | --out-port            被中转服务器的端口
    -I    | --out-uuid            被中转服务器中可用的UUID
    -PATH | --out-websocket-path  被中转服务器的WebSocket路径
direct                            为直连服务器安装VMESS+WS+TLS类型的代理服务
    -p    | --in-port             直连服务器的端口
    -i    | --in-uuid             直连服务器的UUID default: random_uuid
    -path | --in-websocket-path   中转服务器的WebSocket路径 default: 'openssl rand -hex 16'
    -d    | --domain              直连服务器可用域名 tips: 要求域名解析已经配置
    -t    | --tls                 为域名配置tls
EOF
}
#deps:common/color.sh
#deps:common/check_if_running_as_root.sh
#deps:common/identify_the_operating_system_and_architecture.sh
#deps:v2rayinstall/init.sh
#deps:v2rayinstall/param_parse.sh
#deps:common/random_port.sh
#deps:v2rayinstall/relay.sh
#deps:v2rayinstall/direct.sh
#deps:v2rayinstall/help.sh
main() {
    init
    param_parse "$@"
    # check_if_running_as_root
    identify_the_operating_system_and_architecture
    [[ "$HELP" -eq '1' ]] && help
    [[ "$RELAY" -eq '1' ]] && relay "$@"
    [[ "$DIRECT" -eq '1' ]] && direct "$@"
}
main "$@"
