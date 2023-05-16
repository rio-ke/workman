#!/usr/bin/env bash
#variable section
client_name=Skylark
from_address=navaneethan@skylarkinfo.com
to_address=navaneethan@skylarkinfo.com,selva@skylarkinfo.com,training@cloudnloud.com,darmesh@skylarkinfo.com
username=navaneethan@skylarkinfo.com
password=tn09bk1329
subject1=$client_name-Critical-CPU-Alert
subject2=$client_name-Warning-2-CPU-Alert
subject3=$client_name-Warning-1-CPU-Alert
gmail_gateway=smtp.gmail.com:587
body_text=/tmp/mailbody_cpu.txt

# OS section
redhat_os_type=$(cat /etc/redhat-release | awk '{print $1$2}')
ubuntu_os_type=$(lsb_release -d | awk '{print $2}')
cent_os_type=$(cat /etc/redhat-release  | grep -iw centos | awk '{print $1}')
suse_os_type=$(lsb_release -a | grep SUSE | head -n1 | awk '{print $3}')

# Calculate CPU section
cpu=`top -bn1 | grep load | awk '{printf "%.2f%%\t\t\n", $(NF-2)}' | awk -F . '{print $1}'`
cpu_core=`grep -c ^processor /proc/cpuinfo`
cpu_precentage=`top -bn1 | grep load | awk '{printf "CPU Load: %.2f\n", $(NF-2)}'`

if [ "$redhat_os_type" == RedHat ];
then

if [  $(rpm -qa | grep mailx | wc -l) -eq 0 ];
then
    yum install mailx -q -y
fi

if [ $cpu -gt 80 ];
then
    echo "server name: $(hostname) - CPU ($cpu_core core) Usage in Critical State - $cpu_precentage" > $body_text
    mailx -v -r "$from_address" -s "$subject1" -S smtp="$gmail_gateway" -S smtp-use-starttls -S smtp-auth=login -S smtp-auth-user="$username" -S smtp-auth-password="$password" -S ssl-verify=ignore $to_address < $body_text
elif [ $cpu -gt 75 ];
then
    echo "server name: $(hostname) - CPU ($cpu_core core) Usage in Warning - II State - $cpu_precentage" > $body_text
    mailx -v -r "$from_address" -s "$subject2" -S smtp="$gmail_gateway" -S smtp-use-starttls -S smtp-auth=login -S smtp-auth-user="$username" -S smtp-auth-password="$password" -S ssl-verify=ignore $to_address < $body_text
elif [ $cpu -gt 70 ];
then
    echo "server name: $(hostname) - CPU ($cpu_core core) in Warning - I State - $cpu_precentage" > $body_text
    mailx -v -r "$from_address" -s "$subject3" -S smtp="$gmail_gateway" -S smtp-use-starttls -S smtp-auth=login -S smtp-auth-user="$username" -S smtp-auth-password="$password" -S ssl-verify=ignore $to_address < $body_text
fi

elif [ "$cent_os_type" == CentOS ];
then

if [  $(rpm -qa | grep mailx | wc -l) -eq 0 ];
then
    yum install mailx -q -y
fi

if [ $cpu -gt 80 ];
then
    echo "server name: $(hostname) - CPU ($cpu_core core) Usage in Critical State - $cpu_precentage" > $body_text
    mailx -v -r "$from_address" -s "$subject3" -S smtp="$gmail_gateway" -S smtp-use-starttls -S smtp-auth=login -S smtp-auth-user="$username" -S smtp-auth-password="$password" -S ssl-verify=ignore -S nss-config-dir="/etc/pki/nssdb/" $to_address < $body_text

elif [ $cpu -gt 75 ];
then
    echo "server name: $(hostname) - CPU ($cpu_core core) Usage in Warning - II State - $cpu_precentage" > $body_text
    mailx -v -r "$from_address" -s "$subject3" -S smtp="$gmail_gateway" -S smtp-use-starttls -S smtp-auth=login -S smtp-auth-user="$username" -S smtp-auth-password="$password" -S ssl-verify=ignore -S nss-config-dir="/etc/pki/nssdb/" $to_address < $body_text

elif [ $cpu -gt 70 ];
then
    echo "server name: $(hostname) - CPU ($cpu_core core) in Warning - I State - $cpu_precentage" > $body_text
    mailx -v -r "$from_address" -s "$subject3" -S smtp="$gmail_gateway" -S smtp-use-starttls -S smtp-auth=login -S smtp-auth-user="$username" -S smtp-auth-password="$password" -S ssl-verify=ignore -S nss-config-dir="/etc/pki/nssdb/" $to_address < $body_text

fi

elif [ "$ubuntu_os_type" == Ubuntu  ];
then

if [  $(dpkg -l | grep heirloom-mailx | wc -l) -eq 0 ];
then
    apt install heirloom-mailx -q -y
fi

if [ $cpu -gt 80 ];
then
    echo "server name: $(hostname) - CPU ($cpu_core core) Usage in Critical State - $cpu_precentage" > $body_text
    mailx -v -r "$from_address" -s "$subject1" -S smtp="$gmail_gateway" -S smtp-use-starttls -S smtp-auth=login -S smtp-auth-user="$username" -S smtp-auth-password="$password" -S ssl-verify=ignore $to_address < $body_text

elif [ $cpu -gt 75 ];
then
    echo "server name: $(hostname) - CPU ($cpu_core core) Usage in Warning - II State - $cpu_precentage" > $body_text
    mailx -v -r "$from_address" -s "$subject2" -S smtp="$gmail_gateway" -S smtp-use-starttls -S smtp-auth=login -S smtp-auth-user="$username" -S smtp-auth-password="$password" -S ssl-verify=ignore $to_address < $body_text

elif [ $cpu -gt 70 ];
then
    echo "server name: $(hostname) - CPU ($cpu_core core) in Warning - I State - $cpu_precentage" > $body_text
    mailx -v -r "$from_address" -s "$subject3" -S smtp="$gmail_gateway" -S smtp-use-starttls -S smtp-auth=login -S smtp-auth-user="$username" -S smtp-auth-password="$password" -S ssl-verify=ignore $to_address < $body_text
fi

elif [ "$suse_os_type" == SUSE ];
then

if [  $(rpm -qa | grep mailx | wc -l) -eq 0 ];
then
    zypper install mailx -q -y
fi

if [ $cpu -gt 80 ];
then
    echo "server name: $(hostname) - CPU ($cpu_core core) Usage in Critical State - $cpu_precentage" > $body_text
    mailx -v -r "$from_address" -s "$subject1" -S smtp="$gmail_gateway" -S smtp-use-starttls -S smtp-auth=login -S smtp-auth-user="$username" -S smtp-auth-password="$password" -S ssl-verify=ignore $to_address < $body_text

elif [ $cpu -gt 75 ];
then
    echo "server name: $(hostname) - CPU ($cpu_core core) Usage in Warning - II State - $cpu_precentage" > $body_text
    mailx -v -r "$from_address" -s "$subject2" -S smtp="$gmail_gateway" -S smtp-use-starttls -S smtp-auth=login -S smtp-auth-user="$username" -S smtp-auth-password="$password" -S ssl-verify=ignore $to_address < $body_text

elif [ $cpu -gt 70 ];
then
    echo "server name: $(hostname) - CPU ($cpu_core core) in Warning - I State - $cpu_precentage" > $body_text
    mailx -v -r "$from_address" -s "$subject3" -S smtp="$gmail_gateway" -S smtp-use-starttls -S smtp-auth=login -S smtp-auth-user="$username" -S smtp-auth-password="$password" -S ssl-verify=ignore $to_address < $body_text

fi
fi
