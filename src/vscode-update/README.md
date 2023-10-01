# 一键安装/更新VsCode

## 背景

在使用manjaro系统后，我发现VsCode官方并未提供适合manjaro系统的安装包。

但是我又不想使用AUR。因为总感觉使用AUR会出现些奇奇怪怪的问题。(摊手)

原本我以为是需要通过debtap将VsCode提供的适用于Ubunut系统的deb包转换为适用于manjaro的pkg包。

但是我发现VsCode提供了Linux的tar.gz免安装包，于是这个脚本就诞生了。

## 使用方式

`bash <(curl -L https://github.com//devcxl/EasyShells/releases/download/2023-10-01/vscode-update.sh)`


脚本会将最新版本VSCode安装到 `$INSTALL_DIR`目录。（INSTALL_DIR的默认值是：`$HOME/apps/`）

每次更新时只需要关闭VSCode重新运行以上命令就OK