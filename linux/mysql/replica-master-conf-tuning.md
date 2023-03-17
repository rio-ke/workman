# mysql replica conf for master


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

```
