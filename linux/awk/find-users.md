# find /bin/bash/sh users using awk command

**_/bin/bash_**
```cmd
grep /bin/bash /etc/passwd | awk -F: '{ print $1 }'
```

**_/bin/sh_**

````cmd
grep /bin/sh /etc/passwd | awk -F: '{ print $1 }'
````
