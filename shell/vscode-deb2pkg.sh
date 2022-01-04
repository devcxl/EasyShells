#!/bin/bash
lightgreen='\e[1;32m'
lightred='\e[1;31m'
red='\e[0;31m'
lightblue='\e[1;34m'
NC='\e[0m'
bold=`tput bold`
normal=`tput sgr0`

# 通过curl模拟请求获取最新版本vscode实际下载地址
RE302=$(curl -s 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:95.0) Gecko/20100101 Firefox/95.0' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8' -H 'Accept-Language: zh-CN' -H 'Accept-Encoding: gzip, deflate, br' -H 'DNT: 1' -H 'Connection: keep-alive' -H 'Upgrade-Insecure-Requests: 1' -H 'Sec-Fetch-Dest: document' -H 'Sec-Fetch-Mode: navigate' -H 'Sec-Fetch-Site: none' -H 'Sec-Fetch-User: ?1' -H 'Pragma: no-cache' -H 'Cache-Control: no-cache')
DOWNLOAD_LINK=$(echo $RE302 | grep -Eo "(https?|ftp|file)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|]" | head -1)

info(){
  echo -e "${lightgreen}info:${NC} ${bold}$1${normal}"
}
error(){
  echo -e "${lightred}error:${NC} ${bold}$1${normal}"
  exit 1
}

# 安装vi(可选) 不需要可注释掉
if [ $(type -P vi) ]; then
  pacman -Syu --noconfirm vi
  info 'vi installed.'
fi
# 以下三个依赖为必须
if [ ! $(type -P pkgfile) ]; then
  pacman -Syu --noconfirm pkgfile
  info 'pkgfile installed.'
fi
# addr2line是binutils组件中的一个,此处用来判断binutils是否被安装
if [ ! $(type -P addr2line) ]; then
  pacman -Syu --noconfirm binutils
  info 'binutils installed.'
fi
if [ ! $(type -P fakeroot) ]; then
  pacman -Syu --noconfirm fakeroot
  info 'fakeroot installed.'
fi

info "Donwloading VsCode ... "
if [ -f vscode.deb ];then
  info "vscode.deb is exist."
else
  if ! curl -o "vscode.deb" "$DOWNLOAD_LINK"; then
    "rm" "vscode.deb"
    error 'Download VsCode Failed. Please try again.'
  fi
fi

info "Downloading Debtap ..."
if [ -f debtap ];then
  info "debtap is exist."
else
  if ! curl -s -o debtap "https://cdn.jsdelivr.net/gh/helixarch/debtap@3.4.2/debtap"; then
    "rm" "debtap"
    error 'Download debtap Failed. Please try again.'
  fi
fi

info "Update debtap database..."
bash debtap -u 

info "Convert package...."
if ! bash debtap "vscode.deb";then
  "rm" "vscode.deb"
  error 'Convert deb Failed.'
fi
