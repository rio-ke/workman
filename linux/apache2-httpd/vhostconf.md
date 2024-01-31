```cfg
# /etc/httpd/conf.d/root.onedoubt.in.conf
<VirtualHost *:80>
ServerAdmin webmaster@root.onedoubt.in
ServerName root.onedoubt.in
DocumentRoot /drbd-webdata

    <Directory "/drbd-webdata">
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    LogFormat "%a %l %u %t %>s %b %D %T %r %{User-agent}i %{Referer}i" custom_format
    CustomLog /var/log/httpd/root.onedoubt.in.access.log custom_format
    ErrorLog /var/log/httpd/root.onedoubt.in.error.log

    Header always set Strict-Transport-Security "max-age=31536000; includeSubDomains; preload"
    Header always set X-Content-Type-Options "nosniff"
    Header always set X-Frame-Options "SAMEORIGIN"
    Header always set X-XSS-Protection "1; mode=block"

</VirtualHost>

<VirtualHost *:443>
ServerAdmin webmaster@root.onedoubt.in
ServerName root.onedoubt.in
DocumentRoot /drbd-webdata

    <Directory "/drbd-webdata">
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    LogFormat "%a %l %u %t %>s %b %D %T %r %{User-agent}i %{Referer}i" custom_format
    CustomLog /var/log/httpd/root.onedoubt.in.access.log custom_format
    ErrorLog /var/log/httpd/root.onedoubt.in.error.log
    
    SSLProtocol -All +TLSv1 +TLSv1.1 +TLSv1.2

    SSLCertificateFile /etc/certs/.onedoubt.in/certificate.crt
    SSLCertificateKeyFile /etc/certs/.onedoubt.in/private.key
    SSLCertificateChainFile /etc/certs/.onedoubt.in/ca-bundle.crt
    
    SSLEngine on
    Header always set Strict-Transport-Security "max-age=31536000; includeSubDomains; preload"
    Header always set X-Content-Type-Options "nosniff"
    Header always set X-Frame-Options "SAMEORIGIN"
    Header always set X-XSS-Protection "1; mode=block"

</VirtualHost>
```
