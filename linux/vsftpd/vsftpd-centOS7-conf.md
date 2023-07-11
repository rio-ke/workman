## FTP centos7


_check SELinux settings_

```cmd
chcon -t public_content_rw_t /webdata
setsebool -P allow_ftpd_anon_write=1
```
