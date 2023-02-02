# Multi Master Replication (Master-Master)


**_Configuration in centOS 7 server_**

- Install mysql


**DB1**

```sql
Master-one: 192.168.xx.xxx
Master-two: 192.168.xx.xxx
```

**_Install MySQL on Master Nodes_**

``` cmd
sudo rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022 
sudo yum localinstall https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm 
sudo yum install mysql-community-server`sql
```

**_Open the mysql configuration file on the Master node._**

`Edit`

```sql
sudo vim /etc/my.cnf
```

```sql
bind-address     = 0.0.0.0
server-id        = 1
log_bin          = mysql-bin
```

**_save the configuration file and restart MySQL service for the changes to take effect on Master node_**

```sql
sudo systemctl restart mysqld
```

**_Create a New User for Replication on Master Node_**

_log in to the MySQL master-server as shown_.

```sql
sudo mysql -u root -p
```

pass: xxxxxxx

_Next, proceed and execute the queries below to create a replica user and grant access to the replication slave. Remember to use your IP address._

```sql
CREATE USER 'master-two'@'192.168.xxx.xxx' IDENTIFIED BY 'test1';  #(add Master-two ip_address here in remote-users)
```

```sql
GRANT REPLICATION SLAVE ON *.* TO 'master-two'@'192.168.xxx.xxx';  #(add Master-two ip_address here in remote-users)
```

```sql
FLUSH PRIVILEGES;
```

```sql
SHOW MASTER STATUS\G;
```

Note the `mysql-bin.000001` value and the Position ID `xxxx`. These values will be crucial when setting up the slave server.

**DB2**

**_Install MySQL on Slave Nodes_**

```cmd
sudo rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022 
sudo yum localinstall https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm 
sudo yum install mysql-community-server`sql
```

**_Open the mysql configuration file on the Slave node._**

`Edit`

```cmd
sudo vim /etc/my.cnf
```

```sql
bind-address     = 0.0.0.0
server-id        = 2
log_bin          = mysql-bin
```

**_save the configuration file and restart MySQL service for the changes to take effect on Slave node_**

```sql
sudo systemctl restart mysqld
```

_log in to the MySQL server as shown_.

```sql
sudo mysql -u root -p
```

pass: xxxxxxx

**_stop mysql-replication in slave server_**

```sql
STOP SLAVE;
```

**_ADD the cmd lines in Slave node one by one _**

```sql
CHANGE MASTER TO
MASTER_HOST='@Master server_one' ,
MASTER_USER='username' ,
MASTER_PASSWORD='passwdword' ,
MASTER_LOG_FILE='mysql-bin.000092' ,
MASTER_LOG_POS=154;

```

**_start the slave replication slave server_**

```sql
START SLAVE;
```

**_show master-slave replica status in slave server_**

```sql
SHOW SLAVE STATUS\G;
```

```bash
********* 1. row *********
               Slave_IO_State: Waiting for master to send event
                  Master_Host: 192.168.3.214
                  Master_User: demo
                  Master_Port: 3306
                Connect_Retry: 60
              Master_Log_File: mysql-bin.000002
          Read_Master_Log_Pos: 995
               Relay_Log_File: mysql-relay-bin.000004
                Relay_Log_Pos: 1208
        Relay_Master_Log_File: mysql-bin.000002
             Slave_IO_Running: Yes
            Slave_SQL_Running: Yes

```

**ERROR**

1. Fatal error: The slave I/O thread stops because master and slave have equal MySQL server UUIDs; these UUIDs must be different for replication to work.
2. Slave_IO_Running: `connecting`

**Resolved**

_Check auto.cnf_

Go To: sudo -i

```cmd
cd /var/lib/mysql
```
_Rename auto.cnf_

```cmd
mv auto.cnf auo.cnf.backup 
```
-------
```sql
START SLAVE;
```
```sql
START SLAVE;
```
```sql
SHOW SLAVE STATUS\G;
```

---

**Testing the configuration in both master-slave servers**

**_IN Master-server_**

Create Database in master-server

```sql
CREATE DATABASE kendanic;
```

```sql
SHOW DATABASES;
```

**_IN slave-server_**

```cmd
sudo mysql
```

check if database created in master-server appers in slave-server

```sql
SHOW DATABASES;
```

**_web-references_**

1. [create User for replication](https://dev.mysql.com/doc/refman/8.0/en/replication-howto-repuser.html)
