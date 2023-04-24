#!/bin/bash
param_parse(){
    while [[ "$#" -gt '0' ]]; do
        case $1 in
        'relay')
            RELAY='1'
            ;;
        'direct')
            DIRECT='1'
            ;;
        '-h' | '--help' | '-help' | 'help')
            HELP='1'
            ;;
        '-p' | '--in-port')
            IN_PORT="${2:?error: IN_PORT error.}"
            shift
            ;;
        '-uid' | '--in-uuid')
            IN_UUID="${2:?error: IN_UUID error.}"
            shift
            ;;
        '-path' | '--in-websocket-path')
            IN_WS_PATH="${2:?error: IN_WS_PATH error.}"
            shift
            ;;
        '-D' | '--out-domain')
            OUT_DOMAIN="${2:?error: OUT_DOMAIN error.}"
            shift
            ;;
        '-P' | '--out-port')
            OUT_PORT="${2:?error: OUT_PORT error.}"
            shift
            ;;
        '-UID' | '--out-uuid' )
            OUT_UUID="${2:?error: OUT_UUID error.}"
            shift
            ;;
        '-PATH' | '--out-websocket-path' )
            OUT_WS_PATH="${2:?error: OUT_WS_PATH error.}"
            shift
            ;;
        '-d' | '--domain'  )
            SERVER_DOMAIN="${2:?error: SERVER_DOMAIN error.}"
            shift
            ;;
        '-t' | '--tls' )
            TLS_FLAG=1
            shift
            ;;
        *)
            error "$0: unknown option $1"
            ;;
        esac
        shift
    done
}