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
chroot_local_user=NO
chroot_list_enable=YES
user_config_dir=/etc/vsftpd/users_group
allow_writeable_chroot=YES
secure_chroot_dir=/var/run/vsftpd/
pam_service_name=vsftpd
#rsa_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem
#rsa_private_key_file=/etc/ssl/private/ssl-cert-snakeoil.key
#ssl_enable=NO
chroot_list_file=/etc/vsftpd.chroot_list
userlist_enable=YES
userlist_file=/etc/vsftpd.chroot_list
userlist_deny=NO
```

sudo apt update
sudo apt install vsftpd -y

sudo adduser ken
passwd ken
sudo adduser rio
passwd rio

sudo cp /etc/vsftpd.conf /etc/vsftpd.conf.original

# sudo vim /etc/vsftpd.conf

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
chroot_local_user=NO
chroot_list_enable=YES
user_config_dir=/etc/vsftpd/users_group
allow_writeable_chroot=YES
secure_chroot_dir=/var/run/vsftpd/
pam_service_name=vsftpd
#rsa_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem
#rsa_private_key_file=/etc/ssl/private/ssl-cert-snakeoil.key
#ssl_enable=NO
chroot_list_file=/etc/vsftpd.chroot_list
userlist_enable=YES
userlist_file=/etc/vsftpd.chroot_list
userlist_deny=NO

sudo mkdir -p /etc/vsftpd/users

sudo mkdir -p /var/www/domain.html
sudo chown -R ken:ken /var/www/domain.in
echo "local_root=/var/www/domain.in" | sudo tee /etc/vsftpd/users/ken

sudo mkdir -p /var/www/domain.html
sudo chown -R rio:rio /var/www/domain.in
echo "local_root=/var/www/domain.in" | sudo tee /etc/vsftpd/users/rio

echo "ken" | tee /etc/vsftpd.chroot_list
echo "rio" | tee -a /etc/vsftpd.chroot_list

systemctl restart vsftpd
systemctl status vsftpd

sudo ss -tulpn | grep 21

```bash
sudo mkdir -p /etc/vsftpd/users
```

```bash
sudo mkdir -p /var/www/domain.html
sudo chown -R ken:ken /var/www/domain.in
echo "local_root=/var/www/domain.in" | sudo tee  /etc/vsftpd/users/ken
```

```bash
sudo mkdir -p /var/www/domain.html
sudo chown -R rio:rio /var/www/domain.in
echo "local_root=/var/www/domain.in" | sudo tee /etc/vsftpd/users/rio
```

```bash
echo "ken" | tee  /etc/vsftpd.chroot_list
echo "rio" | tee -a /etc/vsftpd.chroot_list
```

```bash
systemctl restart vsftpd
systemctl status vsftpd
```

```bash
sudo ss -tulpn | grep 21
```

