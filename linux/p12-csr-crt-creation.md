[Certificate Key Matcher](https://www.https.in/support/certificate-key-matcher)

_Key file_
```cmd
openssl genrsa -aes128 -out keyfile.key 2048
```
_csr_
```cmd
openssl req -new -key keyfile.key -out csrfile.csr
```


_key-pem_
```cmd
openssl genpkey -algorithm RSA -out private-key.pem
```
_csr-pem_
```cmd
openssl req -new -key private-key.pem -out certificate.csr
```



```bash
openssl pkcs12 -export -out CLIENT_DOMAINNAME.p12 -inkey wsaxis.key -in <<AXIS_SIGNED_certfile.crt>> -name <<aliasname>> -certfile SakshamAPIClientRootCert.crt -certfile SakshamAPIClientIntermediateCertificate.crt
 
 
 
 openssl pkcs12 -export -out axis.p12 -inkey Private.key -in AXIS-client-certificate.crt -name AXIS -certfile Root.crt -certfile Intermediate.crt
 
 
 
 axis.key  ProdIntermediate.crt  ProdRoot.crt  REDIANT-signed.crt
 
 
 openssl pkcs12 -export -out axis.p12 -inkey axis.key -in REDIANT-signed.crt -name AXIS -certfile ProdRoot.crt -certfile ProdIntermediate.crt
 
 
Lemon@11
 
Lemon@22

  
openssl rsa -noout -modulus -in axis.key | openssl md5
  
openssl req -noout -modulus -in axis.csr | openssl md5
```
