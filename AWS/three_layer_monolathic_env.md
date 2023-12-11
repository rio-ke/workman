## RVL Test Environment

**`Architecture of test env`**

![rvl-test-env.](https://github.com/rcms-org/documentation/assets/91359308/399a9309-a25d-4af9-a7b5-3b677a8cccf7)

**`WORKFLOW:-`**

![test-env](https://github.com/rcms-org/documentation/assets/91359308/766edfa5-0757-4403-b67a-c626fb16ec9f)

_**dependencies installation in webserver**_
```sh
sudo apt install -y apache2 mod_ssl awscli openssl php php-common php-mbstring  php-xml php-mysqlnd php-gd php-mcrypt php-pdo  php-curl php-cli php-opcache php-zip wget unzip
```
**_apache package status_**
```sh
sudo systemctl start apache2
sudo systemctl enable apache2
sudo systemctl status apache2
```
**_Document Root_**
```sh
sudo mkdir -p /var/www/html/rvl-test
```
_**apache configuration**_

```cmd
sudo vim /etc/apache2/sites-available/domain_test.conf
```

```sh
<VirtualHost *:80>
        ServerAdmin   webmaster@domainriok.in
        Servername    domainriok.in
        DocumentRoot  /var/www/html/domainriok/
        Redirect permanent / https://domainriok.in/
</VirtualHost>                 

<VirtualHost *:443>

       ServerAdmin  webmaster@domainriok.in
       Servername    domainriok.in
       DocumentRoot /var/www/html/demo_test
       
       # HTTP TO HTTPS REDIRECTION
       SSLEngine on
       SSLCertificateFile       /etc/apache2/ssl/test/test-domainriok-certificate.crt
       SSLCertificateKeyFile    /etc/apache2/ssl/test/test-domainriok-private.key
       SSLCertificateChainFile  /etc/apache2/ssl/test/ca-bundle-client.crt
       # APACHE2 LOGS
       ErrorLog  ${APACHE_LOG_DIR}/domainriok.in.error.log
       CustomLog ${APACHE_LOG_DIR}/domainriok.in.access.log combined
      
       <Location "/">
         Require all granted
         # Allow access for all IPs
       </Location>
       
</VirtualHost>
```
**check the syntax of the configuration file**
```sh
apachectl configtest
```
**link the apache2 configuration file**
```sh
sudo ln -s /etc/apache2/sites-available/rvltest.conf /etc/apache2/sites-enabled/
```
**disable the apache2 default configuration file**
```sh
sudo a2dissite 000-default.conf
sudo service apache2 reload
```
_**vsftpd installation**_
```sh
sudo apt update

sudo apt install vsftpd -y

sudo adduser rvltest # password - Password@123

sudo mkdir -p /etc/vsftpd/users /var/www/html/rvl-test

sudo chown -R rvltest:rvltest /var/www/html/rvl-test

echo "local_root=/var/www/html/rvl-test" | sudo tee -a /etc/vsftpd/users/rvltest

echo "rvltest" | sudo tee /etc/vsftpd.chroot_list
```
_**vsftpd configuraion**_

```cmd
sudo vim /etc/vsftpd.conf
```
```sh
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
ftpd_banner=Welcome to Project Vsftpd service.
chroot_local_user=YES
chroot_list_enable=NO
user_config_dir=/etc/vsftpd/users
allow_writeable_chroot=YES
secure_chroot_dir=/var/run/vsftpd/empty
pam_service_name=vsftpd
rsa_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem
rsa_private_key_file=/etc/ssl/private/ssl-cert-snakeoil.key
ssl_enable=NO
chroot_list_file=/etc/vsftpd.chroot_list
userlist_enable=YES
userlist_file=/etc/vsftpd.chroot_list
userlist_deny=NO
pasv_enable=YES
pasv_min_port=64000
pasv_max_port=64321
port_enable=YES
pasv_address=********* # aws public ip
pasv_addr_resolve=NO
```
**_restart the vsftpd service_**
```sh
sudo systemctl restart vsftpd.service
sudo systemctl status vsftpd.service
```
```cmd
sudo ss -tulpn | grep 21
```
_**configure the remote database details in my remote phpmyadmin file**_

* find the phpmyadmin configuration file
```cmd
cd /var/www/html/rvl-test/phpmyadmin
```
```cmd
ls -lh | grep config
```
```cmd
sudo mv config.sample.inc.php config.inc.php
```
**_Add the mysql remote configuration in remote phpmyadmin server_**

```cmd
sudo vim /var/www/html/rvl-test/phpmyadmin/config.inc.php
```

```conf
$i++;
$cfg['Servers'][$i]['host']          = '192.168.2.102'; # dbserver private ip
$cfg['Servers'][$i]['port']          = '3306';
$cfg['Servers'][$i]['socket']        = '';
$cfg['Servers'][$i]['connect_type']  = 'tcp';
$cfg['Servers'][$i]['extension']     = 'mysql';
$cfg['Servers'][$i]['compress']      = FALSE;
$cfg['Servers'][$i]['auth_type']     = 'config';
$cfg['Servers'][$i]['user']          = 'testrvluser';
$cfg['Servers'][$i]['password']      = '5JK@RHpYS3';
$cfg['Servers'][$i]['AllowNoPassword'] = false;
```

_**dependencies installation in dbserver with mysql user creation**_

```cmd
sudo apt install mysql-server
sudo systemctl start mysql
sudo systemctl status mysql
```
```sql
CREATE USER 'testrvluser'@'%' IDENTIFIED BY '5JK@RHpYS3';
CREATE DATABASE demo_test;
GRANT ALL PRIVILEGES ON dm_test.* TO 'testuser'@'%';
FLUSH PRIVILEGES;
```

_**Configure MySQL for remote connections**_

```cmd
sudo vim /etc/mysql/mysql.conf.d/mysqld.cnf
```
```conf
# Change that line instead of bind-address = 127.0.0.1:
bind-address = 0.0.0.0
```
```sql
sudo systemctl restart mysql
```
## OUTPUT:

1. Paste the url in the browser - [http://rvldemo.scanslips.in](https://rvldemo.scanslips.in/)

2. Paste the url for the phpmyadmin in browser - https://rvldemo.scanslips.in/phpmyadmin/
