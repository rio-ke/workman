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

CHANGE MASTER TO MASTER_HOST = '192.168.137.214', MASTER_USER = 'slave_user', MASTER_PASSWORD = 'PASSWORD', MASTER_LOG_FILE = 'mysql-bin.000001', MASTER_LOG_POS = 753;

start slave;

**Test configuration**

sudo mysql -u root -p

create database replica_demo;

DROP DATABASE replica_demo;

create database master_slave;
