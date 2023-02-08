#!/bin/bash
lightgreen='\e[1;32m'
lightred='\e[1;31m'
red='\e[0;31m'
lightblue='\e[1;34m'
NC='\e[0m'
bold=`tput bold`
normal=`tput sgr0`

info(){
    echo -e "${lightgreen}info:${NC} ${bold}$1${normal}"
}
warn(){
    echo -e "${lightyellow}warn:${NC} ${bold}$1${normal}"
}
error(){
    echo -e "${lightred}error:${NC} ${bold}$1${normal}"
    exit 1
}
# default hostname
CLIENT_NAME=$(cat /etc/hostname)
DIR="$HOME/.ssh/$CLIENT_NAME"
DATE=$(date "+%F %T")
IP=$(curl ifconfig.me)
if ! mkdir "$DIR";then
    error "Failed to create directory: $DIR . Please check whether you have permission to this directory"
else
    if [[ "$1" == "github" ]];then
        if ssh-keygen -t ed25519 -C "github key client:$CLIENT_NAME at $DATE ip:$IP " -f "$DIR/id_ed25519_github" -N '';then
            cat "$DIR/id_ed25519_github.pub"
        else
            error "Failed to generate Github private key." 
        fi
    else
        for SERVER_NAME in $@;
        do
            if ssh-keygen -t rsa -b 4096 -C "server:$SERVER_NAME client:$CLIENT_NAME at $DATE ip:$IP" -f "$DIR/id_rsa_$SERVER_NAME" -N '';then
                if ! ssh-copy-id -f -i "$DIR/id_rsa_$SERVER_NAME.pub" $SERVER_NAME; then
                    warn "--Copy private key to $SERVER_NAME failed!--"
                fi
                info "==Successfully generated the private key of $SERVER_NAME for $CLIENT_NAME!=="
            else
                warn "Failed to generate private key for $SERVER_NAME"
            fi
        done

        info "Success"
    fi


fi

