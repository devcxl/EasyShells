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