#!/data/data/com.termux/files/usr/bin/bash
# 换源
termux-change-repo && apt update
# 访问存储
termux-setup-storage
# 安装软件包
pkg install -y termux-api termux-services proot proot-distro tsu openssh git zsh vim python nodejs-lts nginx nmap

# 安装zsh
git clone https://github.com/Cabbagec/termux-ohmyzsh.git "$HOME/termux-ohmyzsh" --depth 1

mv "$HOME/.termux" "$HOME/.termux.bak.$(date +%Y.%m.%d-%H:%M:%S)"

cp -R "$HOME/termux-ohmyzsh/.termux" "$HOME/.termux"

git clone git://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh" --depth 1

mv "$HOME/.zshrc" "$HOME/.zshrc.bak.$(date +%Y.%m.%d-%H:%M:%S)"

cp "$HOME/.oh-my-zsh/templates/zshrc.zsh-template" "$HOME/.zshrc"

sed -i '/^ZSH_THEME/d' "$HOME/.zshrc"

sed -i '1iZSH_THEME="agnoster"' "$HOME/.zshrc"

echo "alias chcolor='$HOME/.termux/colors.sh'" >> "$HOME/.zshrc"
echo "alias chfont='$HOME/.termux/fonts.sh'" >> "$HOME/.zshrc"

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.zsh-syntax-highlighting" --depth 1

echo "source $HOME/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> "$HOME/.zshrc"

chsh -s zsh

echo "Config oh my zsh theme:"
$HOME/.termux/colors.sh

echo "Config oh my zsh fonts:"
$HOME/.termux/fonts.sh

# 配置.zshrc
echo "termux-wake-lock" >> "$HOME/.zshrc"
echo "alias dk='ssh orange@192.168.127.5 bash /home/orange/quick.sh'" >> "$HOME/.zshrc"
echo "alias dk2='ssh orange@192.168.127.5 bash /home/orange/daka.sh'" >> "$HOME/.zshrc"
echo "alias tu='scp orange@192.168.127.5:/home/orange/*.png ~/storage/downloads/'" >> "$HOME/.zshrc"

echo "Please restart Termux app..."
# 开启sshd
sv-enable sshd

termux-reload-settings