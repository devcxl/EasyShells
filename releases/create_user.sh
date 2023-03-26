#!/bin/bash
# 以root身份执行
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# 提示输入新用户名
read -p "Enter username: " username

# 创建新用户并设置密码
adduser $username
passwd $username

# 将新用户添加到sudoers组
usermod -aG sudo $username

# 提示是否要为新用户配置NOPASSWD sudo权限
read -p "Do you want to configure NOPASSWD sudo for this user? (y/n) " configure_sudo

if [[ $configure_sudo =~ ^[Yy]$ ]]
then
    # 在文件末尾添加NOPASSWD sudo配置
    echo "$username  ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
fi
echo "New user created successfully."