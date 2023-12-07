**_To free up the buff/cache_**

_To free pagecache:_

```cmd
echo 1 > /proc/sys/vm/drop_caches
```

_To free dentries and inodes:_

```cmd
echo 2 > /proc/sys/vm/drop_caches
```

_To free pagecache, dentries and inodes:_

```cmd
echo 3 > /proc/sys/vm/drop_caches
```

_Or with this command 👈

```cmd
free && sync && echo 3 > /proc/sys/vm/drop_caches && free
```

_To run command as a user(non-root)_

```cmd
sudo sh -c 'echo 1 > /proc/sys/vm/drop_caches'

```
_run command as a root user_

```bash
su -c "echo 3 > '/proc/sys/vm/drop_caches' && swapoff -a && swapon -a && printf '\n%s\n' 'Ram-cache and Swap Cleared'" root
```


_To check the RAM_

```cmd 
free -h
```
