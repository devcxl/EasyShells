#!/bin/bash
lightgreen='\e[1;32m'
lightred='\e[1;31m'
red='\e[0;31m'
lightyellow='\e[1;33m'
NC='\e[0m'
bold=`tput bold`
normal=`tput sgr0`
info(){
    echo -e "${lightgreen}info:${NC} ${bold}$1${normal}"
}
error(){
    echo -e "${lightred}error:${NC} ${bold}$1${normal}"
    exit 1
}
warn(){
    echo -e "${lightyellow}warn:${NC} ${bold}$1${normal}"
}
debug(){
    echo -e "${lightyellow}debug:${NC} ${bold}------=========$1=========------${normal}"
}
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
param_parse(){
    while [[ "$#" -gt '0' ]]; do
        case $1 in
        'github')
            GITHUB='1'
            ;;
        'server')
            SERVER='1'
            ;;
        '-h' | '--help' | '-help' | 'help')
            HELP='1'
            ;;
        '-d' | '--dir')
            DIR="${2:?error: path error.}"
            shift
            ;;
        '-c' | '--client-name')
            CLIENT_NAME="${2:?error: client name error.}"
            shift
            ;;
        '-s' | '--server-name')
            SERVER_NAME="${2:?error: client name error.}"
            shift
            ;;
        '-p' | '--passphrase')
            PASSPHRASE="${2}"
            shift
            ;;
        '-C' | '--copy-id')
            COPY_FLAG=1
            COPY_2_ADDRESS="${2}"
            shift
            ;;
        *)
            error "$0: unknown option $1"
            ;;
        esac
        shift
    done
}
github(){
    if ssh-keygen -t ed25519 -C "github key client:$CLIENT_NAME at $DATE ip:$IP " -f "$DIR/id_ed25519_github" -N '';then
        info "==Successfully generated the private key of Github for $CLIENT_NAME!=="
        cat "$DIR/id_ed25519_github.pub"
        info "==[https://github.com/settings/ssh/new]=="
    else
        error "Failed to generate Github private key." 
    fi
}
server(){
    if ! mkdir "$DIR";then
        error "Failed to create directory: $DIR . Please check whether you have permission to this directory"
    else
            if ssh-keygen -t rsa -b 4096 -C "server:$SERVER_NAME client:$CLIENT_NAME at $DATE ip:$IP" -f "$DIR/id_rsa_$SERVER_NAME" -N '';then
                
                info "==Successfully generated the private key of $SERVER_NAME for $CLIENT_NAME!=="
                if [[ COPY_FLAG -eq "1" ]]; then
                    if ! ssh-copy-id -f -i "$DIR/id_rsa_$SERVER_NAME.pub" $COPY_2_ADDRESS; then
                        warn "--Copy private key to $SERVER_NAME failed!--"
                    fi
                fi
                
            else
                warn "Failed to generate private key for $SERVER_NAME"
            fi
        info "Success"
    fi
}
help() {
cat <<EOF
[keygen] Usage: keygen <Command> <option>
-h | --help | -help | help      使用帮助
github                          为Github生成ed25519类型的key
    -c | --client-name          客户端名称(将来使用key的客户端) default: $(cat /etc/hostname)
    -d | --dir                  输出文件夹 default: $HOME/.ssh/$CLIENT_NAME
server                          为服务器生成rsa类型4096长度的key
    -d | --dir                  输出文件夹 default: $HOME/.ssh/$CLIENT_NAME
    -c | --client-name          客户端名称 default: $(cat /etc/hostname)
    -s | --server—name          服务端名称
    -p | --passphrase           私钥口令 default: None
    -C | --copy-id              复制到远程服务器 eg: root@192.168.1.1
EOF
}
#deps:common/color.sh
#deps:keygen/init.sh
#deps:keygen/param.sh
#deps:keygen/github.sh
#deps:keygen/server.sh
#deps:keygen/help.sh
main(){
    init
    param_parse "$@"
    [[ "$HELP" -eq '1' ]] && help
    [[ "$GITHUB" -eq '1' ]] && github "$@"
    [[ "$SERVER" -eq '1' ]] && server "$@"
    
}
main "$@"