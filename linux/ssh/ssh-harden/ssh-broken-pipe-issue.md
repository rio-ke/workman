# OpenSSH Server connection drops out after few minutes of inactivity


**_error while ssh inactive for 2min_**

```bash
[root@node-02 admin]# client_loop: send disconnect: Broken pipe

```

* This is usually the result of a packet filter or NAT device timing out your TCP connection due to inactivity. For security, reason most enterprises only use SSH protocol version 2. This problem only occurred with version 2.

**_Check ssh intervel_**

```cmd
egrep -i 'ClientAliveInterva|ClientAliveCountMax' /etc/ssh/sshd_config
```

_**Fix OpenSSH Server connection drops out after few minutes of inactivity**_

**Log into the remote server**

```cmd
sudo vi /etc/ssh/sshd_config
```

_Modify setting as follows:_

```cnf
ClientAliveInterval 30
ClientAliveCountMax 5
```

_restart the service_

```cmd
systemctl restart sshd.service
```

## Increase SSH connection timeout using client side configuration

```cmd
sudo vi ~/.ssh/ssh_config
```

_modify values_

```cmd
ServerAliveInterval 15
ServerAliveCountMax 3
```

_restart the service_

```cmd
systemctl restart sshd.service
```

_reference_

```
https://www.cyberciti.biz/tips/open-ssh-server-connection-drops-out-after-few-or-n-minutes-of-inactivity.html#:~:text=This%20is%20usually%20the%20result,only%20occurred%20with%20version%202.
```


































