## mysql tuning exple:

```cnf
[client]
port                             = 3306
socket                           = /var/lib/mysql/mysql.sock
wait_timeout                     = 60
interactive_timeout              = 300

[mysqld]
datadir                          = /drbd-dbdata/data
socket                           = /var/lib/mysql/mysql.sock
port                             = 3306
bind-address                     = 0.0.0.0

# Disabling symbolic-links is recommended to prevent assorted security risks
symbolic-links                   = 0
log-error                        = /var/log/mysqld.log
pid-file                         = /var/run/mysqld/mysqld.pid

query_cache_size                 = 4G
query_cache_type                 = 1
query_cache_min_res_unit         = 1K
query_cache_limit                = 6G
open-files-limit                 = 102400

#query_cache_size                 = 16M
#query_cache_type                 = 1
#query_cache_min_res_unit         = 1K
#query_cache_limit                = 512K

innodb_buffer_pool_size          = 40G
innodb_buffer_pool_instances     = 20
innodb_flush_method              = O_DIRECT
innodb_flush_log_at_trx_commit   = 1
innodb_autoinc_lock_mode         = 2
innodb_log_file_size             = 2047M
innodb_log_buffer_size           = 512M

join_buffer_size                 = 2G
read_buffer_size                 = 128M
read_rnd_buffer_size             = 2M
tmp_table_size                   = 6G
max_heap_table_size              = 6G
bulk_insert_buffer_size          = 256M
key_buffer_size                  = 20G
sort_buffer_size                 = 6G
#sql_mode                        = NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION
sql_mode                         = NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION,NO_AUTO_VALUE_ON_ZERO
max_allowed_packet               = 1G

#skip-name-resolve
max_connect_errors               = 10
max_connections                  = 1600
max_user_connections             = 0
thread_cache_size                = 1024


# log-error                        = /var/log/mysql_error.log
#long_query_time                  = 3
#log_queries_not_using_indexes    = 1
#slow_query_log                   = 1
#slow-query-log-file              = /var/log/mysql_slow_queries.log
#general_log                      = 1
##general_log_file                = /var/log/mysql_general.log

table_open_cache                 = 12500
table_definition_cache           = 400
net_buffer_length                = 16K
innodb_lock_wait_timeout         = 50
innodb_io_capacity               = 1000
transaction-isolation            = READ-COMMITTED
innodb_thread_concurrency        = 48

[mysqldump]
quick
max_allowed_packet               = 256M
```
