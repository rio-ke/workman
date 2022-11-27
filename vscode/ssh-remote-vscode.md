# $$Remote-Development-Using-SSH$$

**_vscode-remote-ssh_**

![architecture-ssh](https://user-images.githubusercontent.com/88568938/204095826-8c030a76-049e-4cd8-bb69-fa4c4664da53.png)

**_connecting VM machine host_**

- Downloading ssh aplication in linux server
- Downloading remote-ssh in vscode extension
- Downlaoding remote-development in vscode extension
- Creating ssh key
- ssh configuration file edit in vscode

**_ssh downloading_**

`ubuntu`

```
sudo apt update
sudo apt install openssh-server
sudo systemctl status ssh
```

`centOS`

```bash
sudo yum –y install openssh-server openssh-clients
sudo systemctl start sshd
sudo systemctl status sshd
sudo systemctl enable sshd
```

**_vscode-remote-ssh_**

go to vscode click `Extension` option

Download `remote-ssh`

Download `remote-develpment`

**_Createing ssh keys_**

```bash
ssh-keygen
```

**keys**

- created in virtual machine

**_go to key conf file_**

```bash
cd ~/.ssh/
```

_if u create key with seperate file name_

- give file name as `public.pem` and `private.pem`
- go to /home/$user

```bash
ls -ltr | grep pem
```

**_conf work_**

