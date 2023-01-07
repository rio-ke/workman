# List your shells in Linux

```cmd
cat /etc/shells
```
```md
/bin/sh
/bin/bash
/usr/bin/bash
/bin/rbash
/usr/bin/rbash
/bin/dash
/usr/bin/dash
/usr/bin/tmux
```

**Changing default sh shell to bash**

_Using usermod command_

* We are going to change the shell from /bin/sh to /bin/bash of user nishant using usermod command.

```cmd
sudo usermod --shell /bin/bash [user-name]
```
_check_

```cmd
grep `whoami` /etc/passwd
```
**Using chsh Utility**

```cmd
chsh -s /bin/bash nishant
```
