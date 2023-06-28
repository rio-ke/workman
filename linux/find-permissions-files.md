shell script that finds the file permissions of files under the /home directory in Ubunt

```bash
#!/bin/bash

# Find file permissions of files under /home
find /home -type f -exec ls -l {} \; | awk '{print $1, $NF}'
```
shell script that finds files with permissions set to 777 under the /home directory

```bash
#!/bin/bash

# Find files with 777 permissions under /home
find /home -type f -perm 777
```
find Chmod permission numbers for files

```cmd
stat -c "%a %n" ~/Downloads
```


