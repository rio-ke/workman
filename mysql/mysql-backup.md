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
gunzip < data_name.sql.gz | mysql -u root[user] -p [database]
```
