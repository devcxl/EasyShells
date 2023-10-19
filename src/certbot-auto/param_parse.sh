#!/bin/bash
param_parse() {
    while [[ "$#" -gt '0' ]]; do
        case $1 in
        '-h' | '--help' | '-help' | 'help')
            HELP='1'
            ;;
        '-e' | '--email')
            EMAIL="${2:?error: email error.}"
            shift
            ;;
        '-d' | '--domain')
            SERVER_DOMAIN="${2:?error: doamin error.}"
            shift
            ;;
        *)
            error "$0: unknown option $1"
            ;;
        esac
        shift
    done

    if [ -z $EMAIL ];then
        error "Missing parameter -e/--email"
    fi

    if [ -z $SERVER_DOMAIN ];then
        error "Missing parameter -d/--domain"
    else
        mkdir -p /tmp/$SERVER_DOMAIN
    fi

}