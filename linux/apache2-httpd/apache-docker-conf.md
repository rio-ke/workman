```cnf
<VirtualHost *:80>
    ServerName ken.domain.in
    Redirect permanent / https://ken.domain.in/
</VirtualHost>

<VirtualHost *:443>
    ServerName ken.domain.in

    # SSL configuration
    SSLEngine on
    SSLCertificateFile /etc/ssl/certs/certificates-upto-2024/domain-2023-2024.crt
    SSLCertificateKeyFile /etc/ssl/certs/certificates-upto-2024/domain-2023-2024.key
    SSLCertificateChainFile /etc/ssl/certs/certificates-upto-2024/ca-bundle-client.crt

    ErrorLog /var/log/apache2/ken_error.log
    CustomLog /var/log/apache2/ken_access.log combined

    <Location />
        ProxyPass http://localhost:8072/
        ProxyPassReverse http://localhost:8072/
        ProxyPreserveHost On

        Header set X-Real-IP %{REMOTE_ADDR}s
        Header set X-Forwarded-For %{HTTP_HOST}s
        Header set X-Forwarded-Proto %{HTTP_HOST}s

        ProxyPassReverseCookieDomain domain.in ken.domain.in
    </Location>
</VirtualHost>
```
