#!/bin/bash
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
daemon=true
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
