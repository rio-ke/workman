# How to Secure and Harden OpenSSH Server in centOS7

1. **_Setup SSH Passwordless Authentication_**

- The first step is to generate an SSH key-pair which consists of a public key and a private key. The private key resides on your host system whilst the public key is then copied to the remote server.

- Once the public key is successfully copied, you can now SSH in to the remote server seamlessly without having to provide a password.

_open ssh-config file_

```bash
sudo vim /etc/ssh/sshd_config
```

```bash
PasswordAuthentication no
```

_restart the SSH daemon_

```bash
sudo systemctl restart sshd
```
