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
SHOW MASTER STATUS;
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
SHOW REPLICA STATUS\G;
```

```sql

*************************** 1. row ***************************
             Replica_IO_State: Waiting for source to send event
                    Source_Host: `Master server_one`
                   Source_User: demo
                    Source_Port: 3306
                Connect_Retry: 60
             Source_Log_File: mysql-bin.000001
  Read_Source_Log_Pos: 1114
               Relay_Log_File: mysql-relay-bin.000002
               Relay_Log_Pos: 326
       lay_Source_Log_File: mysql-bin.000001
            plica_IO_Running: Yes
         plica_SQL_Running: Yes

```

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
