**_Find command to search files and directroy_**

_To find grafana_file in root dir_
```cmd
find / -iname grafana
```
```cmd
find /file/to/path -type f -name "file-name"
```

_Find older file details in current_dir_

```cmd
sudo find . -type f -exec stat --format='%Y %n' {} \; | sort -n | head -n 1
```
_Find stats about files_

```cmd
stat -c "%n %y" ./file_name
```

_To find newer file_

```cmd
find . -newer new_file.txt
```

_To finding files by type_

- Some of the file types are as follows:
* f: regular file
* d: directory
* l: symbolic links
* c: character devices
* b: block devices
```cmd
find . -type d -name "*.bak"
```


