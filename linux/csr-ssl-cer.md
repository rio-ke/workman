**Create csr cetificate**

* To create a Certificate Signing Request (CSR) using OpenSSL

Syntex
```cmd
openssl req -new -newkey rsa:<keysize> -keyout <private_key_file> -out <csr_file>
```
```cmd
openssl req -new -newkey rsa:2048 -keyout example.com.key -out example.com.csr
```
********************************************************************************************************************----------------------------------------------------------------------------------------------------------------------------------------------------------------------

First we generate csr and key
---

`KEY`

* Key generate then ask password then put paasword  two time (spaceLemon@11) Lemon@11

```bash 
openssl genrsa -aes128 -out <keyfile.key>> 2048
```
`CSR`

```bash
openssl req -new -key <<keyfile.key>> -out <<csrfile.csr>>
```

* Once create csr then share to the axis team or implementation team

                      OR
                     
```bash
openssl req -new -newkey rsa:2048 -nodes -keyout server.key -out server.csr
```

* Then axis team share three certificates after we excute p12 creation command

```bash
openssl pkcs12 -export -out CLIENT_DOMAINNAME.p12 -inkey wsaxis.key -in <<AXIS_SIGNED_certfile.crt>> -name <<aliasname>> -certfile SakshamAPIClientRootCert.crt -certfile SakshamAPIClientIntermediateCertificate.crt
```

p12 command excute the terminal it ask export password (don't forgot that password) Lemon@22

PFB steps to generate P12 File
-----------------------------------------
Create the pkcs12 keystore

openssl pkcs12 -export -out CLIENT_DOMAINNAME.p12 -inkey [CLIENT_DOMAINNAME].key  -in <<AXIS_SIGNED_certfile.crt>> -name <<aliasname>>    -certfile <<axis-root.crt>> -certfile <<AxisIntermediate.crt>>
Note : Axis Team will share Saksham Root and Intermediate public certificates with client.

Ex : openssl pkcs12 -export -out axis.p12 -inkey Private.key -in  AXIS-client-certificate.crt -name AXIS -certfile Root.crt -certfile Intermediate.crt


 Important step
----------------------

In place of [CLIENT_DOMAINNAME].key , need to pass the path of the key file that was generated at the time of creating csr

In place of <<AXIS_SIGNED_certfile.crt>>, need to pass the path of the signed certificate that we shared to you.

In place of <<aliasname>> , you can give any name ( most clients prefer to give organisation name )

and path of the Intermediate and root certificates given to you should be given in place of /axis-root.crt -certfile ../AxisIntermediate.crt

After passing everything correctly , click enter
i) It will ask for pass phrase for key file that you created while creating csr
ii) Give password correctly which you gave while creating that key file
after that , if you click enter
iii) It will ask as enter export password, give a well remembered password.
iv) It will ask again to confirm same, enter same password again

Now, pkcs12 will be generated .

How can i validate my csr and private.key and Rediant-client-certificate

 KEY
  
```bash
  
  openssl rsa -noout -modulus -in Pivatekey.key | openssl md5
  
```
CSR
  
```bash
  
openssl req -noout -modulus -in CSRCert.csr | openssl md5
  
```
  
RADIANT_sighned-certificate
  
```bash
  
openssl x509 -noout -modulus -in Axissigned-client-certificate.crt | openssl md5
  
```
