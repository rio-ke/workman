Stop the MySQL Server: sudo /etc/init.d/mysql stop
(In some cases, if /var/run/mysqld doesn't exist, you have to create it at first: sudo mkdir -v /var/run/mysqld && sudo chown mysql /var/run/mysqld
Start the mysqld configuration: sudo mysqld --skip-grant-tables &
Login to MySQL as root: mysql -u root mysql
Replace YOURNEWPASSWORD with your new password:

UPDATE mysql.user SET Password = PASSWORD('YOURNEWPASSWORD') WHERE User = 'root';
FLUSH PRIVILEGES;
