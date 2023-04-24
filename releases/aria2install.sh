#!/bin/bash
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
# 根据参数选择命令标记
judgment_parameters() {
  while [[ "$#" -gt '0' ]]; do
    case "$1" in
    'install')
      INSTALL='1'
      break
      ;;
    'remove')
      REMOVE='1'
      break
      ;;
    'reconfig')
      RECONFIG='1'
      break
      ;;
    'version')
      VERSION='1'
      break
      ;;
    'help')
      HELP='1'
      break
      ;;
    *)
      echo "$0: unknown option -- -, See: $0 help"
      exit 1
      ;;
    esac
    shift
  done
}
# 交互式填写配置
read_install_param() {
    read -r -p "Enter your download directory (default:/data/downloads/):" DOWNLOAD_PATH
    if [ -z "$DOWNLOAD_PATH" ]; then DOWNLOAD_PATH='/data/downloads'; fi
    THREAD_NUM=$(cat /proc/cpuinfo | grep 'processor' | wc -l)
    read -r -p "Enter the maximum number of threads per task (default:${THREAD_NUM})" THREAD_NUM
    read -r -p "enable RPC? (default:y)(y/n):" ENABLE_RPC
    case "$ENABLE_RPC" in
    Y | y | '')
        ENABLE_RPC='true'
        read -r -p "setting RPC port. (default:6800):" RPC_PORT
        if [ -z "$RPC_PORT" ]; then RPC_PORT='6800'; fi
        read -r -p "setting RPC secret. (default:RandomUUID):" RPC_SEC
        if [ -z "$RPC_SEC" ]; then RPC_SEC=$(sed 's/-//g' </proc/sys/kernel/random/uuid); fi
        ;;
    N | n)
        ENABLE_RPC='false'
        ;;
    *)
        echo "Selection failed, please reconfigure!"
        read_install_param
        ;;
    esac
}
config_conf() {
  CONFIG_PATH='/etc/aria2/aria2.conf'
  # 下载路径
  sed -i "s#^dir=.*#dir=$DOWNLOAD_PATH#g" $CONFIG_PATH
  # 启用RPC
  sed -i "s#^enable-rpc=.*#enable-rpc=$ENABLE_RPC#g" $CONFIG_PATH
  # RPC端口
  sed -i "s#^rpc-listen-port=.*#rpc-listen-port=$RPC_PORT#g" $CONFIG_PATH
  # RPC密钥
  sed -i "s#^rpc-secret=.*#rpc-secret=$RPC_SEC#g" $CONFIG_PATH
  echo "=> Configuration succeeded! (${CONFIG_PATH})"
  echo "=> RPC Token:"
  echo "=> $RPC_SEC"
}
install() {
  if [ -f /usr/lib/systemd/system/aria2c.service ];then systemctl disable --now aria2c.service;fi
  [[ "$EPEL_FLAG" -eq '1' ]] && install_software 'epel-release'
  install_software 'aria2'
  install_aria2_service
  install_aria2_conf
  read_install_param
  install_file
  config_conf
  systemctl daemon-reload && systemctl enable --now aria2c.service
  echo "Aria2 installation completed!"
}
install_file() {
  if [ ! -d /var/log/aria2/ ]; then
    mkdir -p /var/log/aria2/
  fi
  echo "" > /var/log/aria2/aria2.log
  echo "" > /var/log/aria2/aria2.session
  if [ ! -d "$DOWNLOAD_PATH" ]; then
    mkdir -p "$DOWNLOAD_PATH"
  else
    chmod 777 "$DOWNLOAD_PATH"
  fi
}
install_aria2_service() {
  if [ ! -f /usr/lib/systemd/system/aria2c.service ]; then
    cat > /usr/lib/systemd/system/aria2c.service <<EOF
[Unit]
Description=Aria2 Service
Documentation=https://aria2.github.io/
After=network-online.target
[Service]
Type=forking
ExecStart=/usr/bin/aria2c --conf-path=/etc/aria2/aria2.conf
[Install]
WantedBy=multi-user.target
EOF
  fi
}
install_aria2_conf() {
  if [ ! -d /etc/aria2/ ]; then
    mkdir -p /etc/aria2/
  fi
  cat > /etc/aria2/aria2.conf <<EOF
# 日志
log-level=warn
log=/var/log/aria2/aria2.log
# 后台运行
# daemon=true
dir=/data/download
input-file=/var/log/aria2/aria2.session
save-session=/var/log/aria2/aria2.session
save-session-interval=30
continue=true
disk-cache=32M
file-allocation=none
user-agent=Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.93 Safari/537.36
disable-ipv6=true
always-resume=true
check-integrity=true
# 最大同时下载任务数,  默认:5
max-concurrent-downloads=10
# 同一服务器连接数, 添加时可指定, 默认:1
max-connection-per-server=16
# 最小文件分片大小, 添加时可指定, 取值范围1M -1024M, 默认:20M
min-split-size=10M
# 单个任务最大线程数, 添加时可指定, 默认:5
split=64
# 整体下载速度限制, 默认:0
#max-overall-download-limit=0
# 单个任务下载速度限制, 默认:0
#max-download-limit=0
# 整体上传速度限制,  默认:0
#max-overall-upload-limit=0
# 单个任务上传速度限制, 默认:0
#max-upload-limit=0
## RPC设置 ## ====
# 启用RPC, 默认:false
enable-rpc=false
# 允许所有来源, 默认:false
rpc-allow-origin-all=true
# 允许非外部访问, 默认:false
rpc-listen-all=true
# 事件轮询方式, 取值:[epoll, kqueue, port, poll, select], 不同系统默认值不同
#event-poll=select
# RPC监听端口, 端口被占用时可以修改, 默认:6800
rpc-listen-port=6800
# 设置的RPC授权令牌, v1.18.4新增功能, 取代 --rpc-user 和 --rpc-passwd 选项
rpc-secret=123456
# 是否启用 RPC 服务的 SSL/TLS 加密,
# 启用加密后 RPC 服务需要使用 https 或者 wss 协议连接
#rpc-secure=true
# 在 RPC 服务中启用 SSL/TLS 加密时的证书文件,
# 使用 PEM 格式时，您必须通过 --rpc-private-key 指定私钥
#rpc-certificate=/path/to/certificate.pem
# 在 RPC 服务中启用 SSL/TLS 加密时的私钥文件
#rpc-private-key=/path/to/certificate.key
## BT/PT下载相关 ## ============================================================
# 当下载的是一个种子(以.torrent结尾)时, 自动开始BT任务, 默认:true
# follow-torrent=true
# BT监听端口, 当端口被屏蔽时使用, 默认:6881-6999
listen-port=51413
# 单个种子最大连接数, 默认:55
#bt-max-peers=55
# 打开DHT功能, PT需要禁用, 默认:true
enable-dht=false
# 打开IPv6 DHT功能, PT需要禁用
#enable-dht6=false
# DHT网络监听端口, 默认:6881-6999
#dht-listen-port=6881-6999
dht-file-path=/opt/var/aria2/dht.dat
dht-file-path6=/opt/var/aria2/dht6.dat
# 本地节点查找, PT需要禁用, 默认:false
#bt-enable-lpd=false
# 种子交换, PT需要禁用, 默认:true
enable-peer-exchange=false
# 每个种子限速, 对少种的PT很有用, 默认:50K
#bt-request-peer-speed-limit=50K
# 设置 peer id 前缀
peer-id-prefix=-TR2770-
# 当种子的分享率达到这个数时, 自动停止做种, 0为一直做种, 默认:1.0
seed-ratio=0
# 强制保存会话, 即使任务已经完成, 默认:false
# 较新的版本开启后会在任务完成后依然保留.aria2文件
#force-save=false
# BT校验相关, 默认:true
#bt-hash-check-seed=true
# 继续之前的BT任务时, 无需再次校验, 默认:false
bt-seed-unverified=true
# 保存磁力链接元数据为种子文件(.torrent文件), 默认:false
bt-save-metadata=true
bt-max-open-files=16
# Http/FTP 相关
connect-timeout=120
EOF
}
remove(){
  systemctl disable --now aria2c.service
  rm -rf /etc/aria2/
  rm -rf /var/log/aria2/
  rm -rf /usr/lib/systemd/system/aria2c.service
  if ${PACKAGE_MANAGEMENT_REMOVE} "aria2";then
    echo "info: aria2 is removed."
  else
    echo "error: remove aria2 failed please check you package management."
  fi
  echo "Aria2 has been removed. Please delete the download directory manually (path:/data/download)"
}
reconfig(){
    install_aria2_conf
    read_install_param
    config_conf
    if [ $(type -P aria2) ];then
        if [ -f /usr/lib/systemd/system/aria2c.service ];then
            systemctl restart aria2c.service
        else
            echo "aria2c.service not found! Please reinstall Aria2."
        fi
    else
        echo "Aria2 not installed! Please install Aria2."
    fi
}
# 打印帮助信息
help(){
sed "s/%name%/$0/g" <<EOF
[%name%] Usage: %name% Command
help              使用帮助
version           当前安装的Aria2版本信息
remove            卸载Aria2
install           安装Aria2
EOF
}
#deps:common/check_if_running_as_root.sh
#deps:common/identify_the_operating_system_and_architecture.sh
#deps:aria2install/judgment_parameters.sh
#deps:aria2install/read_install_param.sh
#deps:aria2install/config_conf.sh
#deps:aria2install/install.sh
#deps:aria2install/remove.sh
#deps:aria2install/reconfig.sh
#deps:aria2install/help.sh
main() {
    # 检查root权限
    check_if_running_as_root
    # 检查系统架构以及包管理器
    identify_the_operating_system_and_architecture
    # 接收参数
    judgment_parameters "$@"
    [[ "$HELP" -eq '1' ]] && help
    [[ "$VERSION" -eq '1' ]] && version
    [[ "$REMOVE" -eq '1' ]] && remove
    [[ "$INSTALL" -eq '1' ]] && install
    [[ "$RECONFIG" -eq '1' ]] && reconfig
}
version(){
    if [ $(type -P aria2c) ];then
        aria2c --version 
    else
        echo "aria2 not installed"
    fi
}
main "$@"
