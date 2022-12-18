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

```diff
!sudo systemctl restart sshd
```

2. **_Disable User SSH Passwordless Connection Requests_**

- To reject requests from users without a password, again, head over to the configuration file at /etc/ssh/sshd_config and ensure that you have the directive below

```bash
PermitEmptyPasswords no
```

```diff
!restart the deamon
```

3. **_Disable SSH Root Logins_**

for some server privacy we need to disable the root login

```bash
PermitRootLogin no
```

```diff
!restart deamon
```

4. **_Limit SSH Access to Certain Users_**

- For an added security layer, you can define the users who require SSH protocol to log in and perform remote tasks on the system. This keeps off any other users who might try to gain entry to your system without your approval.

```bash
AllowUsers users1 users2 users3 users4
```

```diff
!resatrt deamon
```
