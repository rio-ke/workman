To delete only files in the /tmp directory that exceed a certain size (e.g., 1 GB)
---

```bash
#!/bin/bash

# Set the threshold size in bytes (e.g., 1 GB = 1073741824 bytes)
threshold_size=1073741824

# Find files in /tmp that exceed the threshold size and delete them
find /tmp -type f -size +${threshold_size}c -delete

```
