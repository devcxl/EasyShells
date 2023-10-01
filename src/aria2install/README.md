# 一键安装Aria2

## 系统要求
* Centos7+: `curl` , `yum`/`dnf` , `systemd`
* Centos8: `curl` , `yum`/`dnf` , `systemd`
* ArchLinux: `curl` , `pacman` , `systemd`
* Ubuntu18+: `curl` , `apt` , `systemd`
* openSUSE: `curl` , `zypper` , `systemd`

> Centos系统将会安装`epel-release`仓库

## 使用方式:

```
[aria2install.sh] Usage: aria2install.sh Command
help              使用帮助
version           当前安装的Aria2版本信息
remove            卸载Aria2
install           安装Aria2
```

## 安装

`bash <(curl -L https://github.com//devcxl/EasyShells/releases/download/2023-10-01/aria2install.sh) install`


## 修改配置

configuration path `/etc/aria2/aria2.conf`

## Run in background

`sudo systemctl start aria2c.service`

## 卸载

`bash <(curl -L https://github.com//devcxl/EasyShells/releases/download/2023-10-01/aria2install.sh) remove`


## 相关

* https://github.com/mayswind/AriaNg