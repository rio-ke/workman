# mysql replica conf-tuning for master and slave

**_Master node_**


```cnf
# BINARY LOGGING #

server_id                      = 1 
log_bin                        = /drbd-dbdata/Bin_log/mysql-bin 
log_bin_index                  = /drbd-dbdata/Bin_log/mysql-bin 
binlog_do_db                   = replicadb1
binlog_do_db                   = replicadb2
binlog_ignore_db               = mysql
binlog_ignore_db               = information_schema

max_binlog_size                = 500M
expire_logs_days               = 2 
sync_binlog                    = 1
#binlog_format                 = row
relay_log                      = /drbd-dbdata/Relay_log/mysql-relay-bin
user                           = mysql
symbolic-links                 = 0
#slow_query_log                =
#gtid-mode                     = on 
#enforce-gtid-consistency      = true 
master-info-repository         = TABLE 
relay-log-info-repository      = TABLE 
slave-parallel-workers         = 2 
#binlog-checksum               = CRC32 
master-verify-checksum         = 1 
slave-sql-verify-checksum      = 1 
binlog-rows-query-log_events   = 1 
log_slave_updates              = 1
#
max_allowed_packet          = 16M
read_buffer_size            = 1M
sort_buffer_size            = 16M
thread_cache_size           = 8
#set-variable               = max_connections=500
```

**_Slave node_**

```cnf
# BINARY LOGGING # 

server_id                      = 2 
log_bin                        = /drbd-dbdata/Bin_log/mysql-bin  
log_bin_index                  = /drbd-dbdata/Bin_log/mysql-bin
binlog_do_db                   = replicadb1
binlog_do_db                   = replicadb2
binlog_ignore_db               = mysql
binlog_ignore_db               = information_schema

expire_logs_days               = 2 
sync_binlog                    = 1 
binlog_format                  = row 
relay_log                      = /drbd-dbdata/Relay_log/mysql-relay-bin 
log_slave_updates              = 1 
read_only                      = 1
slave-skip-errors 		         = 1032,1062
#gtid-mode                     = on 
#enforce-gtid-consistency      = true 
master-info-repository         = TABLE 
relay-log-info-repository      = TABLE 
#slave-parallel-workers        = 2 
#binlog-checksum               = CRC32 
master-verify-checksum         = 1 
slave-sql-verify-checksum      = 1 
binlog-rows-query-log_events   = 1
log-slave-updates              = 1
#binlog_format                 = mixed
```
