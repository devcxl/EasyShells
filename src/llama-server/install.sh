#!/bin/bash
useradd -s /sbin/nologin -m -d /var/apps/llama-server/ llama-server
export SECRET_KEY=$(openssl rand -base64 36)
echo "Your secret key is sk-${SECRET_KEY}"
cat > /etc/systemd/system/llama-server.service <<EOF
[Unit]
Description=llama-server

[Service]
Type=simple
WorkingDirectory=/var/apps/llama-server
ExecStart=/var/apps/llama-server/server -t 4 -m models/qwen1_5-4b-chat-q4_k_m.gguf -c 4096 -a qwen1.5-4b-chat --host 0.0.0.0 --port 8019 --api-key sk-${SECRET_KEY} 
User=llama-server
Group=llama-server

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl start llama-server
systemctl status llama-server

