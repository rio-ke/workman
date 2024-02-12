```cmd
<VirtualHost *:80>
    ServerAdmin admin@example.com
    DocumentRoot /var/www/html

    <Directory "/var/www/html">
        Options Indexes FollowSymLinks
        AllowOverride None
        Require all granted
    </Directory>

    <Location "/var/www/html/webdata">
        Options -Indexes
        ErrorDocument 404 /404.html
    </Location>
</VirtualHost>
```
