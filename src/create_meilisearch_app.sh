#/bin/bash
useradd -d /var/apps/meilisearch -b /bin/false -m -r meilisearch

# create dir and give permission

mkdir -p /var/apps/meilisearch/data /var/apps/meilisearch/dumps /var/apps/meilisearch/snapshots
chown -R meilisearch:meilisearch /var/apps/meilisearch
chmod 750 /var/apps/meilisearch

mkdir -p /etc/meilisearch/
chown -R meilisearch:meilisearch /etc/meilisearch/
chmod 750 /etc/meilisearch/

# 添加systemd配置文件
cat << EOF > /etc/systemd/system/meilisearch.service
[Unit]
Description=Meilisearch
After=systemd-user-sessions.service

[Service]
Type=simple
WorkingDirectory=/var/apps/meilisearch
ExecStart=/usr/local/bin/meilisearch --config-file-path /etc/meilisearch/config.toml
User=meilisearch
Group=meilisearch

[Install]
WantedBy=multi-user.target
EOF


# 添加配置文件
cat << EOF > /etc/meilisearch/config.toml
# 该文件展示了Meilisearch的默认配置。
# 所有变量在这里定义: https://www.meilisearch.com/docs/learn/configuration/instance_options#environment-variables

# 指定数据库文件将被创建和检索的位置。
# https://www.meilisearch.com/docs/learn/configuration/instance_options#database-path
db_path = "/var/apps/meilisearch/data"

# 配置实例的环境。值必须是production或development。
# https://www.meilisearch.com/docs/learn/configuration/instance_options#environment
env = "development"

# HTTP服务器将监听的地址。
http_addr = "127.0.0.1:7700"

# 设置实例的主密钥，自动保护除GET /health之外的所有路由。
# https://www.meilisearch.com/docs/learn/configuration/instance_options#master-key
master_key = "YOUR_MASTER_KEY_VALUE"

# 提供时禁用Meilisearch内置的遥测功能。
# Meilisearch会自动从未选择退出的所有实例收集数据。
# 所有收集的数据仅用于改进Meilisearch，可以随时删除。
# https://www.meilisearch.com/docs/learn/configuration/instance_options#disable-analytics
no_analytics = true

# 设置接受负载的最大大小。
# https://www.meilisearch.com/docs/learn/configuration/instance_options#payload-limit-size
http_payload_size_limit = "100 MB"

# 定义Meilisearch日志中应包含多少详细信息。
# Meilisearch当前支持六个日志级别，按增加的冗余顺序列出: OFF、ERROR、WARN、INFO、DEBUG、TRACE
# https://www.meilisearch.com/docs/learn/configuration/instance_options#log-level
log_level = "INFO"

# 设置Meilisearch在索引时可以使用的最大内存量。
# https://www.meilisearch.com/docs/learn/configuration/instance_options#max-indexing-memory
max_indexing_memory = "1 GiB"

# 设置Meilisearch在索引时可以使用的最大线程数。
# https://www.meilisearch.com/docs/learn/configuration/instance_options#max-indexing-threads
max_indexing_threads = 4

#############
### DUMPS ###
#############

# 设置Meilisearch将创建转储文件的目录。
# https://www.meilisearch.com/docs/learn/configuration/instance_options#dump-directory
dump_dir = "/var/apps/meilisearch/dumps"

# 导入指定路径处的转储文件。路径必须指向.dump文件。
# https://www.meilisearch.com/docs/learn/configuration/instance_options#import-dump
# import_dump = "./path/to/my/file.dump"

# 当import_dump不指向有效的转储文件时，防止Meilisearch引发错误。
# https://www.meilisearch.com/docs/learn/configuration/instance_options#ignore-missing-dump
ignore_missing_dump = false

# 当使用import_dump时，防止具有现有数据库的Meilisearch实例引发错误。
# https://www.meilisearch.com/docs/learn/configuration/instance_options#ignore-dump-if-db-exists
ignore_dump_if_db_exists = false

#################
### SNAPSHOTS ###
#################

# 如果为true，则启用计划快照，如果为false（默认值），则禁用。
# 如果传递的值为整数，则以传递的值作为每个快照之间的间隔启用计划快照，以秒为单位。
# https://www.meilisearch.com/docs/learn/configuration/instance_options#schedule-snapshot-creation
schedule_snapshot = false

# 设置Meilisearch将存储快照的目录。
# https://www.meilisearch.com/docs/learn/configuration/instance_options#snapshot-destination
snapshot_dir = "/var/apps/meilisearch/snapshots"

# 在导入以前生成的快照后启动Meilisearch，该快照位于给定的文件路径处。
# https://www.meilisearch.com/docs/learn/configuration/instance_options#import-snapshot
# import_snapshot = "./path/to/my/snapshot"

# 当import_snapshot不指向有效的快照文件时，防止Meilisearch引发错误。
# https://www.meilisearch.com/docs/learn/configuration/instance_options#ignore-missing-snapshot
ignore_missing_snapshot = false

# 防止具有现有数据库的Meilisearch实例在使用import_snapshot时引发错误。
# https://www.meilisearch.com/docs/learn/configuration/instance_options#ignore-snapshot-if-db-exists
ignore_snapshot_if_db_exists = false

###########
### SSL ###
###########

# 在指定路径中启用客户端身份验证。
# https://www.meilisearch.com/docs/learn/configuration/instance_options#ssl-authentication-path
# ssl_auth_path = "./path/to/root"

# 设置服务器的SSL证书。
# https://www.meilisearch.com/docs/learn/configuration/instance_options#ssl-certificates-path
# ssl_cert_path = "./path/to/certfile"

# 设置服务器的SSL密钥文件。
# https://www.meilisearch.com/docs/learn/configuration/instance_options#ssl-key-path
# ssl_key_path = "./path/to/private-key"

# 设置服务器的OCSP文件。
# https://www.meilisearch.com/docs/learn/configuration/instance_options#ssl-ocsp-path
# ssl_ocsp_path = "./path/to/ocsp-file"

# 使SSL身份验证成为强制性。
# https://www.meilisearch.com/docs/learn/configuration/instance_options#ssl-require-auth
ssl_require_auth = false

# 激活SSL会话恢复。
# https://www.meilisearch.com/docs/learn/configuration/instance_options#ssl-resumption
ssl_resumption = false

# 激活SSL票证。
# https://www.meilisearch.com/docs/learn/configuration/instance_options#ssl-tickets
ssl_tickets = false

#############################
### 实验性功能 ###
#############################

# 实验性指标功能。有关更多信息，请参阅: <https://github.com/meilisearch/meilisearch/discussions/3518>
# 启用GET /metrics端点上的Prometheus指标。
experimental_enable_metrics = false

# 在索引期间实验性减少RAM使用，不要在生产环境中使用，参见: <https://github.com/meilisearch/product/discussions/652>
experimental_reduce_indexing_memory_usage = false
EOF

sed -i 's/"development"/"production"/g' /etc/meilisearch/config.toml


