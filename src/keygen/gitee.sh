#!/bin/bash
gitee(){
    if ssh-keygen -t ed25519 -C "gitee key client:$CLIENT_NAME at $DATE ip:$IP " -f "$DIR/id_ed25519_gitee" -N '';then
        info "==Successfully generated the private key of Gitee for $CLIENT_NAME!=="
        cat "$DIR/id_ed25519_gitee.pub"
        info "==[https://gitee.com/profile/sshkeys]=="
    else
        error "Failed to generate Gitee private key." 
    fi
}