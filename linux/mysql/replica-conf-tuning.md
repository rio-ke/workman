# mysql replica conf for master and slave

**_Master node_**


```cnf

server-id = 1
log-bin=path/mysql-bin.log
binlog_do_db=replicadb

sync_binlog=1
user=mysql
symbolic-links=0
binlog_format = ROW
max_binlog_size = 500
expire-logs-days = 7
slow_query_log
##
# BINARY LOGGING # 
server_id                     = 1 
log_bin                       = /drbd-dbdata/Binlog-file/mysql-bin 
log_bin_index                 = /drbd-dbdata/Binlog-file/mysql-bin 
expire_logs_days              = 2 
sync_binlog                   = 1 
#binlog_format                 = row 
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
```

**_Slave node_**

```cnf
# BINARY LOGGING # 
server_id                      = 2 
log_bin                        = /drbd-dbdata/relayloglog-file/mysql-bin  
log_bin_index                  = /drbd-dbdata/relaylog-file/mysql-bin 
expire_logs_days               = 2 
sync_binlog                    = 1 
binlog_format                  = row 
relay_log                      = /var/lib/mysql/data/mysql-relay-bin 
log_slave_updates              = 1 
read_only                      = 1 
gtid-mode                      = on 
enforce-gtid-consistency       = true 
master-info-repository = TABLE 
relay-log-info-repository = TABLE 
#slave-parallel-workers = 2 
binlog-checksum = CRC32 
master-verify-checksum = 1 
slave-sql-verify-checksum = 1 
binlog-rows-query-log_events = 1
```
