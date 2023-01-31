
* After installing mariadb in centos 7


1. [passwd issue](https://tecadmin.net/install-mysql-5-7-centos-rhel/)

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



# MySQL 5.7 installation in CentOS 7
```code bash
sudo su
```

**_Remove MariaDB packages_**

```cmd
yum list installed | grep -i maria
yum remove mariadb.x86_64
yum remove mariadb-libs.x86_64
```

_**Download MySQL 5.7 RPM tar**_

```cmd
wget https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-5.7.24-1.el7.x86_64.rpm-bundle.tar
mkdir mysql-5.7-rpm-packages
tar -xvf mysql-5.7.24-1.el7.x86_64.rpm-bundle.tar -C mysql-5.7-rpm-packages
cd mysql-5.7-rpm-packages/
```

_**Don't use 'yum install *.rpm'. It will not work and give error messages**_

```cmd
yum install mysql-community-{server,client,common,libs}-* --exclude='*minimal*'
```

_**Start MySQL**_

```cmd
systemctl start mysqld
```

_**Enable mysqld service in startup**_

```cmd
systemctl enable mysqld
```
_**Get temporary password of root**_

```cmd
grep 'A temporary password' /var/log/mysqld.log |tail -1
```

_**Make MySQL secure installation**_

```cmd
mysql_secure_installation
```

