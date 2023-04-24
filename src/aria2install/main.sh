#!/bin/bash
#deps:common/check_if_running_as_root.sh
#deps:common/identify_the_operating_system_and_architecture.sh
#deps:aria2install/judgment_parameters.sh
#deps:aria2install/read_install_param.sh
#deps:aria2install/config_conf.sh
#deps:aria2install/install.sh
#deps:aria2install/remove.sh
#deps:aria2install/reconfig.sh
#deps:aria2install/help.sh
main() {
    # 检查root权限
    check_if_running_as_root
    # 检查系统架构以及包管理器
    identify_the_operating_system_and_architecture
    # 接收参数
    judgment_parameters "$@"
    [[ "$HELP" -eq '1' ]] && help
    [[ "$VERSION" -eq '1' ]] && version
    [[ "$REMOVE" -eq '1' ]] && remove
    [[ "$INSTALL" -eq '1' ]] && install
    [[ "$RECONFIG" -eq '1' ]] && reconfig
}

version(){
    if [ $(type -P aria2c) ];then
        aria2c --version 
    else
        echo "aria2 not installed"
    fi
}
main "$@"
