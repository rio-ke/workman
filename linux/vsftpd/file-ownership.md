# Configure vsftpd to Force File Ownership

**_Set chown_uploads in vsftpd Configuration_**

```cmd
sudo vim /etc/vsftpd.conf
```

_force ownership of uploaded files_

```bash
chown_uploads=YES
chown_username=root
chown_upload_mode=0755
```

_Set Group Ownership_

```cmd
sudo chown -R root:vsftpdGroup /path/to/directory
sudo chmod g+s /path/to/directory
```
_*Restart the service_

```cmd
sudo systemctl restart vsftpd
```
