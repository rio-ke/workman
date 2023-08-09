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

* If you have multiple SSH keys and repositories, you might need to configure your SSH config file (~/.ssh/config) to specify which key to use for a specific host

```javascript
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/my_new_key
```
Then clone ssh repo

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
