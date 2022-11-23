
* After installing mariadb in centos 7

command 

* install mariadb in centos7 

```bash
sudo yum install mariadb-server
```

**enable db**

```bash
sudo systemctl enable mariadb
sudo systemctl start mariadb
```

Your MariaDB connection id is 4
Server version: 5.5.68-MariaDB MariaDB Server

***change user  to `root`***

```bash
sudo -i
```

***login to mysql db**
*
```bash
mysql -u root -p
```
error

```bash
ERROR 2002 (HY000): Can't connect to local MySQL server through socket '/var/lib/mysql/mysql.sock' (2)
```


sudo yum autoremove

sudo yum autoclean

sudo yum install mysql-client-core-5.5

sudo yum install mysql-server  