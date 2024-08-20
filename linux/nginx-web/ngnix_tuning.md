## Nginx and Optimization Guide

**Nginx Configuration**

```cmd
sudo vim /etc/nginx/nginx.conf
```
_Increase Worker Processes and Connections_

* Nginx can handle multiple connections per worker, but tuning these parameters can help:

```nginx
worker_processes auto;
worker_connections 4096;  # Increased to handle more simultaneous connections
```
**Enable Keepalive**
* Keepalive connections can significantly improve performance by reducing the overhead of establishing new connections.

```ngnix
keepalive_timeout 75s;  # Slightly increased for better performance
keepalive_requests 2000;  # Increased to allow more requests per connection
```
**Optimize Buffers**
* Adjusting buffer settings can enhance performance for client requests
```cmd
sudo vim /etc/nginx/nginx.conf
```
_Add the following_
```ngnix
client_body_buffer_size 32k;  # Increased for larger body sizes
client_max_body_size 64M;  # Increased to allow larger uploads
client_header_buffer_size 2k;  # Increased for larger headers
large_client_header_buffers 8 32k;  # Increased for handling larger headers
```
**Optimizing FastCGI Buffers and Timeouts**

* These settings help manage FastCGI requests effectively
```nginx
fastcgi_buffers 32 16k;  # Increased buffer size for FastCGI responses
fastcgi_buffer_size 64k;  # Increased for larger FastCGI responses
fastcgi_connect_timeout 30s;  # Reduced for quicker timeouts
fastcgi_send_timeout 180s;  # Increased to allow more time for sending data
fastcgi_read_timeout 180s;  # Increased to allow more time for reading data
```
**Enable HTTP/2**
* HTTP/2 can improve loading times and reduce latency.
```ngnix
listen 443 ssl http2;
```
**How to Disable Server Tokens**

* To enhance security by preventing the server from displaying its version number in error pages and in the Server HTTP response header
```nginx
server_tokens off;
```
