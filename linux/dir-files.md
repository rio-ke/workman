## create multiple dir's in one command in ubuntu 

```cmd
mkdir sa{1..50}
```
mkdir -p sa{1..50}/sax{1..50}
```
```
mkdir {a-z}12345 
```
mkdir {1,2,3}
```
mkdir test{01..10}
```
mkdir -p `date '+%y%m%d'`/{1,2,3} 
```
```cmd
mkdir -p $USER/{1,2,3} 
```

**files**

sudo touch file{1..50}.txt
sudo touch file{1,2,3,4}.txt
