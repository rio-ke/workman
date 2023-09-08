

```cmd
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/vsftpd/ssl/private/vsftpd.pem -out /etc/vsftpd/ssl/private/vsftpd.pem
```

```cnf
sudo vim /etc/vsftpd.conf
```
```cnf
# Enable TLS
ssl_enable=YES

# Path to the SSL certificate and private key
rsa_cert_file=/etc/ssl/private/vsftpd.pem
rsa_private_key_file=/etc/ssl/private/vsftpd.pem

# Allow only secure TLS connections
ssl_tlsv1=YES
ssl_sslv2=NO
ssl_sslv3=NO

# Force TLS for data connections
require_ssl_reuse=NO
require_ssl_cert=NO

# Enable passive mode
pasv_enable=YES
pasv_min_port=40000
pasv_max_port=40100
```
