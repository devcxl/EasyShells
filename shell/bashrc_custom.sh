echo -e "用户：${USER} "
date "+%A %d %B %Y, %T"
free | awk 'NR==2{printf "内存使用: %s/%sMB (%.2f%%)\n", $3,$2,$3*100/$2 }'
df -h | awk '$NF=="/"{printf "磁盘使用: %d/%dGB (%s)\n", $3,$2,$5}'
alias uuid='cat /proc/sys/kernel/random/uuid'