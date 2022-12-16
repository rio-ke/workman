# backup format in local-server

#### Go to linux server terminal and type command below to backup the wanted datas

_backup data_

```bash
mysqldump -u root[username] -p database | gzip -9 > data_name.sql.gz
```

 #### Now login mysql root `sudo mysql -u root -p` then comand below

_Remove the Table Data_

```bash
TRUNCATE table_name;
```

_To view the value you insert the table_

```bash
select * from tabe_name;
```
_view the table structure_

```bash
describe tabe_name;
```

#### Try this command in linux-server terminal again to restore the backup data

_restore data_

```bash
gunzip < data_name.sql.gz | sudo mysql -u root[user] -p [database]
```

**_restore backup to local-server to remote-server_**

_backup data form local-server_

```bash
mysqldump -u [username] -p database | gzip -9 > data_name.sql.gz
```

_copy data to remote-server_

```bash
scp file_name.sql.gz remote-server_username@192.168.0.111:/home/remote-server_username/floder_name
```

_go to remote-server and login to mysql_

```bash
sudo mysql -u user -p
```

first database name same as localhost-server

```bash
create database [database_name];
```
`exit mysql`

_restore the database in remote-server_

```bash
gunzip < demo.sql.gz | sudo mysql -u username -p [database_name]
```

**_Test-restored data_**

```bash
sudo mysql
```
```bash
use database_name;
```

```bash
select * from table_name;
```





