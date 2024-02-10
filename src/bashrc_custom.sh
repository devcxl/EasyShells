# Linux Custom Terminal
# Useage: curl -L https://cdn.jsdelivr.net/gh/devcxl/EasyShells@master/src/bashrc_custom.sh >> $HOME/.bashrc
echo -e "用户：${USER} "
date "+%Y年%B%d日%A %T"
free -h | awk 'NR==2{printf "内存使用: %s/%sMB (%.2f%%)\n", $3,$2,$3*100/$2 }'
df -h | awk '$NF=="/"{printf "磁盘使用: %d/%dGB (%s)\n", $3,$2,$5}'

alias uuid='cat /proc/sys/kernel/random/uuid'
alias uuid-='cat /proc/sys/kernel/random/uuid | sed "s/-//g"'


if [ -n "$(command -v Xorg)" ] || [ -n "$(command -v Wayland)" ]; then
    # deps scrcpy
    # https://github.com/Genymobile/scrcpy/wiki/README.zh-Hans
    alias scrcpy='scrcpy --push-target /storage/emulated/0/Download/ -m 1080 -b 4M --hid-keyboard --turn-screen-off'

    # deps docker
    alias redis-server='docker run --rm -d --network host redis:5-alpine redis-server --requirepass 123456'
    alias mysql-server='docker run --rm -d --name mysql -e MYSQL_ROOT_PASSWORD=123456 -e MYSQL_DATABASE=test -e TZ=Asia/Shanghai --network host mysql:5.7.31 --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci'

    # befor `bash <(curl -L https://github.com/devcxl/EasyShells/releases/download/2023-10-18/vscode-update.sh)`
    alias code='$HOME/apps/VSCode-linux-x64/bin/code'

fi


# deps git
alias git-proxy='git config --global http.proxy socks://127.0.0.1:1089'
alias git-unproxy='git config --global --unset https.proxy'
alias git-user='git config user.name'
alias git-mail='git config user.email'

# Python export & install deps
alias py-export='pip freeze > requirements.txt'
alias py-install='pip install -r requirements.txt'

alias ll='ls -l'
alias la='ls -a'
alias lla='ls -l -a'

# Fixing the npm install timeout issue on an IPv6 network.
alias npm="node --dns-result-order=ipv4first $(which npm)"
# Clean up .bash_history file
alias history_norepeat="awk '!seen[$0]++' ~/.bash_history > ~/.bash_history_temp && mv ~/.bash_history_temp ~/.bash_history"
