shell script that finds the file permissions of files under the /home directory in Ubunt

```bash
#!/bin/bash

# Find file permissions of files under /home
find /home -type f -exec ls -l {} \; | awk '{print $1, $NF}'
```

