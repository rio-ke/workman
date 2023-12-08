**Mask the Firewalld Service**

* Masking the service prevents it from being started even if another service tries to start it. This is an extra step to ensure that the firewall remains disabled.

```cmd
sudo systemctl mask firewalld
```
