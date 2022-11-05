# OpenSSH Server Configuration

**_Install OpenSSH Server Software Package_**


* Enter the following command from your terminal to start the installation process:
```bash
sudo yum –y install openssh-server openssh-clients
```

**Starting SSH Service**

* To start the SSH daemon on the OpenSSH server:
```bsh
sudo systemctl start sshd
```

_**Check the status of the SSH daemon:**_

```bash
sudo systemctl status sshd
```

**_Enable OpenSSH Service_**


* Enable SSH to start automatically after each system reboot by using the systemctl command:
```bash
sudo systemctl enable sshd
```

**To disable SSH after reboot enter:**


```bash
sudo systemctl disable sshd
```

* Properly configuring the sshd configuration file hardens server security. The most common settings to enhance security are changing the port number, disabling root logins, and limiting access to only certain users.

**To edit these settings access the /etc/ssh/sshd_config file:**

```bash
sudo vim /etc/ssh/sshd_config
```


* Once you access the file by using a text editor (in this example we used vim), you can disable root logins and edit the default port number:



**To disable root login:**

```bash
PermitRootLogin no
```

**_Change the SSH port to run on a non-standard port. For example:_**


* remember to uncomment the lines that you edit by removing the hashtag.
[Config image]![Screenshot from 2022-10-31 15-26-07](https://user-images.githubusercontent.com/88568938/198981503-fc402e58-147f-4c00-8779-ca9f973a5dca.png)


**_Save and close the file. Restart sshd:_**

```bash
service sshd restart
```


**To stop the SSH daemon enter:**

```bash
systemctl stop sshd
```





### reference sites

1) [ssh-config file]https://linuxhint.com/ssh-config-file/
2) [shh-key grnerate](https://confluence.atlassian.com/bitbucketserver/creating-ssh-keys-776639788.html)







