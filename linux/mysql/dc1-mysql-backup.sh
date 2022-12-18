#!/bin/bash

TIMESTAMP=$(date +%Y%b%d\%a\%H-%M-%S)
BACKUP_DIR="/mnt/backup/RCMS/dailymysqldb/$TIMESTAMP"
MYSQL_USER=sqladmin
MYSQL_PASSWORD="9Qf2+kXrM@h9ZNhnL{Qnf"
MYSQL=/usr/bin/mysql
MYSQLDUMP=/usr/bin/mysqldump
mkdir -p $BACKUP_DIR
databases=`$MYSQL -u$MYSQL_USER -p$MYSQL_PASSWORD -e "SHOW DATABASES;" | grep -Ev "(Database|information_schema|mysql|performance_schema)"`
for db in $databases; do
echo $db
$MYSQLDUMP --user=$MYSQL_USER -p$MYSQL_PASSWORD --skip-lock-tables --quick --single-transaction --databases $db | gzip > "$BACKUP_DIR/$db.gz"
done
