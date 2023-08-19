* Open CMD/Terminal on your Local Machine

- [ ] Generate SSH Key for New User so we could make its login passwordless
```
Syntax:- ssh-keygen -f C:\Users\Your_Local_Machine_User/.ssh/key_name -t ed25519
Syntax:- ssh-keygen -f C:\Users\R/.ssh/raj_ed25519 -t ed25519
```
* Above Command will generate two keys Private key raj_ed25519 and Public key raj_ed25519.pub in the given path
_**Copy SSH Public Key to Remote Server (Not for Windows)**_

```
Syntax:- ssh-copy-id -p PORT -i ~/.ssh/keyname.pub Remote_Server_Username@Remote_Server_Host_IP
Example:- ssh-copy-id -p 22 -i ~/.ssh/raj_ed25519.pub raj@216.32.44.12
```
_**Copy Public Key to Remote Server (for Windows)**_

- [ ] Make sure you have .ssh folder in remote server user's home directory
```
Syntax:- ssh -P PORT Remote_Server_Username@Remote_Server_Host_IP "mkdir /home/Remote_Server_Username/.ssh"
Example:- ssh -P 22 raj@216.32.44.12 "mkdir /home/raj/.ssh"
```
- [ ] Copy Public Key
```
Syntax:- scp -P PORT SSH_PUBLIC_KEY_PATH Remote_Server_Username@Remote_Server_Host_IP:/home/Remote_Server_Username/.ssh/authorized_keys
Example:- scp -P 22 C:\Users\R/.ssh\raj_ed25519.pub raj@216.32.44.12:/home/raj/.ssh/authorized_keys
```
