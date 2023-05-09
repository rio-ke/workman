#!/usr/bin/env bash
#variable section
client_name=Skylark
from_address=navaneethan@skylarkinfo.com
to_address=navaneethan@skylarkinfo.com,selva@skylarkinfo.com,training@cloudnloud.com,darmesh@skylarkinfo.com
username=navaneethan@skylarkinfo.com
password=tn09bk1329
subject1=$client_name-Critical-Disk_Space-Alert
subject2=$client_name-Warning-2-Disk_Space-Alert
subject3=$client_name-Warning-1-Disk_Space-Alert
gmail_gateway=smtp.gmail.com:587
body_text=/tmp/mailbody_disk.txt

#OS section
redhat_os_type=$(cat /etc/redhat-release | awk '{print $1$2}')
ubuntu_os_type=$(lsb_release -d | awk '{print $2}')
cent_os_type=$(cat /etc/redhat-release  | grep -iw centos | awk '{print $1}')
suse_os_type=$(lsb_release -a | grep SUSE | head -n1 | awk '{print $3}')


#RedHat Disk Alert

if [ "$redhat_os_type" == RedHat ];
then

#Tasks-1 install Mailx if not installed
if [  $(rpm -qa | grep mailx | wc -l) -eq 0 ];
then
    yum install mailx -q -y
fi

#Task-2 check Memory Usage

df -PkH | egrep -vE 'loop|tmpfs|Filesystem' | awk '{ print $5 " " $1 " " $6 }'  | while read output;
do
  used=$(echo $output | awk '{ print $1}' | cut -d'%' -f1  )
  partition=$(echo $output | awk '{ print $2 }' )
  mount_name=$(echo $output | awk '{ print $3 }' )


  if [ $used -ge 80 ]; then
      echo " The Partition: \"$partition\" on $(hostname) has used \"$mount_name\" - $used% at $(date +%Y:%M:%d-%H:%M)" > $body_text
      mailx -v -r "$from_address" -s "$subject1" -S smtp="$gmail_gateway" -S smtp-use-starttls -S smtp-auth=login -S smtp-auth-user="$username" -S smtp-auth-password="$password" -S ssl-verify=ignore $to_address < $body_text

  elif [ $used -ge 75 ]; then
      echo " The Partition: \"$partition\" on $(hostname) has used \"$mount_name\" - $used% at $(date +%Y:%M:%d-%H:%M)" > $body_text
      mailx -v -r "$from_address" -s "$subject2" -S smtp="$gmail_gateway" -S smtp-use-starttls -S smtp-auth=login -S smtp-auth-user="$username" -S smtp-auth-password="$password" -S ssl-verify=ignore $to_address < $body_text
  elif [ $used -ge 70 ]; then
      echo " The Partition: \"$partition\" on $(hostname) has used \"$mount_name\" - $used% at $(date +%Y:%M:%d-%H:%M)" > $body_text
      mailx -v -r "$from_address" -s "$subject3" -S smtp="$gmail_gateway" -S smtp-use-starttls -S smtp-auth=login -S smtp-auth-user="$username" -S smtp-auth-password="$password" -S ssl-verify=ignore $to_address < $body_text

  fi
done

#Centos Disk Alert

elif [ "$cent_os_type" == CentOS ];
then

#Tasks-1 install sendemail if not installed
if [  $(rpm -qa | grep mailx | wc -l) -eq 0 ];
then
    yum install mailx -q -y
fi

#Task-2 check Memory Usage
df -PkH | egrep -vE 'loop|tmpfs|Filesystem' | awk '{ print $5 " " $1 " " $6 }'  | while read output;
do
  used=$(echo $output | awk '{ print $1}' | cut -d'%' -f1  )
  partition=$(echo $output | awk '{ print $2 }' )
  mount_name=$(echo $output | awk '{ print $3 }' )

  if [ $used -ge 80 ]; then
      echo " The Partition: \"$partition\" on $(hostname) has used \"$mount_name\" - $used% at $(date +%Y:%M:%d-%H:%M)" > $body_text
      mailx -v -r "$from_address" -s "$subject1" -S smtp="$gmail_gateway" -S smtp-use-starttls -S smtp-auth=login -S smtp-auth-user="$username" -S smtp-auth-password="$password" -S ssl-verify=ignore -S nss-config-dir="/etc/pki/nssdb/" $to_address < $body_text

  elif [ $used -ge 75 ]; then
      echo " The Partition: \"$partition\" on $(hostname) has used \"$mount_name\" - $used% at $(date +%Y:%M:%d-%H:%M)" > $body_text
      mailx -v -r "$from_address" -s "$subject2" -S smtp="$gmail_gateway" -S smtp-use-starttls -S smtp-auth=login -S smtp-auth-user="$username" -S smtp-auth-password="$password" -S ssl-verify=ignore -S nss-config-dir="/etc/pki/nssdb/" $to_address < $body_text

  elif [ $used -ge 70 ]; then
      echo " The Partition: \"$partition\" on $(hostname) has used \"$mount_name\" - $used% at $(date +%Y:%M:%d-%H:%M)" > $body_text
      mailx -v -r "$from_address" -s "$subject3" -S smtp="$gmail_gateway" -S smtp-use-starttls -S smtp-auth=login -S smtp-auth-user="$username" -S smtp-auth-password="$password" -S ssl-verify=ignore -S nss-config-dir="/etc/pki/nssdb/" $to_address < $body_text

  fi
done


elif [ "$ubuntu_os_type" == Ubuntu  ];
then

#Tasks-1 install sendemail if not installed
if [  $(dpkg -l | grep heirloom-mailx | wc -l) -eq 0 ];
then
    apt install heirloom-mailx -q -y
fi

#Task-2 check Memory Usage
df -PkH | egrep -vE 'loop|tmpfs|Filesystem' | awk '{ print $5 " " $1 " " $6 }'  | while read output;
do
  used=$(echo $output | awk '{ print $1}' | cut -d'%' -f1  )
  partition=$(echo $output | awk '{ print $2 }' )
  mount_name=$(echo $output | awk '{ print $3 }' )

  if [ $used -ge 80 ]; then
      echo " The Partition: \"$partition\" on $(hostname) has used \"$mount_name\" - $used% at $(date +%Y:%M:%d-%H:%M)" > $body_text
      mailx -v -r "$from_address" -s "$subject1" -S smtp="$gmail_gateway" -S smtp-use-starttls -S smtp-auth=login -S smtp-auth-user="$username" -S smtp-auth-password="$password" -S ssl-verify=ignore $to_address < $body_text
  
  elif [ $used -ge 75 ]; then
      echo " The Partition: \"$partition\" on $(hostname) has used \"$mount_name\" - $used% at $(date +%Y:%M:%d-%H:%M)" > $body_text
      mailx -v -r "$from_address" -s "$subject2" -S smtp="$gmail_gateway" -S smtp-use-starttls -S smtp-auth=login -S smtp-auth-user="$username" -S smtp-auth-password="$password" -S ssl-verify=ignore $to_address < $body_text

  elif [ $used -ge 70 ]; then
      echo " The Partition: \"$partition\" on $(hostname) has used \"$mount_name\" - $used% at $(date +%Y:%M:%d-%H:%M)" > $body_text
      mailx -v -r "$from_address" -s "$subject3" -S smtp="$gmail_gateway" -S smtp-use-starttls -S smtp-auth=login -S smtp-auth-user="$username" -S smtp-auth-password="$password" -S ssl-verify=ignore $to_address < $body_text

  fi
done

#SUSE Disk Alert

elif [ "$suse_os_type" == SUSE ];
then

#Tasks-1 install sendemail if not installed
if [  $(rpm -qa | grep mailx | wc -l) -eq 0 ];
then
    zypper install mailx -q -y
fi

#Task-2 check Memory Usage

df -PkH | egrep -vE 'loop|tmpfs|Filesystem' | awk '{ print $5 " " $1 " " $6 }'  | while read output;
do
  used=$(echo $output | awk '{ print $1}' | cut -d'%' -f1  )
  partition=$(echo $output | awk '{ print $2 }' )
  mount_name=$(echo $output | awk '{ print $3 }' )


  if [ $used -ge 80 ]; then
      echo " The Partition: \"$partition\" on $(hostname) has used \"$mount_name\" - $used% at $(date +%Y:%M:%d-%H:%M)" > $body_text
      mailx -v -r "$from_address" -s "$subject1" -S smtp="$gmail_gateway" -S smtp-use-starttls -S smtp-auth=login -S smtp-auth-user="$username" -S smtp-auth-password="$password" -S ssl-verify=ignore $to_address < $body_text

  elif [ $used -ge 75 ]; then
      echo " The Partition: \"$partition\" on $(hostname) has used \"$mount_name\" - $used% at $(date +%Y:%M:%d-%H:%M)" > $body_text
      mailx -v -r "$from_address" -s "$subject1" -S smtp="$gmail_gateway" -S smtp-use-starttls -S smtp-auth=login -S smtp-auth-user="$username" -S smtp-auth-password="$password" -S ssl-verify=ignore $to_address < $body_text

  elif [ $used -ge 70 ]; then
      echo " The Partition: \"$partition\" on $(hostname) has used \"$mount_name\" - $used% at $(date +%Y:%M:%d-%H:%M)" > $body_text
      mailx -v -r "$from_address" -s "$subject1" -S smtp="$gmail_gateway" -S smtp-use-starttls -S smtp-auth=login -S smtp-auth-user="$username" -S smtp-auth-password="$password" -S ssl-verify=ignore $to_address < $body_text

  fi
done
fi
