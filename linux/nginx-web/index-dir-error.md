```cnf
location / {
    try_files $uri $uri/ @fallback;
}

location @fallback {
    error_page 403 /403.html;
    error_page 404 /404.html;
    error_page 500 502 503 504 /50x.html;

    # Additional custom error pages or redirects can be added here
}

location = /50x.html {
    root /var/www/html;
}
```

```cnf
server {
    listen 80;
    server_name example.com;  # Replace with your domain or server IP address

    root /var/www/html;  # Replace with the root directory of your website

    location / {
        try_files $uri $uri/ @fallback;
    }

    location @fallback {
        error_page 403 /error-pages/403.html;
        error_page 404 /error-pages/404.html;

        # Additional custom error pages or redirects can be added here
    }

    location = /50x.html {
        root /var/www/html/error-pages;
    }

    # Additional server configurations can be added here
}
```

```cnf
server {
    listen 443 ssl;
    server_name example.com;  # Replace with your domain or server IP address

    ssl_certificate /path/to/your/fullchain.pem;  # Replace with the path to your SSL certificate
    ssl_certificate_key /path/to/your/privatekey.pem;  # Replace with the path to your SSL private key
    ssl_protocols TLSv1.2 TLSv1.3;

    root /var/www/html;  # Replace with the root directory of your website

    location / {
        try_files $uri $uri/ @fallback;
    }

    location @fallback {
        error_page 403 /error-pages/403.html;
        error_page 404 /error-pages/404.html;

        # Additional custom error pages or redirects can be added here
    }

    location = /50x.html {
        root /var/www/html/error-pages;
    }

    # Additional SSL configurations can be added here
}
```
