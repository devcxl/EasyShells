#!/bin/bash
help() {
cat <<EOF
[#name#] Usage: #name# <Command> <option>
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