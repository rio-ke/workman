```cfg
# /etc/httpd/conf.d/nrazindbs.radianterp.in.conf
<VirtualHost *:80>
    ServerAdmin webmaster@nrazindbs.radianterp.in
    ServerName nrazindbs.radianterp.in
    DocumentRoot /drbd-webdata

    RewriteEngine On
    RewriteCond %{HTTPS} off
    RewriteRule ^(.*)$ https://%{HTTP_HOST}%{REQUEST_URI} [R=301,L]

</VirtualHost>

<VirtualHost *:443>
    ServerAdmin webmaster@nrazindbs.radianterp.in
    ServerName nrazindbs.radianterp.in
    DocumentRoot /drbd-webdata

    <Directory "/drbd-webdata">
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    LogFormat "%a %l %u %t %>s %b %D %T %r %{User-agent}i %{Referer}i" custom_format
    CustomLog /var/log/httpd/nrazindbs.radianterp.in.access.log custom_format
    ErrorLog /var/log/httpd/nrazindbs.radianterp.in.error.log
    
    SSLProtocol -All +TLSv1 +TLSv1.1 +TLSv1.2

    SSLCertificateFile /etc/certs/radianterp.in/certificate.crt
    SSLCertificateKeyFile /etc/certs/radianterp.in/private.key
    SSLCertificateChainFile /etc/certs/radianterp.in/ca-bundle.crt
    
    SSLEngine on
    Header always set Strict-Transport-Security "max-age=31536000; includeSubDomains; preload"
    Header always set X-Content-Type-Options "nosniff"
    Header always set X-Frame-Options "SAMEORIGIN"
    Header always set X-XSS-Protection "1; mode=block"

</VirtualHost>
```
