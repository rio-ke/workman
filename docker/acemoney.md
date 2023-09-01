
create hostbath in webdata

```cmd
mkdir TEST-ACEMONEY
```
* create dockerfile in /home/admin/liveace

**only build image**
```cmd
docker build -t rcms/prod_acemoney:v1 -f Dockerfile.PROD_ACEMONEY .
```
**Don't run docker container after building images**

```cmd
docker run -d -p 80:80 --name acemoney-container rcms/prod_acemoney

docker run -d -p 8074:80 --name prod-acemoney rcms/prod_acemoney:v1
```

**_Go to nginx conf file location_**

```cnf
server {
    listen 80;
    listen [::]:80;
    server_name ken.domain.in;
    return 301 https://$host$request_uri;
}


server {
    listen 443 ssl;
    listen [::]:443 ssl;
    server_name ken.domain.in;
    
    # year 2023-2024
    ssl_certificate /etc/ssl/certs/certificates-upto-2024/domain-2023-2024.crt;
    ssl_certificate_key /etc/ssl/certs/certificates-upto-2024/domain-2023-2024.key;
    ssl_trusted_certificate /etc/ssl/certs/certificates-upto-2024/ca-bundle-client.crt;

    # year 2022-2023
    #ssl_certificate /etc/ssl/certs/certificates-upto-2023/domain-2022-2023.crt;
    #ssl_certificate_key /etc/ssl/certs/certificates-upto-2023/domain-2022-2023.key;
    #ssl_trusted_certificate /etc/ssl/certs/certificates-upto-2023/ca-bundle-client.crt;
    
    access_log /var/log/nginx/ken_access.log;
    error_log /var/log/nginx/ken_error.log;

location / {
    proxy_pass http://localhost:8072;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_redirect http://domain.in https://domain.in;
    }
}

```

**go to Dockerfile location**
```cmd
sudo vim docker-compose.yml
```
```yml
version: '3.2'
networks:
  acemoney:
services:
  acemoney:
    container_name: prod-acemoney
    hostname: prod-acemoney
    image: rcms/prod_acemoney:v1
    restart: unless-stopped
    ports:
      - "8074:80"
    volumes:
      - /webdata/PROD-ACEMONEY:/var/www/html
    networks:
      - acemoney
    labels:
      org.label-schema.group: "monitoring"

```

docker-compose up -d 

Check cantainer
```docker
docker ps -a
```

* Creating test cantainer with Already created Image 

_Go to dir path_

```cmd
cd /home/admin/Test-ACE/
```

_create compose file with some midification_

* change container_name
* change hostname
* change port number
* change volumes /webdata/TEST-ACEMONEY

```yml
version: '3.2'
networks:
  acemoney:
services:
  acemoney:
    container_name: test-acemoney
    hostname: test-acemoney
    image: rcms/prod_acemoney:v1
    restart: unless-stopped
#port front port change it
    ports:
      - "8072:80"
    volumes:
      - /webdata/TEST-ACEMONEY:/var/www/html
    networks:
      - acemoney
    labels:
      org.label-schema.group: "monitoring"
```

give permissions to /folder 

```cmd
chown datatx.datatx TEST-ACEMONEY
```




