#!/usr/bin/env bash

# task variables
ansible_server_ip=$(hostname -I)
ansible_user_name=ansible
ansible_user_pass=redhat #and root password also
playbook_directory=/home/ansible/ansible

#windows section
inventory_directory_windows=/home/ansible/ansible/windows
host_directory_windows=/opt/ansible/inventory/windows
windows_roles_directory=/opt/ansible/roles/windows
windows_hosts=$host_directory_windows/hosts
windows_configfile=$inventory_directory_windows/ansible.cfg
windows_logfile=/var/log/ansible_windows.log

#Linux Section
inventory_directory_linux=/home/ansible/ansible/linux
host_directory_linux=/opt/ansible/inventory/linux
linux_roles_directory=/opt/ansible/roles/linux
linux_hosts=$host_directory_linux/hosts
linux_configfile=$inventory_directory_linux/ansible.cfg
linux_logfile=/var/log/ansible_linux.log

#Make host entry in localhost
if [ "$(hostname)" != "ansible-server" ];
then
    hostnamectl set-hostname ansible-server
fi

#selinux configuration

if [ $(cat /etc/selinux/config | grep dis | grep -v "#" | wc -l) -eq 0 ];
then
    sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config
fi

#Make host entry /etc/hosts

if [ $(cat /etc/hosts | grep ansible  | wc -l) -eq 0 ];
then
    echo "$ansible_server_ip ansible-server ansible"   >> /etc/hosts
fi

#Installtion packages List

for i in epel-release vim-enhanced  ansible wget curl sshpass curl zip unzip
do
	if [  $(rpm -qa | grep $i | wc -l) -eq 0 ];
    then
        yum install $i -q -y
    fi
done

# user create in ansible server

if [ $(id $ansible_user_name | wc -l) -eq 0 ];
then
    useradd -s /bin/bash ansible
    chown -R $ansible_user_name:$ansible_user_name /home/ansible
    echo "$ansible_user_pass" | passwd --stdin $ansible_user_name
fi

# Make user sudo entry

if [ $(egrep '^ansible|^NOPASSWD' /etc/sudoers | wc -l) -eq 0 ];
then
    echo "$ansible_user_name ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers;
fi

#Directory Create

for jino in $inventory_directory_windows $playbook_directory $host_directory_windows $host_directory_linux $inventory_directory_linux $linux_roles_directory $windows_roles_directory
do
	if [ ! -d "$jino" ];
	then
    	mkdir -p $jino
        if [ "$jino" = "$playbook_directory" ];
        then
            chown -R $ansible_user_name:$ansible_user_name $playbook_directory

		elif [ "$jino" = "$inventory_directory_linux" ];
		then
			chown -R $ansible_user_name:$ansible_user_name $inventory_directory_linux

		elif [ "$jino" = "$inventory_directory_windows" ];
		then
			chown -R $ansible_user_name:$ansible_user_name $inventory_directory_windows

        fi
	fi
done

#logfile creation

if [ ! -f "$linux_logfile" ];
then
    touch $linux_logfile
    chown -R $ansible_user_name:$ansible_user_name $linux_logfile
fi

if [ ! -f "$windows_logfile" ];
then
    touch $windows_logfile
    chown -R $ansible_user_name:$ansible_user_name $windows_logfile
fi

#windows configuration file

if [ ! -f "$windows_configfile" ];
then
cat <<EOF > $windows_configfile
[defaults]
inventory            = $windows_hosts
retry_files_enabled  = True
host_key_checking    = False
log_path             = $windows_logfile
command_warnings     = False
deprecation_warnings = False
roles_path           = $windows_roles_directory

#[privilege_escalation]
#become               = True
#become_method        = sudo
#become_user          = root
#become_ask_pass      = False

EOF
fi

#linux configuration file

if [ ! -f "$linux_configfile" ];
then
cat <<EOF > $linux_configfile
[defaults]
inventory            = $linux_hosts
retry_files_enabled  = True
host_key_checking    = False
log_path             = $linux_logfile
command_warnings     = False
deprecation_warnings = False
roles_path           = $linux_roles_directory

[privilege_escalation]
become               = True
become_method        = sudo
become_user          = root
become_ask_pass      = False
EOF
fi

#set linux host file sction

if [ ! -f "$linux_hosts" ];
then
cat <<EOF > $linux_hosts
localhost ansible_connection=local ansible_user=$ansible_user_name

[all:vars]
ansible_connection= ssh
EOF
fi


#set windows host file sction

if [ ! -f "$windows_hosts" ];
then
cat <<EOF > $windows_hosts
localhost ansible_connection=local ansible_user=$ansible_user_name

[windows]
windows_server ansible_host=xxx.xxx.xxx.xxx


[windows:vars]
ansible_user       = xxx.xxx.xxx.xxx
ansible_password   = password
ansible_connection = winrm
ansible_port       = 5986
ansible_winrm_server_cert_validation = ignore

EOF
fi

#file permission checks
chown -R $ansible_user_name:$ansible_user_name $playbook_directory

