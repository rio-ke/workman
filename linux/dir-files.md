## create multiple dir's in one command in ubuntu 

```cmd
mkdir sa{1..50}
```
```cmd
mkdir -p sa{1..50}/sax{1..50}
```
```cmd
mkdir {a-z}12345 
```
```cmd
mkdir {1,2,3}
```
```cmd
mkdir test{01..10}
```
```cmd
mkdir -p `date '+%y%m%d'`/{1,2,3} 
```
```cmd
mkdir -p $USER/{1,2,3} 
```

**files**

```cmd
sudo touch file{1..50}.txt
```
```cmd
sudo touch file{1,2,3,4}.txt
```
