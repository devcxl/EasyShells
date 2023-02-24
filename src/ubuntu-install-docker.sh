#!/bin/bash
sudo apt-get update
echo '------安装 apt 依赖包，用于通过HTTPS来获取仓库'
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
echo '------添加 Docker 的官方 GPG 密钥'
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
echo '------设置稳定版仓库'
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) \
  stable"
echo '------安装最新版本的 Docker Engine-Community 和 containerd'
sudo apt-get install docker-ce docker-ce-cli containerd.io
echo '------安装完成'