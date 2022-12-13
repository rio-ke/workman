**DB1**

sudo apt update
sudo apt install mysql-server -y

sudo vim /etc/mysql/mysql.conf.d/mysqld.cnf

#bind-address = 127.0.0.1
bind-address = 0.0.0.0

```bash
server-id = 1
log_bin = /var/log/mysql/mysql-bin.log
log_bin_index =/var/log/mysql/mysql-bin.log.index
relay_log = /var/log/mysql/mysql-relay-bin
relay_log_index = /var/log/mysql/mysql-relay-bin.index
```

sudo service mysql restart

ALTER USER 'root'@'localhost' IDENTIFIED BY 'MyNewPass';

create user 'slave_user'@'%' identified by 'PASSWORD';

#Remember to replace 'PASSWORD' with a strong value for security purposes.

```bash
GRANT REPLICATION SLAVE ON *.* TO 'demo_user'@'%';
FLUSH PRIVILEGES;
```

**DB2**

```bash
server-id = 2
log_bin = /var/log/mysql/mysql-bin.log
log_bin_index =/var/log/mysql/mysql-bin.log.index
relay_log = /var/log/mysql/mysql-relay-bin
relay_log_index = /var/log/mysql/mysql-relay-bin.index
```

sudo service mysql restart

stop slave;

CHANGE MASTER TO MASTER_HOST = '192.168.0.110', MASTER_USER = 'root, MASTER_PASSWORD = 'MyNewPass', MASTER_LOG_FILE = 'mysql-bin.000006', MASTER_LOG_POS = 394;

start slave;

**Test configuration**

sudo mysql -u root -p

create database replica_demo;

DROP DATABASE replica_demo;

create database master_slave;

mysqldump -u root -p demo | gzip -9 > data_name.sql.gz

# **sample 2**

user pass: aocojkr!@J10ac1

root pass: MyNewPass

user: demo

sudo vim /etc/mysql/mysql.conf.d/mysqld.cnf

bind-address = 192.168.121.190
server-id = 1
log_bin = /var/log/mysql/mysql-bin.log

CREATE USER 'demo'@'192.168.0.110' IDENTIFIED BY 'aocojkr!@J10ac1';
GRANT REPLICATION SLAVE ON _._ TO 'demo'@'192.168.0.110';

SHOW MASTER STATUS\G

```bash
mysql> SHOW MASTER STATUS\G

*************************** 1. row ***************************
             File: mysql-bin.000001
         Position: 713
     Binlog_Do_DB:
 Binlog_Ignore_DB:
Executed_Gtid_Set:
1 row in set (0.00 sec)
```

_slave-server_

bind-address = 192.168.121.236
server-id = 2
log_bin = /var/log/mysql/mysql-bin.log

STOP SLAVE;

mysql> CHANGE MASTER TO
-> MASTER_HOST='192.168.0.110',
-> MASTER_USER='root',
-> MASTER_PASSWORD='MyNewPass',
-> MASTER_LOG_FILE='binlog.000006',
-> MASTER_LOG_POS='394';

test

CREATE DATABASE test;

GRANT ALL ON test.\* TO 'demo'@'192.168.0.110' IDENTIFIED BY 'aocojkr!@J10ac1';

GRANT ALL PRIVILEGES ON _._ TO root@my_ip IDENTIFIED BY ‘MyNewPass‘ WITH GRANT OPTION;




