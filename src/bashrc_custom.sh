# Linux Custom Terminal
echo -e "用户：${USER} "
date "+%Y年%B%d日%A %T"
free -h | awk 'NR==2{printf "内存使用: %s/%sMB (%.2f%%)\n", $3,$2,$3*100/$2 }'
df -h | awk '$NF=="/"{printf "磁盘使用: %d/%dGB (%s)\n", $3,$2,$5}'

alias uuid='cat /proc/sys/kernel/random/uuid'
alias uuid-='cat /proc/sys/kernel/random/uuid | sed "s/-//g"'

# deps scrcpy
# https://github.com/Genymobile/scrcpy/wiki/README.zh-Hans
alias scrcpy='scrcpy --push-target /storage/emulated/0/Download/ -m 1080 -b 4M --hid-keyboard --turn-screen-off'

# deps git
alias git-proxy='git config --global http.proxy socks://127.0.0.1:1089'
alias git-unproxy='git config --global --unset https.proxy'
alias git-user='git config user.name'
alias git-mail='git config user.email'

# deps docker
alias redis-server='docker run --rm -it --network host redis:5-alpine redis-server --requirepass 123456'
alias mysql-server='docker run --rm -d --name mysql -e MYSQL_ROOT_PASSWORD=123456 -e MYSQL_DATABASE=test -e TZ=Asia/Shanghai --network host mysql:5.7.31 --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci'

# befor `bash <(curl -L https://cdn.jsdelivr.net/gh/devcxl/EasyShells@master/shell/vscode-update.sh)`
alias code='$HOME/apps/VSCode-linux-x64/bin/code'

# Python export & install deps
alias py-export='pip freeze > requirements.txt'
alias py-install='pip install -r requirements.txt'

alias ll='ls -l'
alias la='ls -a'
alias lla='ls -l -a'