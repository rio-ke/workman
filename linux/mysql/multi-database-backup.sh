#!/bin/bash

# MySQL credentials
username="enter_user_name"
password="enter_password_here"

# List all databases
databases=$(mysql -u "$username" -p"$password" -e "SHOW DATABASES;" | grep -Ev "(Database|information_schema|performance_schema|mysql)")

# Loop through each database and take separate backups
for db in $databases; do
    mysqldump -u "$username" -p"$password" "$db" > "$db.sql"
done
