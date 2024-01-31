**Enable SSL/TLS Module:**

```cmd
sudo a2enmod ssl
sudo systemctl restart apache2
```

**Create SSL/TLS Configuration:**

```cnf
<VirtualHost *:443>
    ServerAdmin webmaster@example.com
    ServerName yourdomain.com

    DocumentRoot /var/www/html

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined

    <Directory /var/www/html>
        Options -Indexes +FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    DirectoryIndex index.html index.php

    # Enable PHP
    <FilesMatch \.php$>
        SetHandler application/x-httpd-php
    </FilesMatch>

    # SSL/TLS Configuration
    SSLEngine on
    SSLCertificateFile /etc/apache2/ssl/your_certificate.crt
    SSLCertificateKeyFile /etc/apache2/ssl/your_private_key.key
    SSLCertificateChainFile /etc/apache2/ssl/your_certificate_chain.crt

    # Reverse Proxy Configuration (if needed)
    # ProxyPass / http://backend_server/
    # ProxyPassReverse / http://backend_server/
</VirtualHost>
```

**Enable the Virtual Host:**

```cmd
sudo a2ensite your-virtual-host.conf
sudo systemctl restart apache2
```

**HTTP to HTTPS Redirection**:
```cmd
<VirtualHost *:80>
    ServerAdmin webmaster@example.com
    ServerName yourdomain.com

    # Redirect all HTTP requests to HTTPS
    Redirect permanent / https://yourdomain.com/
</VirtualHost>
```
**Restart Apache:**

```cmd
sudo systemctl restart apache2
```

```cnf
<VirtualHost *:80>
    ServerAdmin webmaster@example.com
    ServerName yourdomain.com

    DocumentRoot /var/www/html

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined

    <Directory /var/www/html>
        Options -Indexes +FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    DirectoryIndex index.html index.php

    # Enable PHP
    <FilesMatch \.php$>
        SetHandler application/x-httpd-php
    </FilesMatch>

    # Redirect HTTP requests to HTTPS
    RewriteEngine On
    RewriteCond %{HTTPS} off
    RewriteRule ^ https://%{HTTP_HOST}%{REQUEST_URI} [R=301,L]
</VirtualHost>

<VirtualHost *:443>
    ServerAdmin webmaster@example.com
    ServerName yourdomain.com

    DocumentRoot /var/www/html

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined

    <Directory /var/www/html>
        Options -Indexes +FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    DirectoryIndex index.html index.php

    # Enable PHP
    <FilesMatch \.php$>
        SetHandler application/x-httpd-php
    </FilesMatch>

    # SSL/TLS Configuration
    SSLEngine on
    SSLCertificateFile /etc/apache2/ssl/your_certificate.crt
    SSLCertificateKeyFile /etc/apache2/ssl/your_private_key.key
    SSLCertificateChainFile /etc/apache2/ssl/your_certificate_chain.crt

    # Reverse Proxy Configuration (if needed) #backendserver=ip-add-of-the-server
    # ProxyPass / http://backend_server/
    # ProxyPassReverse / http://backend_server/
</VirtualHost>
```
**Enable proxy modules**
```cmd
sudo a2enmod ssl
sudo a2enmod proxy
sudo a2enmod proxy_http
sudo systemctl restart apache2
```




