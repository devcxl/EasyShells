#!/bin/bash
# 打印帮助信息
help(){
sed "s/%name%/$0/g" <<EOF
[%name%] Usage: %name% Command
help              使用帮助
version           当前安装的Aria2版本信息
remove            卸载Aria2
install           安装Aria2
EOF
}
