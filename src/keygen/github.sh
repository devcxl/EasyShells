#!/bin/bash
github(){
    if ssh-keygen -t ed25519 -C "github key client:$CLIENT_NAME at $DATE ip:$IP " -f "$DIR/id_ed25519_github" -N '';then
        info "==Successfully generated the private key of Github for $CLIENT_NAME!=="
        cat "$DIR/id_ed25519_github.pub"
        info "==[https://github.com/settings/ssh/new]=="
    else
        error "Failed to generate Github private key." 
    fi
}