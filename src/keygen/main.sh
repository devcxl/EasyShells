#!/bin/bash
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