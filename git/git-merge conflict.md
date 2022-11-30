# Git auto-merging

**_Error_**


![merging-conflict-error](https://user-images.githubusercontent.com/88568938/204776902-8f37ec68-1314-4bb8-9729-1fa64d696164.png)

Below is a sample procedure using vimdiff to resolve merge conflicts, based on this link.

Run the following commands in your terminal
```bash
git config merge.tool vimdiff
git config merge.conflictstyle diff3
git config mergetool.prompt false
```

*This will set vimdiff as the default merge tool.*


***Run the following command in your terminal***

```bash
git mergetool
```

*You will see a vimdiff display in the following format:*



![Screenshot from 2022-11-30 16-14-13](https://user-images.githubusercontent.com/88568938/204776329-62a09d6a-3fd0-4f8f-af79-bbcb98b1793c.png)



**These 4 views are**

* LOCAL: this is the file from the current branch
* BASE: the common ancestor, how this file looked before both changes
* REMOTE: the file you are merging into your branch
* MERGED: the merge result; this is what gets saved in the merge commit and used in the future

* You can navigate among these views using `ctrl+w`. You can directly reach the MERGED view using `ctrl+w` followed by j.

* More information about `vimdiff` navigation is here and here.

* You can edit the `MERGED` view like this:


**If you want to get changes from REMOTE**    

*in keyboard click `Esc` then `shift+:`

```bash
diffg RE
```

**If you want to get changes from BASE**

```bash
diffg BA
```
**If you want to get changes from LOCAL**

```bash
diffg LO
```

* Save, Exit, Commit, and Clean up

*  :wq! save and exit from vi

***after git command***

```bash
git commit -m "message"
```

* git clean Remove extra files (e.g. *.orig). Warning: It will remove all untracked files, if you won't pass any arguments.
