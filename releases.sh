#!/bin/bash
lightgreen='\e[1;32m'
NC='\e[0m'
bold=$(tput bold)
normal=$(tput sgr0)
info() {
    echo -e "${lightgreen}info:${NC} ${bold}$1${normal}"
}

# 生成列表并存储在变量中
releases_list=(
    "aria2install"
    "frpinstall"
    "keygen"
    "v2rayinstall"
    "vscode-update"
    )

# 使用for循环遍历列表中的元素
for file in "${releases_list[@]}"; do
    bash merge -d $file -release $file
    info "release [$file] successful."
done
