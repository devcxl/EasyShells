#!/bin/bash
#deps:common/color.sh
#deps:frpinstall/check_if_running_as_root.sh
#deps:frpinstall/identify_the_operating_system_and_architecture.sh
#deps:frpinstall/download.sh
#deps:frpinstall/client.sh
#deps:frpinstall/server.sh
#deps:frpinstall/help.sh
main() {
    # 检查root权限
    check_if_running_as_root
    # 检查系统架构以及包管理器
    identify_the_operating_system_and_architecture
    # 接收参数
    if [[ "$#" -gt '0' ]]; then
        case "$1" in
        'server')
            SERVER='1'
            ;;
        'client')
            CLIENT='1'
            ;;
        '-h' | '--help' | 'help')
            HELP='1'
            ;;
        *)
            echo -e "\e[0;32m$0\e[0m: unknown command \e[1;31m$1\e[0m, See: \e[1;34m$0 help\e[0m"
            exit 1
            ;;
        esac
    else
        echo -e "\e[0;32m$0\e[0m: See: \e[1;34m$0 help\e[0m"
    fi
    [[ "$SERVER" -eq '1' ]] && server "$@"
    [[ "$CLIENT" -eq '1' ]] && client "$@"
    [[ "$HELP" -eq '1' ]] && help
}

main "$@"
