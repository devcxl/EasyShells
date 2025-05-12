sudo mkdir /etc/systemd/system/docker.service.d

sudo cat > /etc/systemd/system/docker.service.d/http-proxy.conf << 'EOF'
[Service]
Environment="HTTP_PROXY=http://192.168.31.128:8087/"
Environment="HTTPS_PROXY=http://192.168.31.128:8087/"
Environment="NO_PROXY=localhost,127.0.0.1,.aliyuncs.com"
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker.service