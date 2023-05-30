# 一键安装配置v2ray

## 介绍

一键安装配置V2ray，自动配置中转服务和直连服务。

* relay 方式安装 VMESS+WS 类型的代理服务作为中转服务器。要求先有要被中转的v2ray服务。被中转的v2ray服务必须符合 VMESS+WS+TLS


* direct 方式安装 VMESS+WS+TLS 类型的代理服务作为直连服务器。要求域名已经解析到直连服务器的ip。

> 一般可以先使用 direct 安装直连服务器，再通过 relay 中转直连服务器

## 使用方式
```
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
```


## 生成的配置

v2ray配置：`/usr/local/etc/v2ray/config.json`

Nginx配置：`/etc/nginx/conf.d/v2ray.conf`