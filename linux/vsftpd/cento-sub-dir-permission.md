In this configuration, we've added the "user_config_dir" option, which specifies the directory where user-specific configuration files will be stored. Create the directory /etc/vsftpd/user_conf and create separate configuration files for each user inside it.

For example, if you want to restrict user "john" to the "qr" and "scan" folders, create a file named /etc/vsftpd/user_conf/john with the following content:

javascript
Copy code
```cnf
local_root=/webdata/qr, /webdata/scan
```
