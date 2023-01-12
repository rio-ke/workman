# local db data backup in local dir 

#!/usr/bin/env bash

set -x

#daily backup for db data

#set database name
database=backup_db

# set the username and passwd for the database accesss 
user=rcms
passwd=sqladmin

# set the location to save data backup file
backup_dir="/home/rcms-lap-173/backup"

# set the file name for backup data file
date=$(date +"%Y-%m-%d-%H-%M")
backup_file="$backup_dir/$date"

# dump the database to dir
mysqldump -u$user -p$passwd $database > $backup_file.sql
