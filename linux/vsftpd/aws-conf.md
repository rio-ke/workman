_**`conf_1`**_

```cnf
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
ftpd_banner= Hi this is rioke file sharing workspace.
chroot_local_user=YES
chroot_list_enable=NO
user_config_dir=/etc/vsftpd/users
allow_writeable_chroot=YES
secure_chroot_dir=/var/run/vsftpd/empty
pam_service_name=vsftpd
ssl_enable=YES
rsa_cert_file=/etc/vsftpd/ssl/private/vsftpd.pem
rsa_private_key_file=/etc/vsftpd/ssl/private/vsftpd.pem

# Allow only secure TLS connections
ssl_tlsv1=YES

# Enable passive mode
pasv_enable=YES
pasv_min_port=40000
pasv_max_port=40100

chroot_list_file=/etc/vsftpd.chroot_list
userlist_enable=YES
userlist_file=/etc/vsftpd.chroot_list
userlist_deny=NO
pasv_enable=YES
pasv_min_port=64000
pasv_max_port=64321
port_enable=YES
pasv_address= #aws-instance-ip
pasv_addr_resolve=NO
```
_**`conf_2`**_

```cnf
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
ftpd_banner=Welcome to RADIANT FTP service.
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
pasv_address=ip-add-aws #aws-instance-ip
pasv_addr_resolve=NO
```
```cnf
# Enable FTP service to listen on IPv4 (recommended)
listen=YES

# Disable IPv6 support
listen_ipv6=NO

# Disable anonymous FTP access
anonymous_enable=NO

# Enable local user access
local_enable=YES

# Allow local users to write to their own directories
write_enable=YES

# Set umask for uploaded files
local_umask=022

# Enable displaying directory messages
dirmessage_enable=YES

# Use local server time for file timestamps
use_localtime=YES

# Enable logging of file transfers
xferlog_enable=YES

# Use standard vsftpd log format
xferlog_std_format=YES

# Log FTP protocol commands
log_ftp_protocol=YES

# Set idle session timeout (seconds)
idle_session_timeout=600

# Set data connection timeout (seconds)
data_connection_timeout=120

# Enable ASCII mode uploads and downloads
ascii_upload_enable=YES
ascii_download_enable=YES

# Display a welcome banner
ftpd_banner=Welcome to RVL-LIVE FTP service.

# Chroot local users to their home directories (enhances security)
chroot_local_user=YES

# Directory where per-user configuration files are stored
user_config_dir=/etc/vsftpd/users

# Allow writeable chroots (use with caution)
allow_writeable_chroot=YES

# Directory to use for secure chroot environment
secure_chroot_dir=/var/run/vsftpd/empty

# Name of the PAM service vsftpd will use
pam_service_name=vsftpd

# Uncomment the following lines to enable SSL/TLS

# Enable SSL/TLS
ssl_enable=YES

# Path to the SSL certificate and private key
rsa_cert_file=/etc/vsftpd/ssl/private/vsftpd.pem
rsa_private_key_file=/etc/vsftpd/ssl/private/vsftpd.pem

# Allow only secure TLS connections
ssl_tlsv1=YES
ssl_sslv2=NO
ssl_sslv3=NO

# Force TLS for data connections (uncomment if needed)
#require_ssl_reuse=NO
#require_ssl_cert=NO

# Enable passive mode for data connections
pasv_enable=YES

# Define the passive mode port range
pasv_min_port=40000
pasv_max_port=40100

# Specify the external IP address of your server if behind NAT (uncomment if needed)
#pasv_address=15.2.6.79
#pasv_addr_resolve=NO
```


