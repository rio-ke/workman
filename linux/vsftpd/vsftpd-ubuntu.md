# Vsftpd configuration in ubuntu server

```bash
sudo apt update
sudo apt install vsftpd -y
```

**_creating users_**

```bash
sudo adduser ken
passwd ken
```

```bash
sudo adduser rio
passwd rio
```

```bash
sudo cp /etc/vsftpd.conf /etc/vsftpd.conf.original
```

**_vsftpd config file location_**

```bash
sudo vim /etc/vsftpd.conf
```
```bash
# cat /etc/vsftpd.conf
listen=YES
listen_ipv6=NO
anonymous_enable=NO
local_enable=YES
write_enable=YES
local_umask=022
dirmessage_enable=YES
use_localtime=YES
xferlog_enable=YES
connect_from_port_20=YES
xferlog_file=/var/log/vsftpd.log
xferlog_std_format=NO
idle_session_timeout=600
data_connection_timeout=120
ascii_upload_enable=YES
ascii_download_enable=YES
ftpd_banner=Welcome to FTP service.

# this is for localuser to use only given path not others
chroot_local_user=NO
# users under vsftpd.chroot_list need to enable
chroot_list_enable=YES

# need to change below dir
user_config_dir=/etc/vsftpd/users_group #for users directory path 

allow_writeable_chroot=YES
secure_chroot_dir=/var/run/vsftpd/empty
pam_service_name=vsftpd
#rsa_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem
#rsa_private_key_file=/etc/ssl/private/ssl-cert-snakeoil.key
#ssl_enable=NO
#chroot_list_file=/etc/vsftpd.chroot_list 
userlist_enable=YES
userlist_file=/etc/vsftpd.chroot_list
userlist_deny=NO
```

**_create folder for vsftpd-group and users_**
```bash
sudo mkdir -p /etc/vsftpd/users_group #(users group must for every conf)
```

**_allow user to access the folder_**  

`user-1`

```bash
sudo mkdir -p /var/www/html/domain.html
sudo chown -R ken:ken /var/www/html/domain.html
echo "local_root=/var/www/html/domain.html" | sudo tee  /etc/vsftpd/users_group/ken
```

`user-2`

```bash
sudo mkdir -p /var/www/html/domain.hml
sudo chown -R rio:rio /var/www/html/domain.hml
echo "local_root=/var/www/html/domain.hml" | sudo tee /etc/vsftpd/users_group/rio
```

**_allow users to access_**

`user-1`
```bash
echo "ken" | tee  /etc/vsftpd.chroot_list
```
`user-2`

```bash
echo "rio" | tee -a /etc/vsftpd.chroot_list
```

```bash
systemctl restart vsftpd
systemctl status vsftpd
```

```bash
sudo ss -tulpn | grep 21
```

