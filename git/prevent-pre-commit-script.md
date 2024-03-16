**_Script_**

```bash
# Replace BRANCH_NAME with your branch name (i.e. main, master, dev, uat)
# If you want to use multiple branches, implement the code below multiple times with different branch names (i.e. one for main, one for dev, one for uat).

# Branch
branch="$(git rev-parse --abbrev-ref HEAD)"

echo ""
echo "Current Branch: $branch"
echo ""

if [ "$branch" = "BRANCH_NAME" ]; then
  echo "You can't commit directly to the $branch branch"
  exit 1
fi

echo "You can commit directly to the $branch branch"
```
