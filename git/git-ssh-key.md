# Add ssh key to clone git repository from github to local server

- first create ssh key in local server

```git
ssh-keygen
```

- find key in local server folder

```git
cd ~/.ssh/
```

find public key in local server folder

```git
cat ~/.ssh/id_rsa.pub
```

- copy the public key and go to git repository settings folder

- then `settings` go to general

- click `Deploy keys`

* and click `add deploy key`

_**for deploy keys**_

- give Tittle

- paste public key into `key`

- allow write access

- then `add key`

**After making ssh-key generation**

_go to clone repository link_

[git-clone](https://github.com/rio-ke/linux-learn/blob/main/git/git-clone.md)
