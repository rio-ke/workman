## MySQL Install And create user Process (Ubuntu OS)

---

_What is Mysql_

MySQL creates a database for storing and manipulating data, defining the relationship of each table. Clients can make requests by typing specific SQL statements on MySQL. The server application will respond with the requested information and it will appear on the clients' side.

_Install Mysql Service_

```sql

sudo apt update
sudo apt-get install mysql-server -y

```

check running status on the server using

```sql

sudo systemctl status mysql.service

```

---

**MYSQL Config process**

First, use this command to run security processes such as passwords, privileges, and so on.

```sql

sudo mysql_secure_installation

```

- Change the password for root ? ((Press y|Y for Yes, any other key for No) :
- Remove anonymous users? (Press y|Y for Yes, any other key for No) :
- Disallow root login remotely? (Press y|Y for Yes, any other key for No) :
- Remove test database and access to it? (Press y|Y for Yes, any other key for No) :
- Reload privilege tables now? (Press y|Y for Yes, any other key for No) :

**_Mysql user,datebase,table creation & set privileges_**

We'll create a user, a database, a table, and permissions in this section. first of all enter with ur root user and password using this comment

```sql

mysql -u root -p

```

**_User Create with Remote Access_**

First Edit Mysql config file

```
#sudo vim /etc/mysql/mysql.conf.d/mysqld.cnf

bind-address        = 0.0.0.0 or your ip

```

Restart the service

```sql
sudo systemctl stop mysql && sudo systemctl start mysql
```

_Remote user Creation_

```sql

CREATE USER 'username'@'remote_server_ip' IDENTIFIED BY 'password';

```

- Note If you don't know the User IP address, replace this symbol for it in the ip address **%**

_User Login Command_

```sql

mysql -u username -h database_server_ip -p

```

---

_create the user_

| username  | password | server address | database |
| --------- | -------- | -------------- | -------- |
| developer | password | localhost      | apps     |

```sql

CREATE USER 'developer'@'localhost' IDENTIFIED BY 'password';

```

_Grant ALL privileges to user_

```sql

GRANT ALL PRIVILEGES ON *.* TO 'user'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;

```

_Assign selected privileges to user_

```sql

GRANT (Permission) ON *.* TO 'developer'@'localhost';
flush privileges;

```

* Resetting the root password

```sql
ALTER USER 'root'@'localhost' IDENTIFIED BY 'test';
```
* How to change root password and stop root-logins without password
```cmd
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'test';
```
_Revoke Permmission_

```sql

REVOKE ALL PRIVILEGES ON *.* FROM 'developer'@'localhost';
or
REVOKE permission ON *.* FROM 'developer'@'localhost';
FLUSH PRIVILEGES;

```

_view the user permissions_

```sql

SHOW GRANTS FOR 'developer'@'localhost';

```

**_list out the all mysql users_**

```sql
SELECT user FROM mysql.user;
```


_Query statements_

- Select
- Insert
- Update
- delete


_Deleting a MySQL User Accounts_

_listout user and host_

```sql
SELECT User, Host FROM mysql.user;
```

_DROP USER Syntax_

- The basic syntax for the DROP USER statement is:

```sql
DROP USER 'username'@'host';
```
---

**Create database on Root user Set privilege to specify user**

Create a database on the Root User account and grant specific permissions to this account's users.

```sql

create database apps;
show databases;

```

_In the database, set user permissions_

```sql

GRANT all ON apps.* TO 'developer'@'localhost';
flush privileges;

```

_connected to particular database_

```sql

use apps;
#  To view the current database name
status;
# exit the database
exit;

```

**Create table in the databases**

| table name |
| ---------- |
| users      |

_create table_

```sql

use apps;
CREATE TABLE users (
 name varchar(50),
 age int,
 address varchar(50)
);

```

_Remove the Table Data_

```sql

TRUNCATE TABLE tablename;

```

_view the table structure_

```sql
describe table-name;
```

_Insert values to the tables_

```sql

INSERT INTO users (Name,Age,Address) VALUES ('kendanic',26, 'chennai,tamilnadu');
or
INSERT INTO users VALUE('Boys', 'double room', 44665466);

```

_Copy the row from One table to Another table_

first create the same table with column of Source table

```sql

INSERT INTO destination_table select * from source_table;

```

To copy the specific row to use this command

```sql

insert into destination_table select * from source_table where city='New York';

```

- To view the value you insert the table ---> `select * from (table-name);`
- To delete the table row ---> 'DELETE FROM Table_Name WHERE Address='pmk';'

_Add Column to the tables_

```sql

ALTER TABLE vendors
ADD COLUMN phone VARCHAR(15) AFTER name;
```

```sql

ALTER TABLE vendors
ADD COLUMN phone VARCHAR(15) FIRST;

```

to refer for more ---> https://dev.mysql.com/doc/refman/8.0/en/alter-table.html

- To view the value you insert the table ---> `select * from table name;`
- To delete the table column ---> 'ALTER TABLE table_name DROP COLUMN exisiting_column_name;'

_To update the Table_

```sql

UPDATE employees SET email = 'mary.patterson@classicmodelcars.com' WHERE employeeNumber = 1056;

```

---

_Backup single database to Mysql_

```sql
mysqldump -u root -p user1data > /home/deva/Mysql_bak/user1data_bak.sql
```

* Then create multiple databases backup in single comment

```sql
mysqldump -u root -p --databases user1data user2data user3data > /home/deva/Mysql_bak/alldatabase_bak.sql
```
* All database backup commands

```sql
mysqldump -u root -p --all-databases > all-db-backup.sql
```
* And Next create back in single Table

```sql
mysqldump -u root -p user1data A >/home/deva/Table_bak/single_bak.sql
```
* Next Multiple table in single command

```sql
mysqldump -u root -p user1data A B C >/home/deva/Table_bak/all_bak.sql
```

_**Restore**_

* In this section how to restore the bacup tables in single file

```sql
mysql -u root -p user3data < /home/username/Table_bak/a3_bak.sql
```

* Multiple table restore

```sql
mysql -u root -p user3data < /home/username/Table_bak/all3_bak.sql
```

in this section restore single data base in mysql

in restore process first you remove privious databases using drop commant

create new empty database

```sql

mysql -u root -p user1data < /home/username/Mysql_bak/user1data_bak.sql

```

in this section restore single data base in mysql

**in this commant use is base terminal not mysql**

```sql

mysql -u root -p uset1 < /home/username/Mysql_bak/alldatabase_bak.sql

```

restore single and mutiple restore process cmd is same.

to check the restore database table record

```sql

select count(*) from data_2;

```

---

**MySql backup database file transfer one server to another server**

first enter the mysql console
backup ur need database using this command

```sql

 mysqldump -u root -p database name > file path/user1data_bak.sql

```

and tranfer ur file to another server using this command

```sql

scp source_file_name username@destination_host:destination_folder

```

once file transfered then next restore using this command **using command in base terminal not mysql console**

```sql

mysql -u root -p databasename < filepath/backup.sql;

```

to check the restore database table record

```sql

select count(*) from data_2;

```

_**Restore compressed method**_

**_Web-reference_**

1. [mysql-table-cmd](https://linuxize.com/post/show-tables-in-mysql-database/)
