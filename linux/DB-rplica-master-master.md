**_TEST_**


```bash
sudo vim /etc/mysql/mysql.conf.d/mysqld.cnf
```
```bash

log-bin = /var/log/mysql/mysql-bin.log
tmpdir = /tmp
binlog_format = ROW
max_binlog_size = 100M
sync_binlog = 1
expire-logs-days = 7
slow_query_log
A complete simple configuration looks like below:

[mysqld]
pid-file = /var/run/mysqld/mysqld.pid
socket = /var/run/mysqld/mysqld.sock
datadir = /var/lib/mysql
log-error = /var/log/mysql/error.log
server-id = 1
log-bin = /var/log/mysql/mysql-bin.log
tmpdir = /tmp
binlog_format = ROW
max_binlog_size = 100M
sync_binlog = 1
expire-logs-days = 7
slow_query_log

```


log_bin = /var/log/mysql/mysql-bin.log
log_bin_index =/var/log/mysql/mysql-bin.log.index
relay_log = /var/log/mysql/mysql-relay-bin
relay_log_index = /var/log/mysql/mysql-relay-bin.index

sudo systemctl restart mysql

sudo systemctl status mysql