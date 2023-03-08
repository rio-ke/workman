MYSQL --initialize error

![node-two](https://user-images.githubusercontent.com/88568938/223636029-8c144753-f6b8-4ac4-9552-53a96b3215a7.png)


* The error message indicates that the --initialize flag was used to initialize the MySQL data directory, but the data directory already contained files. 

To solve this error, you can do the following:

    Stop the MySQL server using the following command:

```bash

sudo systemctl stop mysqld
```

_Remove the existing data directory by running the following command:_

```bash

sudo rm -rf /var/lib/mysql

```

* This will delete the MySQL data directory and all its contents. Be sure to back up any important data before doing this.

_Create a new data directory by running the following command:_

```bash

sudo mkdir -p /var/lib/mysql
```

_for DRBD_PCS_CLUSTER use this command_

```cmd
mysql_install_db --no-defaults --datadir=/drbd-dbdata/data
```

Initialize the MySQL data directory again using the following command:


```bash

sudo mysqld --initialize-insecure --user=mysql
```

The --initialize-insecure flag is used to initialize the data directory without setting a root password. The --user=mysql flag specifies the user under which the MySQL server runs.

Start the MySQL server again using the following command:

```sql

sudo systemctl start mysqld
```

