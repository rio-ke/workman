
_Error_

* ERROR 1819 (HY000): Your password does not satisfy the current policy requirements

_Here is what I do to remove the validate password plugin:_

1. Login to the mysql server as root `mysql -h localhost -u root -p`
2. Run the following sql command: 

```sql
uninstall plugin validate_password;
```

4. If last line doesn't work (new mysql release), you should execute;

```sql
UNINSTALL COMPONENT 'file://component_validate_password';
```
- An uninstalled plugin is not displayed by 

```sql
show plugins;
```

5. To install it back again, the command is:

```sql
INSTALL COMPONENT 'file://component_validate_password';
```

6. If you just want to change the policy of password validation plugin:

```sql
SET GLOBAL validate_password.policy = 0;   # For LOW
SET GLOBAL validate_password.policy = 1;   # For MEDIUM
SET GLOBAL validate_password.policy = 2;   # For HIGH
```

```sql
set global validate_password.policy = LOW;
set global validate_password.length = 2;
set global validate_password.mixed_case_count = 0;
set global validate_password.number_count = 0;
set global validate_password.special_char_count = 0;
```

**_Disabled by configuration:_
**
1. A plugin can be disabled by configuration only if installed.

```cnf
[mysqld]
validate_password = OFF
```

_Restart the service_

```cmd
sudo systemctl restart mysqld
```
































_refer_

[passwd-validate](https://stackoverflow.com/questions/36301100/how-do-i-turn-off-the-mysql-password-validation)





