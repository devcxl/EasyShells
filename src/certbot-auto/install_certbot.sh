#!/bin/bash
install_certbot(){

    if command -v python3 &>/dev/null; then
        info "$(python3 -V)"
    else
        error "Python3 not insalled."
    fi
    
    if [[ "$(type -P apt)" ]]; then
        install_software python3-venv
        install_software libaugeas0 
    elif [[ "$(type -P dnf)" ]]; then
        install_software augeas-libs
    fi

    if python3 -m venv /opt/certbot/; then
        if /opt/certbot/bin/pip install --upgrade pip; then
            info 'pip upgrade successful!'
        else
            warn 'pip upgrade failed!'
        fi
        if /opt/certbot/bin/pip install certbot certbot; then
            if ln -s /opt/certbot/bin/certbot /usr/local/bin/certbot; then
                info 'certbot install successful'
            fi
        fi
    else
        error 'venv create failed!'
    fi

}