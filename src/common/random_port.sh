#!/bin/bash
random_port(){
    # 生成一个本机随机可用的端口号
    while true; do
    random_port=$((RANDOM % 65536))
    if ! echo "" | nc -w 1 -v localhost $rand >/dev/null 2>&1; then
        return $random_port
    fi
    done
}