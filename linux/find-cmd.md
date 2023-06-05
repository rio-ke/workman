**_Find command to search files and directroy_**

_To find grafana_file in root dir_
```cmd
find / -iname grafana
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
