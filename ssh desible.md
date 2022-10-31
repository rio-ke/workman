# OpenSSH Server Configuration


Properly configuring the sshd configuration file hardens server security. 
The most common settings to enhance security are changing the port number, disabling root logins, and limiting access to only certain users.

**To edit these settings access the /etc/ssh/sshd_config file:**
```
sudo vim /etc/ssh/sshd_config
```
Once you access the file by using a text editor (in this example we used vim), you can disable root logins and edit the default port number:

**To disable root login:**
```bash
PermitRootLogin no
```

_Change the SSH port to run on a non-standard port. For example:_

remember to uncomment the lines that you edit by removing the hashtag.

[Config image]![Screenshot from 2022-10-31 15-26-07](https://user-images.githubusercontent.com/88568938/198981503-fc402e58-147f-4c00-8779-ca9f973a5dca.png)

Save and close the file. Restart sshd:
```bash
service sshd restart
```
