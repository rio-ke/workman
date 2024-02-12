```bash
server {
    listen 80;
    server_name example.com;  # Replace with your domain or server IP address

    root /var/www/html;  # Replace with the root directory of your website

    location / {
        try_files $uri $uri/ =404;
    }

    location /my-directory {
        autoindex on;
    }

    # Additional server configurations can be added here
}
```
