# how to create pem key or Convert to pem


**How to get a .pem file from ssh key pair?**


* This will convert your public key to an OpenSSL compatible format.

```bash
ssh-keygen -f id_rsa -e -m pem
```

**Using ssh-keygen to export the key in the .pem format**

```bash
ssh-keygen -f id_rsa.pub -m 'PEM' -e > id_rsa.pub.pem
```


**_Options as follows: (See man ssh-keygen)_**

*  -f id_rsa.pub: input file
*  -m 'PEM': output format PEM
*  -e: output to STDOUT


**_Add your public key on your server to authorized_keys_**

```bash
cat .ssh/id_rsa.pub >> .ssh/authorized_keys
```