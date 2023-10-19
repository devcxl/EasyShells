#!/bin/bash
#deps:common/color.sh
#deps:common/check_if_running_as_root.sh
#deps:common/identify_the_operating_system_and_architecture.sh
#deps:certbot-auto/param_parse.sh
#deps:certbot-auto/install_certbot.sh
#deps:certbot-auto/generaor_nginx_conf.sh
#deps:certbot-auto/generator_ssl_cert.sh

main() {

    check_if_running_as_root

    identify_the_operating_system_and_architecture

    param_parse "$@"

    install_certbot

    generaor_nginx_conf

    generator_ssl_cert

}

main "$@"
