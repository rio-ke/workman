# find /bin/bash users using awk command


```cmd
grep /bin/bash /etc/passwd | awk -F: '{ print $1 }'
```
