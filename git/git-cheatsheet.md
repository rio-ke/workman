Git Cheatsheet
# Clone a Repository
git clone <repository_url>

# Stage Changes for Commit
git add <file(s)>

# Commit Changes
git commit -m "Commit message"

# Push Changes to the Remote Repository
git push

# Force Push Changes (use with caution)
git push --force

# Reset Working Directory to Last Commit
git reset --hard

# Create a New Branch
git branch <branch_name>

# Switch to a Different Branch
git checkout <branch_name>

# Merge Changes from Another Branch
git merge <branch_name>

# Rebase Changes onto Another Branch (use with caution)
git rebase <base_branch>

# View Status of Working Directory
git status

# View Commit History
git log

# Undo Last Commit (use with caution)
git reset --soft HEAD^

# Discard Changes in Working Directory
git restore <file(s)>

# Retrieve Lost Commit References
git reflog

# Interactive Rebase to Rearrange Commits
git rebase --interactive HEAD~3
