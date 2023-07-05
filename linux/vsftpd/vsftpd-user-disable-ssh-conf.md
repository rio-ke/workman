# vsftpd user ssh login prevention

* As we will share only FTP access to the user

* we have to modify SSH configuration file to prevent SSH access from the FTP user.

```cmd
sudo vi /etc/ssh/sshd_config
```
_Add the following line to the file_

```bash
DenyUsers $user # vsftpd-user-name
```
_Save the file and restart SSH service_

```cmd
sudo service sshd restart
```
