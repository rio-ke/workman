```yml
version: '3.8'

services:
  prod-web:
    image: server-test
    container_name: test002
    restart: unless-stopped
    ports:
      - "8061:80"
    volumes:
      - /path/to/website:/var/www/html
      - /path/to/conf:/etc/apache2/sites-available
    networks:
      - my_custom_network  # Define a custom network name here

networks:
  my_custom_network:  # Define the custom network name
```

```cmd
docker-compose -p myproject up -d

```
