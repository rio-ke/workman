# Table backup and restore in database to databses

```sql
sudo mysqldump -u root -p database_name table_name > backup_file.sql
```

```sql
sudo mysql -u root -p database_name < cash_in_others.sql
sudo mysql -u root -p database_name < closing_balance.sql
sudo mysql -u root -p database_name < vault_in.sql
```
