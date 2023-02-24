# Aria2安装脚本

系统要求
* Centos7+: `curl` , `yum`/`dnf` , `systemd`
* Centos8: `curl` , `yum`/`dnf` , `systemd`
* ArchLinux: `curl` , `pacman` , `systemd`
* Ubuntu18+: `curl` , `apt` , `systemd`
* openSUSE: `curl` , `zypper` , `systemd`

> Centos系统将会安装`epel-release`仓库

使用方式:

```
[install-release.sh] Usage: install-release.sh Command
help              使用帮助
version           当前安装的Aria2版本信息
remove            卸载Aria2
install           安装Aria2
reconfig          重新配置Aria2
```

安装

`bash <(curl -L https://cdn.jsdelivr.net/gh/devcxl/EasyShells@master/release.sh) install`

卸载

`bash <(curl -L https://cdn.jsdelivr.net/gh/devcxl/Aria2Install@master/release.sh) remove`

