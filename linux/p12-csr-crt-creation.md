 openssl pkcs12 -export -out CLIENT_DOMAINNAME.p12 -inkey wsaxis.key -in <<AXIS_SIGNED_certfile.crt>> -name <<aliasname>> -certfile SakshamAPIClientRootCert.crt -certfile SakshamAPIClientIntermediateCertificate.crt
 
 
 
 openssl pkcs12 -export -out axis.p12 -inkey Private.key -in AXIS-client-certificate.crt -name AXIS -certfile Root.crt -certfile Intermediate.crt
 
 
 
 axis.key  ProdIntermediate.crt  ProdRoot.crt  REDIANT-signed.crt
 
 
 openssl pkcs12 -export -out axis.p12 -inkey axis.key -in REDIANT-signed.crt -name AXIS -certfile ProdRoot.crt -certfile ProdIntermediate.crt
 
 
Lemon@11
 
Lemon@22

  
openssl rsa -noout -modulus -in axis.key | openssl md5
  
  
openssl req -noout -modulus -in axis.csr | openssl md5
