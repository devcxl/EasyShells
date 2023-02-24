#!/bin/bash
reconfig(){
    install_aria2_conf
    read_install_param
    config_conf
    if [ $(type -P aria2) ];then
        if [ -f /usr/lib/systemd/system/aria2c.service ];then
            systemctl restart aria2c.service
        else
            echo "aria2c.service not found! Please reinstall Aria2."
        fi
    else
        echo "Aria2 not installed! Please install Aria2."
    fi
}