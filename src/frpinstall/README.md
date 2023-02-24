# frp一键安装脚本

系统要求

* Centos7+: `curl` , `yum`/`dnf` , `systemd`
* Centos8: `curl` , `yum`/`dnf` , `systemd`
* ArchLinux: `curl` , `pacman` , `systemd`
* Ubuntu18+: `curl` , `apt` , `systemd`
* openSUSE: `curl` , `zypper` , `systemd`

使用方式:

```
[release.sh] Usage: release.sh <Command> [option]
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