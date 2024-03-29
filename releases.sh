#!/bin/bash
lightgreen='\e[1;32m'
NC='\e[0m'
bold=`tput bold`
normal=`tput sgr0`
info(){
    echo -e "${lightgreen}info:${NC} ${bold}$1${normal}"
}

# 生成列表并存储在变量中
file_list=$(ls -d src/*/ | sed 's#src/##g' | sed 's#/##g')

# 使用for循环遍历列表中的元素
for file in $file_list; do
  # 在这里执行你的操作，例如重命名文件
  # 你可以使用$file变量来引用当前的元素
  if [ "$file" != 'common' ]; then
    bash merge -d $file -release $file
    info "release $file successful."
  fi
  # 在这里添加你的操作，例如重命名文件
done
