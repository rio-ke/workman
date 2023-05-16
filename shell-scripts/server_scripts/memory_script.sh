#!/usr/bin/env bash
#variable section
client_name=Skylark
from_address=navaneethan@skylarkinfo.com
to_address=navaneethan@skylarkinfo.com,selva@skylarkinfo.com,training@cloudnloud.com,darmesh@skylarkinfo.com
username=navaneethan@skylarkinfo.com
password=tn09bk1329
subject1=$client_name-Critical-Memory-Alert
subject2=$client_name-Warning-2-Memory-Alert
subject3=$client_name-Warning-1-Memory-Alert
gmail_gateway=smtp.gmail.com:587
body_text=/tmp/mailbody_mem.txt

#OS section
redhat_os_type=$(cat /etc/redhat-release | awk '{print $1$2}')
ubuntu_os_type=$(lsb_release -d | awk '{print $2}')
cent_os_type=$(cat /etc/redhat-release  | grep -iw centos | awk '{print $1}')
suse_os_type=$(lsb_release -a | grep SUSE | head -n1 | awk '{print $3}')

#Memory Calculation
memory=`free -m | awk 'NR==2{printf "%.2f%%\t\t", $3*100/$2 }' | awk -F . '{print $1}'`
memory_precentage=`free -m | awk 'NR==2{printf "Memory Usage: %s/%sMB (%.2f%%)\n", $3,$2,$3*100/$2 }'`


#Tasks-1 install Mailx if not installed

if [ "$redhat_os_type" == RedHat ];
then

if [  $(rpm -qa | grep mailx | wc -l) -eq 0 ];
then
    yum install mailx -q -y
fi

#Task-2 check Memory Usage

if [ $memory -gt 80 ];
then
  echo "server name: $(hostname) - Memory usage in Intermidiate state - $memory_precentage" >  $body_text
  mailx -v -r "$from_address" -s "$subject1" -S smtp="$gmail_gateway" -S smtp-use-starttls -S smtp-auth=login -S smtp-auth-user="$username" -S smtp-auth-password="$password" -S ssl-verify=ignore $to_address < $body_text

elif [ $memory -gt 75 ];
then
    echo "server name: $(hostname) - Memory usage in Intermidiate state - $memory_precentage" > $body_text
    mailx -v -r "$from_address" -s "$subject2" -S smtp="$gmail_gateway" -S smtp-use-starttls -S smtp-auth=login -S smtp-auth-user="$username" -S smtp-auth-password="$password" -S ssl-verify=ignore $to_address < $body_text

elif [ $memory -gt 70 ];
then
  echo "server name: $(hostname) - Memory usage in Intermidiate state - $memory_precentage" > $body_text
  mailx -v -r "$from_address" -s "$subject3" -S smtp="$gmail_gateway" -S smtp-use-starttls -S smtp-auth=login -S smtp-auth-user="$username" -S smtp-auth-password="$password" -S ssl-verify=ignore $to_address < $body_text

fi

#Tasks-1 install Mailx if not installed
elif [ "$cent_os_type" == CentOS ];
then

if [  $(rpm -qa | grep mailx | wc -l) -eq 0 ];
then
    yum install mailx -q -y
fi

#Task-2 check Memory Usage
if [ $memory -gt 80 ];
then
    echo "server name: $(hostname) - Memory usage in Intermidiate state - $memory_precentage" > $body_text
    mailx -v -r "$from_address" -s "$subject1" -S smtp="$gmail_gateway" -S smtp-use-starttls -S smtp-auth=login -S smtp-auth-user="$username" -S smtp-auth-password="$password" -S ssl-verify=ignore -S nss-config-dir="/etc/pki/nssdb/" $to_address < $body_text

elif [ $memory -gt 75 ];
then
    echo "server name: $(hostname) - Memory usage in Intermidiate state - $memory_precentage" > $body_text
    mailx -v -r "$from_address" -s "$subject2" -S smtp="$gmail_gateway" -S smtp-use-starttls -S smtp-auth=login -S smtp-auth-user="$username" -S smtp-auth-password="$password" -S ssl-verify=ignore -S nss-config-dir="/etc/pki/nssdb/" $to_address < $body_text

elif [ $memory -gt 70 ];
then
    echo "server name: $(hostname) - Memory usage in Intermidiate state - $memory_precentage" > $body_text
    mailx -v -r "$from_address" -s "$subject3" -S smtp="$gmail_gateway" -S smtp-use-starttls -S smtp-auth=login -S smtp-auth-user="$username" -S smtp-auth-password="$password" -S ssl-verify=ignore -S nss-config-dir="/etc/pki/nssdb/" $to_address < $body_text

fi

#Tasks-1 install mailx if not installed
elif [ "$ubuntu_os_type" == Ubuntu  ];
then

if [  $(dpkg -l | grep heirloom-mailx | wc -l) -eq 0 ];
then
    apt install heirloom-mailx -q -y
fi

#Task-2 check Memory Usage
if [ $memory -gt 80 ];
then
    echo "server name: $(hostname) - Memory usage in Intermidiate state - $memory_precentage" > $body_text
    mailx -v -r "$from_address" -s "$subject1" -S smtp="$gmail_gateway" -S smtp-use-starttls -S smtp-auth=login -S smtp-auth-user="$username" -S smtp-auth-password="$password" -S ssl-verify=ignore $to_address < $body_text 

elif [ $memory -gt 75 ];
then
    echo "server name: $(hostname) - Memory usage in Intermidiate state - $memory_precentage" > $body_text
    mailx -v -r "$from_address" -s "$subject2" -S smtp="$gmail_gateway" -S smtp-use-starttls -S smtp-auth=login -S smtp-auth-user="$username" -S smtp-auth-password="$password" -S ssl-verify=ignore $to_address < $body_text

elif [ $memory -gt 70 ];
then
    echo "server name: $(hostname) - Memory usage in Intermidiate state - $memory_precentage" > $body_text
    mailx -v -r "$from_address" -s "$subject3" -S smtp="$gmail_gateway" -S smtp-use-starttls -S smtp-auth=login -S smtp-auth-user="$username" -S smtp-auth-password="$password" -S ssl-verify=ignore $to_address < $body_text

fi

#Tasks-1 install mailx if not installed

elif [ "$suse_os_type" == SUSE ];then

if [  $(rpm -qa | grep mailx | wc -l) -eq 0 ];then
    zypper install mailx -q -y
fi

#Task-2 check Memory Usage
if [ $memory -gt 80 ];
then
    echo "server name: $(hostname) - Memory usage in Intermidiate state - $memory_precentage" >  $body_text
    mailx -v -r "$from_address" -s "$subject1" -S smtp="$gmail_gateway" -S smtp-use-starttls -S smtp-auth=login -S smtp-auth-user="$username" -S smtp-auth-password="$password" -S ssl-verify=ignore $to_address < $body_text

elif [ $memory -gt 75 ];
then
     echo "server name: $(hostname) - Memory usage in Intermidiate state - $memory_precentage" > $body_text
     mailx -v -r "$from_address" -s "$subject2" -S smtp="$gmail_gateway" -S smtp-use-starttls -S smtp-auth=login -S smtp-auth-user="$username" -S smtp-auth-password="$password" -S ssl-verify=ignore $to_address < $body_text

elif [ $memory -gt 70 ];
then
    echo "server name: $(hostname) - Memory usage in Intermidiate state - $memory_precentage" > $body_text
    mailx -v -r "$from_address" -s "$subject3" -S smtp="$gmail_gateway" -S smtp-use-starttls -S smtp-auth=login -S smtp-auth-user="$username" -S smtp-auth-password="$password" -S ssl-verify=ignore $to_address < $body_text
fi
fi

