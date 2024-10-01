```conf
# override default of no subsystems
#Subsystem      sftp    /usr/lib/openssh/sftp-server
Subsystem sftp internal-sftp

Match User ken
    ForceCommand /bin/false
    PasswordAuthentication no

# SFTP configuration for user 'hulk'

Match User hulk
    ChrootDirectory /var/www/sftp/hulk
    ForceCommand internal-sftp
    X11Forwarding no
    AllowTcpForwarding no
    PasswordAuthentication yes
```

```cmd
sudo mkdir -p /var/www/sftp/hulk
sudo chown root:root /var/www/sftp/hulk
sudo chmod 755 /var/www/sftp/hulk
sudo mkdir -p /var/www/sftp/hulk/uploads
sudo chown hulk:hulk /var/www/sftp/hulk/uploads
sudo chmod 700 /var/www/sftp/hulk/uploads
```
```cmd
sudo systemctl restart sshd
```
```cmd
sudo systemctl status sshd
```
