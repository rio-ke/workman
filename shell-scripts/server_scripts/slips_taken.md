## Script for taking or copy images from one server to another

```sh
#!/usr/bin/env bash
#set -x
# Already region dir created in /webdata/host/ location

echo "What region do you want to copy slips?"
read REGION
DIR="/webdata/host/$REGION"
if [ -e "$DIR" ]; then
    cat /var/scipts/radmus4.txt | while read -r LINE; do
        scp admin@192.168.5.204:/RADMUS/"$LINE" "$DIR"
    done

else  echo "Wrong folder,Try again!!"

fi

```
