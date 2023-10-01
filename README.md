# EasyShell

EasyShells, 旨在更方便的使用Linux系统，简化复杂操作

> 一个脚本能搞定的事，为什么还要敲那么多命令？


## 目录

* [一键安装配置Aria2](src/aria2install)
* [一键安装配置FRP](src/frpinstall)
* [一键生成ssh私钥](src/keygen)
* [一键安装配置代理](src/v2rayinstall)
* [一键安装/更新VsCode](/src/vscode-update)

* [Ububtu下安装docker脚本](/src/ubuntu-install-docker.sh)
* [Ububtu下以ppa源安装Vscode脚本](/src/ubuntu-install-vscode-ppa.sh)
* [解析yaml文件的脚本](/src/parse_yaml.sh)
* [Termux初始化脚本](/src/termux_init.sh)


## merge

这个脚本主要功能就是将脚本项目中由`#deps:`标注依赖的脚本与`main.sh`合并为一个release脚本。

用来减少不必要的工作量，优化脚本编写体验，就像Python的导包一样，非常舒服。


以下是一些示例：

* 合并frpinstall并输出到releases目录
    
    `bash merge -d frpinstall -release frpinstall`

* 合并keygen并运行'keygen server -C root@192.168.1.1'

    `bash merge -d keygen -r 'server -C root@192.168.1.1'`