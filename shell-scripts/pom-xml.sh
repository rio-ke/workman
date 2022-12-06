pom.xml

model version: 4.0.0
artifiid : sjsj
version: 1.0

```bash
#!/usr/bin/env bash

#set -x

path=/home/kendanic/tmp/pom.xml

awk 'NR >= 5 && NR <= 8 {print $1}' $path

#grep -n "version" | awk '{print $1}'  $path

```

```diff
perl -lne 'if(/>[^<]*</){$_=~m/>([^<]*)</;push(@a,$1)}if(eof){foreach(@a){print $_}}' pom.xml

dt=$(awk -F '[<>]' '/artifactId/{print $3}' pom.xml)
$ echo $dt

I suggest you use a proper xml processing tool, like xmllint.

$ dt=$(xmllint --shell file <<< "cat //IntrBkSttlmDt/text()" | grep -v "^/ >")
$ echo $dt
1967-08-13
```

```bash
#!/usr/bin/env bash

#set -x

path=/home/kendanic/tmp/pom.xml

dt=$(awk -F '[<>]' '/artifactId/{print $3}' $path)

echo $dt
```

