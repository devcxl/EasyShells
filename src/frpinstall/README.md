# 一键安装FRP

## 系统要求

* Centos7+: `curl` , `yum`/`dnf` , `systemd`
* Centos8: `curl` , `yum`/`dnf` , `systemd`
* ArchLinux: `curl` , `pacman` , `systemd`
* Ubuntu18+: `curl` , `apt` , `systemd`
* openSUSE: `curl` , `zypper` , `systemd`

## 使用方式:

```
[frpinstall.sh] Usage: frpinstall.sh <Command> [option]
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
```

## Client [FRPC]

### Install 

`bash <(curl -L https://cdn.jsdelivr.net/gh/devcxl/EasyShells@master/releases/frpinstall.sh) client -i`

### Remove

`bash <(curl -L https://cdn.jsdelivr.net/gh/devcxl/EasyShells@master/releases/frpinstall.sh) client -rm`

### Version

`bash <(curl -L https://cdn.jsdelivr.net/gh/devcxl/EasyShells@master/releases/frpinstall.sh) client -v`


### Upgrade

`bash <(curl -L https://cdn.jsdelivr.net/gh/devcxl/EasyShells@master/releases/frpinstall.sh) client -u`

### Configuration

* `/etc/frp/frpc.ini`
* `/etc/frp/frpc_full.ini`


### Run in background

`sudo systemctl start frpc.service`


## Server [FRPS]


### Install 

`bash <(curl -L https://cdn.jsdelivr.net/gh/devcxl/EasyShells@master/releases/frpinstall.sh) server -i`

### Remove

`bash <(curl -L https://cdn.jsdelivr.net/gh/devcxl/EasyShells@master/releases/frpinstall.sh) server -rm`

### Version

`bash <(curl -L https://cdn.jsdelivr.net/gh/devcxl/EasyShells@master/releases/frpinstall.sh) server -v`


### Upgrade

`bash <(curl -L https://cdn.jsdelivr.net/gh/devcxl/EasyShells@master/releases/frpinstall.sh) server -u`

### Configuration

* `/etc/frp/frps.ini`
* `/etc/frp/frps_full.ini`

### Run in background

`sudo systemctl start frps.service`