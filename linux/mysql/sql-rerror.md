## mysql error fix


* ERROR 1130 (HY000): Host '192.168.1.105' is not allowed to connect to this MySQL server

```sql
CREATE USER 'username'@'localhost' IDENTIFIED BY 'password';

GRANT ALL PRIVILEGES ON *.* TO 'username'@'localhost' WITH GRANT OPTION;

CREATE USER 'replica'@'%' IDENTIFIED BY 'password';

GRANT ALL PRIVILEGES ON *.* TO 'replica'@'%' WITH GRANT OPTION;

FLUSH PRIVILEGES;
```

* Error 'Can't find any matching row in the user table' on query. Default database: 'radiant_replica_test'. Query: 'GRANT ALL PRIVILEGES ON `apps`.* TO 'slave'@'%''

```sql

```

* Slave_SQL_Running

```sql
STOP SLAVE;
SET GLOBAL SQL_SLAVE_SKIP_COUNTER = 1; 
START SLAVE;
```

* Error initializing relay log position: Could not open log file
```sql

```

* ERROR 1223 (HY000): Can't execute the query because you have a conflicting read lock

```sql

```
