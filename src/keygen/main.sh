#!/bin/bash
#deps:common/color.sh
#deps:keygen/init.sh
#deps:keygen/param.sh
#deps:keygen/github.sh
#deps:keygen/gitee.sh
#deps:keygen/server.sh
#deps:keygen/help.sh
main(){
    init

    param_parse "$@"

    [[ "$HELP" -eq '1' ]] && help
    [[ "$GITHUB" -eq '1' ]] && github "$@"
    [[ "$GITEE" -eq '1' ]] && gitee "$@"
    [[ "$SERVER" -eq '1' ]] && server "$@"
    
}

main "$@"