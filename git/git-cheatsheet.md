## _Git Cheatsheet_

**_Clone a Repository_**
```cmd
git clone <repository_url>
```
**_Stage Changes for Commit_**
```cmd
git add <file(s)>
```
**_Commit Changes_**
```cmd
git commit -m "Commit message"
```
**_Push Changes to the Remote Repository_**
```cmd
git push
```
**_Force Push Changes (use with caution)_**
```cmd
git push --force
```
**_Reset Working Directory to Last Commit_**
```cmd
git reset --hard
```
**_Create a New Branch_**
```cmd
git branch <branch_name>
```
**_Switch to a Different Branch_**
```cmd
git checkout <branch_name>
```
 Merge Changes from Another Branch
git merge <branch_name>

 Rebase Changes onto Another Branch (use with caution)
git rebase <base_branch>

 View Status of Working Directory
git status

 View Commit History
git log

 Undo Last Commit (use with caution)
git reset --soft HEAD^

 Discard Changes in Working Directory
git restore <file(s)>

 Retrieve Lost Commit References
git reflog

 Interactive Rebase to Rearrange Commits
git rebase --interactive HEAD~3


