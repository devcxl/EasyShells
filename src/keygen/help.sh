#!/bin/bash
help() {
cat <<EOF
[#name#] Usage: #name# <Command> <option>
-h | --help | -help | help      使用帮助
github                          为Github生成ed25519类型的key
    -c | --client-name          客户端名称(将来使用key的客户端) default: $(cat /etc/hostname)
    -d | --dir                  输出文件夹 default: $HOME/.ssh/$CLIENT_NAME
gitee                           为Gitee生成ed25519类型的key
    -c | --client-name          客户端名称(将来使用key的客户端) default: $(cat /etc/hostname)
    -d | --dir                  输出文件夹 default: $HOME/.ssh/$CLIENT_NAME
server                          为服务器生成rsa类型4096长度的key
    -d | --dir                  输出文件夹 default: $HOME/.ssh/$CLIENT_NAME
    -c | --client-name          客户端名称 default: $(cat /etc/hostname)
    -s | --server—name          服务端名称
    -p | --passphrase           私钥口令 default: None
    -C | --copy-id              复制到远程服务器 eg: root@192.168.1.1
EOF
}