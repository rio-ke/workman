# creating ansible.cfg file in local directory

* create folder for ansible.cfg in  ansible server in ubuntu server 

```cmd 
mkdir ansible
```

**Generating a sample `ansible.cfg` file**

* You can generate a fully commented-out example ansible.cfg file, for example:

```cmd
ansible-config init --disabled > ansible.cfg
```

* You can also have a more complete file that includes existing plugins:

_**ad-hoc command**_

```cmd
ansible-config init --disabled -t all > ansible.cfg
```

**_check the version and `cfg` file location_**

```cmd
ansible --version
```

_Now go to ansible.cfg file and edit inventory file path_

```bash
sudo vim ansible.cfg
```
Edit

```bash
# (pathlist) Comma separated list of Ansible inventory sources
inventory=/home/user/ansible/hosts
```

Now check hosts server 

**_Hosts_**

```bash
[myvirtualmachines]
192.168.0.104 ansible_connection=ssh ansible_ssh_user=server ansible_ssh_pass=.  #username #password
```
check hosts connection in terminal with ad-hoc command
```bash
ansible all --list-hosts
```
_ping host server_

```cmd
ansible -m ping all
```












