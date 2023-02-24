#!/bin/bash


init(){
    # default hostname
    CLIENT_NAME=$(cat /etc/hostname)
    # default key dir
    DIR="$HOME/.ssh/$CLIENT_NAME"
    # date
    DATE=$(date "+%F %T")
    # your ip address
    IP=$(curl -s ifconfig.me)
}