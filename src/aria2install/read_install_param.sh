#!/bin/bash
# 交互式填写配置
read_install_param() {
    read -r -p "Enter your download directory (default:/data/downloads/):" DOWNLOAD_PATH
    if [ -z "$DOWNLOAD_PATH" ]; then DOWNLOAD_PATH='/data/downloads'; fi
    THREAD_NUM=$(cat /proc/cpuinfo | grep 'processor' | wc -l)
    read -r -p "Enter the maximum number of threads per task (default:${THREAD_NUM})" THREAD_NUM
    read -r -p "enable RPC? (default:y)(y/n):" ENABLE_RPC
    case "$ENABLE_RPC" in
    Y | y | '')
        ENABLE_RPC='true'
        read -r -p "setting RPC port. (default:6800):" RPC_PORT
        if [ -z "$RPC_PORT" ]; then RPC_PORT='6800'; fi
        read -r -p "setting RPC secret. (default:RandomUUID):" RPC_SEC
        if [ -z "$RPC_SEC" ]; then RPC_SEC=$(sed 's/-//g' </proc/sys/kernel/random/uuid); fi
        ;;
    N | n)
        ENABLE_RPC='false'
        ;;
    *)
        echo "Selection failed, please reconfigure!"
        read_install_param
        ;;
    esac
}
