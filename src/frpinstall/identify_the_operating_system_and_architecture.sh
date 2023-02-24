#!/bin/bash
# 检查系统架构与包管理器
identify_the_operating_system_and_architecture() {
    if [[ "$(uname)" == 'Linux' ]]; then
        case "$(uname -m)" in
        'i386' | 'i686')
            MACHINE='386'
            ;;
        'amd64' | 'x86_64')
            MACHINE='amd64'
            ;;
        'armv5tel' | 'armv6l' | 'armv7' | 'armv7l')
            MACHINE='arm'
            ;;
        'armv8' | 'aarch64')
            MACHINE='arm64'
            ;;
        'mips')
            MACHINE='mips32'
            ;;
        'mipsle')
            MACHINE='mips32le'
            ;;
        'mips64')
            MACHINE='mips64'
            ;;
        'mips64le')
            MACHINE='mips64le'
            ;;
        *)
            error "The architecture is not supported."
            ;;
        esac
        if [[ ! -f '/etc/os-release' ]]; then
            error "Don't use outdated Linux distributions."
        fi
        if [[ -d /run/systemd/system ]] || grep -q systemd <(ls -l /sbin/init); then
            true
        else
            error "Only Linux distributions using systemd are supported."
        fi
        if [[ "$(type -P apt)" ]]; then
            PACKAGE_MANAGEMENT_INSTALL='apt -y --no-install-recommends install'
            PACKAGE_MANAGEMENT_REMOVE='apt purge'
        elif [[ "$(type -P dnf)" ]]; then
            PACKAGE_MANAGEMENT_INSTALL='dnf -y install'
            PACKAGE_MANAGEMENT_REMOVE='dnf remove'
            EPEL_FLAG='1'
        elif [[ "$(type -P yum)" ]]; then
            PACKAGE_MANAGEMENT_INSTALL='yum -y install'
            PACKAGE_MANAGEMENT_REMOVE='yum remove'
            EPEL_FLAG='1'
        elif [[ "$(type -P zypper)" ]]; then
            PACKAGE_MANAGEMENT_INSTALL='zypper install -y --no-recommends'
            PACKAGE_MANAGEMENT_REMOVE='zypper remove'
        elif [[ "$(type -P pacman)" ]]; then
            PACKAGE_MANAGEMENT_INSTALL='pacman -Syu --noconfirm'
            PACKAGE_MANAGEMENT_REMOVE='pacman -Rsn'
        else
            error "The script does not support the package manager in this operating system."
        fi
    else
        error "This operating system is not supported."
    fi
}
# 使用系统包管理器安装软件
install_software() {
    package_name="$1"
    if ${PACKAGE_MANAGEMENT_INSTALL} "$package_name"; then
        info "$package_name is installed."
    else
        error "Installation of $package_name failed, please check your network."
    fi
}
