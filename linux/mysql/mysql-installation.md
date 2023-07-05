## MySQL Install And create user Process (Ubuntu OS)
---

_What is Mysql_

MySQL creates a database for storing and manipulating data, defining the relationship of each table. Clients can make requests by typing specific SQL statements on MySQL. The server application will respond with the requested information and it will appear on the clients' side.

_Install Mysql Service_

```sql
sudo apt update
sudo apt-get install mysql-server -y
```

_check running status on the server using_

```sql
sudo systemctl status mysql.service
```
