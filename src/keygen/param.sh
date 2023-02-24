#!/bin/bash
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