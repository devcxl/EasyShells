#!/bin/bash
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
