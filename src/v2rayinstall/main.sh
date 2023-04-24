#deps:common/color.sh
#deps:common/check_if_running_as_root.sh
#deps:common/identify_the_operating_system_and_architecture.sh
#deps:v2rayinstall/init.sh
#deps:v2rayinstall/param_parse.sh
#deps:common/random_port.sh
#deps:v2rayinstall/help.sh

main() {
    init
    param_parse "$@"
    check_if_running_as_root
    identify_the_operating_system_and_architecture

    [[ "$HELP" -eq '1' ]] && help

    [[ "$RELAY" -eq '1' ]] && relay "$@"

}

main "$@"
