# MySQL Master Slave Switchover


_To use the same configuration to perform Switchover between Master and Slave._

1. Check replication in MySQL Slave:

_To show slave status & show master status command to check for the status of lag and for any error in replication_

_To check status:_

```sql
show slave status\G;
```
````
mysql> show slave status\G;
*************************** 1. row ***************************
               Slave_IO_State: Waiting for master to send event
                  Master_Host: 192.168.1.1
                  Master_User: slave
                  Master_Port: 3306
                Connect_Retry: 60
              Master_Log_File: binlog.000004
          Read_Master_Log_Pos: 8969
               Relay_Log_File: relay_bin01.000004
                Relay_Log_Pos: 154
        Relay_Master_Log_File: binlog.000025
             Slave_IO_Running: Yes
            Slave_SQL_Running: Yes
              Replicate_Do_DB: masterdata$
          Replicate_Ignore_DB:
           Replicate_Do_Table:
       Replicate_Ignore_Table:
      Replicate_Wild_Do_Table:
  Replicate_Wild_Ignore_Table:
                   Last_Errno: 0
                   Last_Error:
                 Skip_Counter: 0
          Exec_Master_Log_Pos: 8969
              Relay_Log_Space: 1349
              Until_Condition: None
               Until_Log_File:
                Until_Log_Pos: 0
           Master_SSL_Allowed: No
           Master_SSL_CA_File:
           Master_SSL_CA_Path:
              Master_SSL_Cert:
            Master_SSL_Cipher:
               Master_SSL_Key:
        Seconds_Behind_Master: 0
Master_SSL_Verify_Server_Cert: No
                Last_IO_Errno: 0
                Last_IO_Error:
               Last_SQL_Errno: 0
               Last_SQL_Error:
  Replicate_Ignore_Server_Ids:
             Master_Server_Id: 1
                  Master_UUID: 13ecba9c-444a-11eb-a397-000c29f9d9e6
             Master_Info_File: mysql.slave_master_info
                    SQL_Delay: 0
          SQL_Remaining_Delay: NULL
      Slave_SQL_Running_State: Slave has read all relay log; waiting for more updates
           Master_Retry_Count: 86400
                  Master_Bind:
      Last_IO_Error_Timestamp:
     Last_SQL_Error_Timestamp:
               Master_SSL_Crl:
           Master_SSL_Crlpath:
           Retrieved_Gtid_Set:
            Executed_Gtid_Set: 
                Auto_Position: 1
         Replicate_Rewrite_DB:
                 Channel_Name:
           Master_TLS_Version:
       Master_public_key_path:
        Get_master_public_key: 0
            Network_Namespace:
1 row in set, 1 warning (0.01 sec)
 
ERROR:
No query specified
```` 
_To check master status in slave to find Gtid_

```sql
show master status;
```

| File | Position | Binlog_Do_DB | Binlog_Ignore_DB | Executed_Gtid_Set|
|----|----|----|----|----|
| binlog.000004 | 940 |  |  | 13ecba9c-444a-11eb-a397-000c29f9d9e6:1-35 |



**************************************************************************************************************************************************
**_Make Master Readonly: Make master readonly to avoid any update in master before switchover and create replication user in master._**

_Go to master and use this command_


```sql
SET GLOBAL read_only = ON;
```

```sql
show variables like '%read_only%';
```

| Variable_name         | Value |
|-----------------------|-------|
| innodb_read_only      | OFF   |
| read_only             | ON    |
| super_read_only       | OFF   |
| transaction_read_only | OFF   |



**To change slave to master conf**

_Go to slave and use this command_

```sql
stop slave;
```
_To reset master conf_

```sql
reset master;
``` 
_change master readable only_

```sql
SET GLOBAL read_only = OFF; 
``` 
```sql
show variables like '%read_only%';
```

| Variable_name         | Value |
|-----------------------|-------|
| innodb_read_only      | OFF   |
| read_only             | OFF   |
| super_read_only       | OFF   |
| transaction_read_only | OFF   |


**_Create replication user for old-slave_** 

```sql
CREATE USER IF NOT EXISTS 'slave'@'%' IDENTIFIED BY 'Password123#@!';
```
```sql
GRANT REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO 'slave'@'%';
```
```sql
 ALTER USER 'slave'@'%' IDENTIFIED WITH mysql_native_password BY 'Password123#@!';
```
```sql
flush privileges;
```

```sql
show master status;
```

| File          | Position | Binlog_Do_DB | Binlog_Ignore_DB | Executed_Gtid_Set                      |
|---------------|----------|--------------|------------------|----------------------------------------|
| binlog.000004 |      196 |              |                  | 13c84508-5014-11eb-af41-000c2997dedd:1 |


**_Update old-master instance with new-master information_**

_To change old-slave as master_

```sql
CHANGE MASTER TO
MASTER_HOST='192.168.1.102',
MASTER_USER='slave',
MASTER_PASSWORD='password',
MASTER_LOG_FILE='mysql-bin.000002', 
MASTER_LOG_POS=1600;
```



 



















































































































































































