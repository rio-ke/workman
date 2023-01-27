# Mysql DB master-master Replication iablen ubuntu server

**Check server-hosts**

|server|hostname|ip-add|
|-----|-----|-----|
|Master 1|Hostname: DB1|IP Address: 192.168.x.xxx|
|Master 2|Hostname: DB2|IP Address: 192.168.x.xxx|


**_mysql installation on ubuntu server_**

```cmd
sudo apt-get update && sudo apt install mysql-server -y
```

_Enable mysqld.servicem in server_

```cmd

```

**_secure the MySQL installation_**

```bash
sudo mysql_secure_installation utility  # secure the MySQL installation
```

**_Allow remote access_**

```cmd
sudo ufw enable
sudo ufw allow mysql
```

_Start the MySQL service_

```cmd
sudo systemctl start mysql
```
Launch at reboot

```cmd
sudo systemctl enable mysql
```


```sql
change master to
master_host='10.0.0.30',
master_user='repl_user',
master_password='password',
master_ssl=1,
master_log_file='mysql-bin.000001',
master_log_pos=1405;
```


