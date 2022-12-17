Dump and restore a single table from a compressed (.sql.gz) format

Dump

mysqldump db_name table_name | gzip > table_name.sql.gz
Restore

gunzip < table_name.sql.gz | mysql -u username -p db_name



Dumping from a remote database

mysqldump -u <db_username> -h <db_host> -p db_name table_name > table_name.sql
For further reference:

http://www.abbeyworkshop.com/howto/lamp/MySQL_Export_Backup/index.html

Restore

mysql -u <user_name> -p db_name
mysql> source <full_path>/table_name.sql
or in one line

mysql -u username -p db_name < /path/to/table_name.sql

1. 

for line in $(mysql -u... -p... -AN -e "show tables from NameDataBase");
do 
mysqldump -u... -p.... NameDataBase $line > $line.sql ; 
done