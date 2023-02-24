#!/bin/bash
remove(){
  systemctl disable --now aria2c.service
  rm -rf /etc/aria2/
  rm -rf /var/log/aria2/
  rm -rf /usr/lib/systemd/system/aria2c.service
  if ${PACKAGE_MANAGEMENT_REMOVE} "aria2";then
    echo "info: aria2 is removed."
  else
    echo "error: remove aria2 failed please check you package management."
  fi
  echo "Aria2 has been removed. Please delete the download directory manually (path:/data/download)"
}
