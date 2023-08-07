#!/bin/bash
#deps:common/color.sh
#deps:common/check_if_running_as_root.sh
#deps:common/identify_the_operating_system_and_architecture.sh

main() {
    install_software python3
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
            info 'certbot install successful'
            if ln -s /opt/certbot/bin/certbot /usr/bin/certbot; then
                if certbot register --agree-tos -m $EMAIL; then
                    info "$EMAIL register successful!"
                    if certbot certonly --webroot --webroot-path /usr/share/nginx/html -d $SERVER_DOMAIN; then
                        info "$SERVER_DOMAIN tls installed!"
                    fi
                fi
            fi
        fi
    else
        error 'venv create failed!'
    fi

}

main "$@"