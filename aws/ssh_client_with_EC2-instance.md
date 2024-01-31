**Connect to your Linux instance using an SSH client**


_To connect to your instance using SSH_

- (Public DNS) To connect using your instance's public DNS name, enter the following command.

```cmd
ssh -i /path/key-pair-name.pem instance-user-name@instance-public-dns-name
```

- (IPv6) Alternatively, if your instance has an IPv6 address, to connect using your instance's IPv6 address, enter the following command.

```cmd
ssh -i /path/key-pair-name.pem instance-user-name@instance-IPv6-address
```
