AWK
---

* If you have 10 lines and to print 2nd row s first colume

```cmd
awk 'NR==2row {print $colume}' file_name
```
```cmd
awk 'NR==2 {print $1}' file
```
* To pint first two coloumes in 2nd row
```cmd
awk 'NR==4 {print $1, $2}' file
```

* To print rows that's containing more than 50 letters
```cmd
awk 'length > 50' file
```
