## DHCP IP assighning

```yml
services:
  db:
    image: mysql:latest
    environment:
      - MYSQL_ROOT_PASSWORD=password
      - MYSQL_ROOT_HOST=localhost
    ports:
      - 3306:3306
    volumes:
      - db:/var/lib/mysql
    networks:
      - network

volumes:
  db:
    driver: local

networks:
  network:
    driver: bridge
```
