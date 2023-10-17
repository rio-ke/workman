**_docker command for mysql in local machine_**


_create network for mysql_

```cmd
docker network create mynetwork
```

_Run a MySQL 5.7 Container:_

```cmd
docker run --name mysql57 --network mynetwork -e MYSQL_ROOT_PASSWORD=your_password -d mysql:5.7
```

Modify the SQL Dump File:

_Copy the SQL Dump into the MySQL 5.7 Container:_

```cmd
docker cp daily_collection.sql mysql57:/daily_collection.sql
```

_Access the MySQL 5.7 Container:_

```cmd
docker exec -it mysql57 bash
```















