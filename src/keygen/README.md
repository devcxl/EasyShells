# 一键生成ssh私钥

## 系统要求

* OpenSSH


## 使用方式


```
[keygen.sh] Usage: keygen.sh <Command> <option>
-h | --help | -help | help      使用帮助
gitee                           为Gitee生成ed25519类型的key
    -c | --client-name          客户端名称(将来使用key的客户端) default: $(cat /etc/hostname)
    -d | --dir                  输出文件夹 default: $HOME/.ssh/$CLIENT_NAME
github                          为Github生成ed25519类型的key
    -c | --client-name          客户端名称(将来使用key的客户端) default: $(cat /etc/hostname)
    -d | --dir                  输出文件夹 default: $HOME/.ssh/$CLIENT_NAME
server                          为服务器生成rsa类型4096长度的key
    -d | --dir                  输出文件夹 default: $HOME/.ssh/$CLIENT_NAME
    -c | --client-name          客户端名称 default: $(cat /etc/hostname)
    -s | --server—name          服务端名称
    -p | --passphrase           私钥口令 default: None
    -C | --copy-id              复制到远程服务器 eg: root@192.168.1.1

```

## 生成Github私钥

`bash <(curl -L https://github.com//devcxl/EasyShells/releases/download/2023-10-01/keygen.sh) github`

## 生成访问服务器的私钥并copy到远程服务器

`bash <(curl -L https://github.com//devcxl/EasyShells/releases/download/2023-10-01/keygen.sh) server -s server_alias_name -C user@192.168.1.1`