Convert Files to PEM Format
---

* While using third-party certificate files, ensure that the files are of .pem format. If not, follow the information in this section to convert them.

_Convert RSA Key File to PEM Format_

* Use the following command to convert an RSA key file to a .pem format file:

_Syntax_:

```cmd
openssl rsa -in <path-to-key-file> -text <path-to-PEM-file>
```
_Example_:

```cmd
openssl rsa -in ~/aws/scanslips-private.key -text > ~/aws/scanslips-private.pem
```

```bash
openssl rsa -inform DER -in private.key -outform PEM -out private.pem
```
```bash
openssl pkcs8 -inform DER -in private.key -outform PEM -out private.pem
```
**Certificate Chain (ca_bundle.crt):**

* If you want to convert the certificate bundle (ca_bundle.crt) to a different format like PEM, you can use the following command:

```bash
openssl x509 -in ca_bundle.crt -out ca_bundle.pem -outform PEM
```

**Certificate Body (certificate.crt):**

* If your certificate.crt file is not in PEM format and you want to convert it to PEM format, you can use the following command:

```bash
openssl x509 -in certificate.crt -out certificate.pem -outform PEM
```
