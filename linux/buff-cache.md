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
