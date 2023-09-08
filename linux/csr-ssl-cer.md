**Create csr cetificate**

* To create a Certificate Signing Request (CSR) using OpenSSL

Syntex
```cmd
openssl req -new -newkey rsa:<keysize> -keyout <private_key_file> -out <csr_file>
```
```cmd
openssl req -new -newkey rsa:2048 -keyout example.com.key -out example.com.csr
```

