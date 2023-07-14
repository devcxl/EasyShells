#!/bin/bash
server(){
    if ! mkdir -p "$DIR";then
        error "Failed to create directory: $DIR . Please check whether you have permission to this directory"
    else
            if ssh-keygen -t rsa -b 4096 -C "server:$SERVER_NAME client:$CLIENT_NAME at $DATE ip:$IP" -f "$DIR/id_rsa_$SERVER_NAME" -N '';then
                
                info "==Successfully generated the private key of $SERVER_NAME for $CLIENT_NAME!=="

                if [[ COPY_FLAG -eq "1" ]]; then
                    if ! ssh-copy-id -f -i "$DIR/id_rsa_$SERVER_NAME.pub" $COPY_2_ADDRESS; then
                        warn "--Copy private key to $SERVER_NAME failed!--"
                    fi
                fi
                

            else
                warn "Failed to generate private key for $SERVER_NAME"
            fi
        info "Success"
    fi
}

