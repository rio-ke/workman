`mysql 8.0 or above`

```cmd
sudo /etc/init.d/mysql stop
sudo mkdir -v /var/run/mysqld && sudo chown mysql /var/run/mysqld  #(In some cases, if /var/run/mysqld doesn't exist, you have to create it at first◀️
sudo mysqld --skip-grant-tables &      #Start the mysqld configuration
mysql -u root mysql                       #Login to MySQL as root: 
UPDATE mysql.user SET Password = PASSWORD('YOURNEWPASSWORD') WHERE User = 'root';      #Replace YOURNEWPASSWORD with your new password:
FLUSH PRIVILEGES;
```

`mysql 5.7`

```cmd
sudo service mysql stop
sudo mkdir /var/run/mysqld
sudo chown mysql: /var/run/mysqld
sudo mysqld_safe --skip-grant-tables --skip-networking &
mysql -uroot mysql
UPDATE mysql.user SET authentication_string=CONCAT('*', UPPER(SHA1(UNHEX(SHA1('NEWPASSWORD'))))), plugin='mysql_native_password' WHERE User='root' AND Host='localhost';
\q;
sudo mysqladmin -S /var/run/mysqld/mysqld.sock shutdown
sudo service mysql start
```
