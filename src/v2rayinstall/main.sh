#deps:common/color.sh
#deps:common/check_if_running_as_root.sh
#deps:common/identify_the_operating_system_and_architecture.sh
#deps:v2rayinstall/param_parse.sh
#deps:v2rayinstall/help.sh

main() {
    param_parse "$@"

    [[ "$HELP" -eq '1' ]] && help

}

main "$@"
