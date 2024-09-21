#!/bin/bash
# Backup
cp ~/.config/dconf/user ~/.config/dconf/user.bk
cp ~/.config/navicat/Premium/preferences.json ~/.config/navicat/Premium/preferences.json.bk

# Clear data in dconf
dconf reset -f /com/premiumsoft/navicat-premium/
# Remove data fields in config file
sed -i -E 's/,?"([A-Z0-9]+)":\{([^\}]+)},?//g' ~/.config/navicat/Premium/preferences.json