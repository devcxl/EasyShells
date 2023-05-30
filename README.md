# EasyShell

EasyShells, 旨在更方便的使用Linux系统，简化复杂操作

> 一个脚本能搞定的事，为什么还要敲那么多命令？

CDN: `https://cdn.jsdelivr.net/gh/devcxl/EasyShells@master/`

## 目录

* [安装Aria2](src/aria2install)
* [安装/更新VsCode](/releases/vscode-update.sh)
* [生成ssh私钥](releases/keygen.sh)
* [安装FRP](releases/frpinstall.sh)

* [Ububtu下安装docker脚本](/src/ubuntu-install-docker.sh)
* [Ububtu下以ppa源安装Vscode脚本](/src/ubuntu-install-vscode-ppa.sh)
* [解析yaml文件的脚本](/src/parse_yaml.sh)
* [Termux初始化脚本](/src/termux_init.sh)


## merge 示例

* 合并frpinstall并输出到releases目录
    
    `bash merge -d frpinstall -release frpinstall`

* 合并keygen并运行'keygen server -C root@192.168.1.1'

    `bash merge -d keygen -r 'server -C root@192.168.1.1'`