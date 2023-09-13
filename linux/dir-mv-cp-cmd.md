
```bash
# Navigate to the main directory
cd /path/to/main_dir

# Create the destination_subdir if it doesn't already exist
mkdir -p destination_subdir

# Copy files from the main directory to destination_subdir
cp * destination_subdir/

# Move the five subdirectories into destination_subdir
mv subdir1 subdir2 subdir3 subdir4 subdir5 destination_subdir/
```

_revert_

```bash
# Move the five subdirectories back to the main directory
mv destination_subdir/subdir1 destination_subdir/subdir2 destination_subdir/subdir3 destination_subdir/subdir4 destination_subdir/subdir5 .

# Move all files back to the main directory
mv destination_subdir/* .

# Remove the empty destination_subdir
rmdir destination_subdir
```
