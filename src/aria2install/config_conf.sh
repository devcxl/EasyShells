#!/bin/bash
config_conf() {
  CONFIG_PATH='/etc/aria2/aria2.conf'
  # 下载路径
  sed -i "s#^dir=.*#dir=$DOWNLOAD_PATH#g" $CONFIG_PATH
  # 启用RPC
  sed -i "s#^enable-rpc=.*#enable-rpc=$ENABLE_RPC#g" $CONFIG_PATH
  # RPC端口
  sed -i "s#^rpc-listen-port=.*#rpc-listen-port=$RPC_PORT#g" $CONFIG_PATH
  # RPC密钥
  sed -i "s#^rpc-secret=.*#rpc-secret=$RPC_SEC#g" $CONFIG_PATH

  echo "=> Configuration succeeded! (${CONFIG_PATH})"
  echo "=> RPC Token:"
  echo "=> $RPC_SEC"
}
