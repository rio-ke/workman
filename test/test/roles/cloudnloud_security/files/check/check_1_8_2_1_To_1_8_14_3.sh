#echo "1.8.x Protecting Resources - OSR's"
#echo "=================================="
LOGFILE=/tmp/ro.txt

if [ -f /etc/redhat-release ]; then 
   echo  "## You are Running REDHAT ##" 
   cat /etc/redhat-release >> $LOGFILE
       RHVER=`sed -rn 's/.*([0-9])\.[0-9].*/\1/p' /etc/redhat-release`
#   grep -q Enterprise /etc/redhat-release
#   if (($?)); then
#      RHVER=`awk '{print $5}' /etc/redhat-release | cut -c1`
#   else
#      RHVER=`awk '{print $3}' /etc/redhat-release | cut -c1`
#   fi
elif [ -f /etc/SuSE-release ]; then
   echo "## You are Running SuSE ##"
   cat /etc/SuSE-release >> $LOGFILE
   SVER=`cat /etc/SuSE-release | grep "VERSION" | awk '{print $3}'`
else
   echo "Looks like you may not be running REDHAT or SuSE!"
   echo "Script may have false errors or missed checks!"
   RHVER=X
   SVER=X
fi



echo ""
if [ -f ~root/.rhosts ]; then
   OWNER=`ls -al ~root/.rhosts | awk '{print $3}'`
   PERMS=`ls -al ~root/.rhosts | awk '{print $1}' | cut -c5,6,8,9`
   if [[ $OWNER = "root" ]] && [[ $PERMS = "----" ]]; then
      echo "CNL.1.8.2.1 : The ~root/.rhosts file is owned by user root and resticted to read/write only by user root."
   else
      echo "CNL.1.8.2.1 : WARNING - The ~root/.rhosts file is not restricted to read/write by only user root!"
   fi
   ls -al ~root/.rhosts >> $LOGFILE
else
   echo "CNL.1.8.2.1 : N/A - The ~root/.rhosts file does not exist."
fi

echo ""
if [ -f ~root/.netrc ]; then
   OWNER=`ls -al ~root/.netrc | awk '{print $3}'`
   PERMS=`ls -al ~root/.netrc | awk '{print $1}' | cut -c5,6,8,9`
   if [[ $OWNER = "root" ]] && [[ $PERMS = "----" ]]; then
      echo "CNL.1.8.2.2 : The ~root/.netrc file is owned by user root and resticted to read/write only by user root."
   else
      echo "CNL.1.8.2.2 : WARNING - The ~root/.netrc file is not restricted to read/write by only user root!"
   fi
   ls -al ~root/.netrc >> $LOGFILE
else
   echo "CNL.1.8.2.2 : N/A - The ~root/.netrc file does not exist."
fi

echo ""
X=1
for dir in / /usr /etc
do
PERMS=`ls -ald $dir | awk '{print $1}' | cut -c9`
if [ $PERMS != "-" ]; then
   echo "CNL.1.8.3.$X : WARNING - Setting for other on directory $dir is not r-x or more restrictive!"
else
   echo "CNL.1.8.3.$X : Setting for other on directory $dir is r-x or more restrictive."
fi
ls -ald $dir >> $LOGFILE
echo ""
((X+=1))
done

if [ -f /etc/security/opasswd ]; then
   PERMS=`ls -ald /etc/security/opasswd | awk '{print $1}' | cut -c4-10`
   if [ $PERMS != "-------" ]; then
      echo "CNL.1.8.4.1 : WARNING - Permissions on /etc/security/opasswd are not *rw------- or more restrictive:"
   else
      echo "CNL.1.8.4.1 : Permissions on /etc/security/opasswd are *rw------- or more restrictive:"
   fi
   ls -ald /etc/security/opasswd >> $LOGFILE
else
   echo "CNL.1.8.4.1 : WARNING - The /etc/security/opasswd file does NOT exist!"
fi

echo ""
if [ -f /etc/shadow ]; then
   PERMS=`ls -ald /etc/shadow | awk '{print $1}' | cut -c4-10`
   GROUPname=`ls -ald /etc/shadow | awk '{print $4}'`
   if [ $PERMS = "-------" ]; then
      echo "CNL.1.8.4.2 : Permissions on /etc/shadow are *rw------- or more restrictive:"
   elif [ $PERMS = "-r-----" ]; then
      grep -q "^$GROUPname:" /etc/group
      if ((!$?)); then
         GROUPid=`grep "^$GROUPname:" /etc/group | awk -F':' '{print $3}'`
         if [ $OSFlavor = "RedHat" ] && [ $RHVER -ge 6 ]; then
            if [[ $GROUPid -le 99 ]] || [[ $GROUPid -ge 101 && $GROUPid -le 199 ]]; then
               echo "CNL.1.8.4.2 : Permissions on /etc/shadow allows read access by group and the associated group has GID <= 99 or GID >= 101 and <= 199:"
            else
               echo "CNL.1.8.4.2 : WARNING - Permissions on /etc/shadow allows read access by group and the associated group does NOT have GID <= 99 or GID >= 101 and <= 199:"
            fi
         else
            if [ $GROUPid -le 99 ]; then
               echo "CNL.1.8.4.2 : Permissions on /etc/shadow allows read access by group and the associated group has GID <= 99:"
            else
               echo "CNL.1.8.4.2 : WARNING - Permissions on /etc/shadow allows read access by group and the associated group does NOT have GID <= 99:"
            fi
         fi
      else
         echo "CNL.1.8.4.2 : WARNING - Permissions on /etc/shadow allows read access by group and the associated group has an unknown GID!"
      fi
   else
      echo "CNL.1.8.4.2 : WARNING - Permissions on /etc/shadow are NOT *rw------- or more restrictive:"
   fi
   ls -ald /etc/shadow >> $LOGFILE
else
   echo "CNL.1.8.4.2 : WARNING - The /etc/shadow file does NOT exist!"
fi

echo ""
PERMS=`ls -ald /var | awk '{print $1}' | cut -c9`
if [ $PERMS != "-" ]; then
   echo "CNL.1.8.5.1 : WARNING - Setting for other on directory /var is not r-x or more restrictive!"
else
   echo "CNL.1.8.5.1 : Setting for other on directory /var is r-x or more restrictive."
fi
ls -ald /var >> $LOGFILE

echo ""
PERMS=`ls -ald /var/log | awk '{print $1}' | cut -c9`
if [ $PERMS != "-" ]; then
   echo "CNL.1.8.5.2 : WARNING - Setting for other on directory /var/log is not r-x or more restrictive!"
else
   echo "CNL.1.8.5.2 : Setting for other on directory /var/log is r-x or more restrictive."
fi
ls -ald /var/log >> $LOGFILE
cat /dev/null > CNL1852_temp
for dir in `ls -al /var/log | grep "^d" | awk '{print $9}'`
do
if [[ $dir != "." ]] && [[ $dir != ".." ]]; then
   PERMSall=`ls -ald /var/log/$dir | awk '{print $1}' | cut -c2-10`
   PERMS=`ls -ald /var/log/$dir | awk '{print $1}' | cut -c9`
   if [[ $PERMS != "-" ]] && [[ $PERMSall != "rwxrwxrwx" ]]; then
      ls -ald /var/log/$dir >> CNL1852_temp
   fi
fi
done
if [ -s CNL1852_temp ]; then
   echo "CNL.1.8.5.2 : WARNING - Subdirectories of /var/log exist that are world writable and are not set to 1777:"
   cat CNL1852_temp >> $LOGFILE
else
   echo "CNL.1.8.5.2 : All subdirectories of /var/log are either not world writable or set to 1777."
fi
rm -rf CNL1852_temp

echo ""
if [ -f /etc/pam.d/system-auth ]; then
   egrep "^account|^auth" /etc/pam.d/system-auth | grep "required" | grep "pam_tally2.so" > /dev/null 2>&1
   if ((!$?)); then
      TALLY2=0
   fi
fi
if (($TALLY2)); then
   if [ -f /var/log/faillog ]; then
      PERMS=`ls -ald /var/log/faillog | awk '{print $1}' | cut -c4-10`
      if [ $PERMS != "-------" ]; then
         echo "CNL.1.8.6.1 : WARNING - Permissions on /var/log/faillog are not *rw------- or more restrictive:"
      else
         echo "CNL.1.8.6.1 : Permissions on /var/log/faillog are *rw------- or more restrictive:"
      fi
      ls -ald /var/log/faillog >> $LOGFILE
   else
      echo "CNL.1.8.6.1 : WARNING - The file /var/log/faillog does NOT exist!"
   fi
else
   echo "CNL.1.8.6.1 : N/A - This system is using the pam_tally2.so parameter in /etc/pam.d/system-auth"
fi

echo ""
if (($TALLY2)); then
#if ((!$TALLY2)); then
   if [ -f /var/log/tallylog ]; then
      PERMS=`ls -ald /var/log/tallylog | awk '{print $1}' | cut -c4-10`
      if [ $PERMS != "-------" ]; then
         echo "CNL.1.8.6.2 : WARNING - Permissions on /var/log/tallylog are not *rw------- or more restrictive:"
      else
         echo "CNL.1.8.6.2 : Permissions on /var/log/tallylog are *rw------- or more restrictive:"
      fi
      ls -ald /var/log/tallylog >> $LOGFILE
   else
      echo "CNL.1.8.6.2 : WARNING - The file /var/log/tallylog does NOT exist!"
   fi
else
   echo "CNL.1.8.6.2 : N/A - This system is not using the pam_tally2.so parameter in /etc/pam.d/system-auth"
fi

echo ""
X=1
for file in /var/log/messages /var/log/wtmp
do
if [ -f $file ]; then
   PERMS=`ls -ald $file | awk '{print $1}' | cut -c6,9`
   if [ $PERMS != "--" ]; then
      echo "CNL.1.8.7.$X : WARNING - Permissions on $file are not set to *rwxr-xr-x or more restrictive:"
   else
      echo "CNL.1.8.7.$X : Permissions on $file are set to *rwxr-xr-x or more restrictive:"
   fi
   ls -ald $file >> $LOGFILE
else
   echo "CNL.1.8.7.$X : WARNING - The file $file does NOT exist!"
fi
((X+=1))
echo ""
done

if [ -f /var/log/secure ]; then
   PERMS=`ls -ald /var/log/secure | awk '{print $1}' | cut -c6,8-10`
   if [ $PERMS != "----" ]; then
      echo "CNL.1.8.8 : WARNING - Permissions on /var/log/secure are not set to *rwxr-x--- or more restrictive:"
   else
      echo "CNL.1.8.8 : Permissions on /var/log/secure are set to *rwxr-x--- or more restrictive:"
   fi
   ls -ald /var/log/secure >> $LOGFILE
elif [ -f /var/log/auth.log ]; then
   PERMS=`ls -ald /var/log/auth.log | awk '{print $1}' | cut -c6,8-10`
   if [ $PERMS != "----" ]; then
      echo "CNL.1.8.8 : WARNING - Permissions on /var/log/auth.log are not set to *rwxr-x--- or more restrictive:"
   else
      echo "CNL.1.8.8 : Permissions on /var/log/auth.log are set to *rwxr-x--- or more restrictive:"
   fi
   ls -ald /var/log/auth.log >> $LOGFILE
else
   echo "CNL.1.8.8 : WARNING - Niether the /var/log/secure nor /var/log/auth.log files exist!"
fi

echo ""
PERMS=`ls -ald /tmp | awk '{print $1}' | cut -c1-10`
if [ $PERMS != "drwxrwxrwt" ]; then
   echo "CNL.1.8.9 : WARNING - The permissions on /tmp are not set to drwxrwxrwt"
else
   echo "CNL.1.8.9 : The permissions on /tmp are set to drwxrwxrwt"
fi
ls -ald /tmp >> $LOGFILE

echo ""
if [ -f /etc/snmpd.conf ]; then
   PERMS=`ls -al /etc/snmpd.conf | awk '{print $1}' | cut -c1,4,6-10`
   if [ $PERMS != "-------" ]; then
      echo "CNL.1.8.10 : WARNING - The /etc/snmpd.conf file is not set to 0640 permissions:"
   else
      echo "CNL.1.8.10 : The /etc/snmpd.conf file is set to 0640 permissions:"
   fi
   ls -al /etc/snmpd.conf >> $LOGFILE
elif [ -f /etc/snmp/snmpd.conf ]; then
   PERMS=`ls -al /etc/snmp/snmpd.conf | awk '{print $1}' | cut -c1,4,6-10`
   if [ $PERMS != "-------" ]; then
      echo "CNL.1.8.10 : WARNING - The /etc/snmp/snmpd.conf file is not set to 0640 permissions:"
   else
      echo "CNL.1.8.10 : The /etc/snmp/snmpd.conf file is set to 0640 permissions:"
   fi
   ls -al /etc/snmp/snmpd.conf >> $LOGFILE
elif [ -f /etc/snmpd/snmpd.conf ]; then
   PERMS=`ls -al /etc/snmpd/snmpd.conf | awk '{print $1}' | cut -c1,4,6-10`
   if [ $PERMS != "-------" ]; then
      echo "CNL.1.8.10 : WARNING - The /etc/snmpd/snmpd.conf file is not set to 0640 permissions:"
   else
      echo "CNL.1.8.10 : The /etc/snmpd/snmpd.conf file is set to 0640 permissions:"
   fi
   ls -al /etc/snmpd/snmpd.conf >> $LOGFILE
else
   echo "CNL.1.8.10 : N/A - The snmpd.conf file does not exist."
fi

echo ""
if [ -d /var/tmp ]; then
   PERMS=`ls -ald /var/tmp | awk '{print $1}' | cut -c1-10`
   if [ $PERMS != "drwxrwxrwt" ]; then
      echo "CNL.1.8.11 : WARNING - The /var/tmp directory is not set to 1777 permissions:"
   else
      echo "CNL.1.8.11 : The /var/tmp directory is set to 1777 permissions:"
   fi
   ls -ald /var/tmp >> $LOGFILE
else
   echo "CNL.1.8.11 : The /var/tmp directory does not exist on this server."
fi

echo ""
if (($TALLY2)); then
   if [ -f /var/log/faillog ]; then
      PERM=`ls -ald /var/log/faillog | awk '{print $1}' | cut -c6`
      GROUPname=`ls -ald /var/log/faillog | awk '{print $4}'`
      if [ $PERM = "w" ]; then
         grep -q "^$GROUPname:" /etc/group
         if ((!$?)); then
            GROUPid=`grep "^$GROUPname:" /etc/group | awk -F':' '{print $3}'`
            if [ $OSFlavor = "RedHat" ] && [ $RHVER -ge 6 ]; then
               if [[ $GROUPid -le 99 ]] || [[ $GROUPid -ge 101 && $GROUPid -le 199 ]]; then
                  echo "CNL.1.8.12.1.1 : Permissions on /var/log/faillog allows write access by group and the associated group has GID <= 99 or GID >= 101 and <= 199:"
               else
                  echo "CNL.1.8.12.1.1 : WARNING - Permissions on /var/log/faillog allows write access by group and the associated group does NOT have GID <= 99 or GID >= 101 and <= 199:"
               fi
            else
               if [ $GROUPid -le 99 ]; then
                  echo "CNL.1.8.12.1.1 : Permissions on /var/log/faillog allows write access by group and the associated group has GID <= 99:"
               else
                  echo "CNL.1.8.12.1.1 : WARNING - Permissions on /var/log/faillog allows write access by group and the associated group does NOT have GID <= 99:"
               fi
            fi
         else
            echo "CNL.1.8.12.1.1 : WARNING - Permissions on /var/log/faillog allows write access by group and the associated group has an unknown GID!"
         fi
      else
         echo "CNL.1.8.12.1.1 : Write access is not allowed for group for file /var/log/faillog"
      fi
      ls -ald /var/log/faillog >> $LOGFILE
   else
      echo "CNL.1.8.12.1.1 : WARNING - The log file /var/log/faillog does NOT exist!"
   fi
else
   echo "CNL.1.8.12.1.1 : N/A - This system uses the pam_tally2.so parameter."
fi

echo ""
if (($TALLY2)); then
   if [ -f /var/log/tallylog ]; then
      PERM=`ls -ald /var/log/tallylog | awk '{print $1}' | cut -c6`
      GROUPname=`ls -ald /var/log/tallylog | awk '{print $4}'`
      if [ $PERM = "w" ]; then
         grep -q "^$GROUPname:" /etc/group
         if ((!$?)); then
            GROUPid=`grep "^$GROUPname:" /etc/group | awk -F':' '{print $3}'`
            if [ $OSFlavor = "RedHat" ] && [ $RHVER -ge 6 ]; then
               if [[ $GROUPid -le 99 ]] || [[ $GROUPid -ge 101 && $GROUPid -le 199 ]]; then
                  echo "CNL.1.8.12.1.2 : Permissions on /var/log/tallylog allows write access by group and the associated group has GID <= 99 or GID >= 101 and <= 199:"
               else
                  echo "CNL.1.8.12.1.2 : WARNING - Permissions on /var/log/tallylog allows write access by group and the associated group does NOT have GID <= 99 or GID >= 101 and <= 199:"
               fi
            else
               if [ $GROUPid -le 99 ]; then
                  echo "CNL.1.8.12.1.2 : Permissions on /var/log/tallylog allows write access by group and the associated group has GID <= 99:"
               else
                  echo "CNL.1.8.12.1.2 : WARNING - Permissions on /var/log/tallylog allows write access by group and the associated group does NOT have GID <= 99:"
               fi
            fi
         else
            echo "CNL.1.8.12.1.2 : WARNING - Permissions on /var/log/tallylog allows write access by group and the associated group has an unknown GID!"
         fi
      else
         echo "CNL.1.8.12.1.2 : Write access is not allowed for group for file /var/log/tallylog"
      fi
      ls -ald /var/log/tallylog >> $LOGFILE
   else
      echo "CNL.1.8.12.1.2 : WARNING - The log file /var/log/tallylog does NOT exist!"
   fi
else
   echo "CNL.1.8.12.1.2 : N/A - This system does not use the pam_tally2.so parameter."
fi

echo ""
X=2
for file in /var/log/messages /var/log/wtmp /var/log/secure /var/log/auth.log
do
if [ -f $file ]; then
   PERM=`ls -ald $file | awk '{print $1}' | cut -c6`
   GROUPname=`ls -ald $file | awk '{print $4}'`
   if [ $PERM = "w" ]; then
      grep -q "^$GROUPname:" /etc/group
      if ((!$?)); then
         GROUPid=`grep "^$GROUPname:" /etc/group | awk -F':' '{print $3}'`
         if [ "$OSFlavor" == "RedHat" ] && [ $RHVER -ge 6 ]; then
            if [[ $GROUPid -le 99 ]] || [[ $GROUPid -ge 101 && $GROUPid -le 199 ]]; then
               echo "CNL.1.8.12.$X : Permissions on $file allows write access by group and the associated group has GID <= 99 or GID >= 101 and <= 199:"
            else
               echo "CNL.1.8.12.$X : WARNING - Permissions on $file allows write access by group and the associated group does NOT have GID <= 99 or GID >= 101 and <= 199:"
            fi
         else
            if [ $GROUPid -le 99 ]; then
               echo "CNL.1.8.12.$X : Permissions on $file allows write access by group and the associated group has GID <= 99:"
            else
               echo "CNL.1.8.12.$X : WARNING - Permissions on $file allows write access by group and the associated group does NOT have GID <= 99:"
            fi
         fi
      else
         echo "CNL.1.8.12.$X : WARNING - Permissions on $file allows write access by group and the associated group has an unknown GID!"
      fi
   else
      echo "CNL.1.8.12.$X : Write access is not allowed for group for file $file"
   fi
   ls -ald $file >> $LOGFILE
else
   echo "CNL.1.8.12.$X : WARNING - The log file $file does NOT exist!"
fi
((X+=1))
echo ""
done

X=6
for file in /etc/profile.d/IBMsinit.sh /etc/profile.d/IBMsinit.csh
do
if [ -f $file ]; then
   PERM=`ls -ald $file | awk '{print $1}' | cut -c6`
   GROUPname=`ls -ald $file | awk '{print $4}'`
   if [ $PERM = "w" ]; then
      grep -q "^$GROUPname:" /etc/group
      if ((!$?)); then
         GROUPid=`grep "^$GROUPname:" /etc/group | awk -F':' '{print $3}'`
         if [ $OSFlavor = "RedHat" ] && [ $RHVER -ge 6 ]; then
            if [[ $GROUPid -le 99 ]] || [[ $GROUPid -ge 101 && $GROUPid -le 199 ]]; then
               echo "CNL.1.8.12.$X : Permissions on $file allows write access by group and the associated group has GID <= 99 or GID >= 101 and <= 199:"
            else
               echo "CNL.1.8.12.$X : WARNING - Permissions on $file allows write access by group and the associated group does NOT have GID <= 99 or GID >= 101 and <= 199:"
            fi
         else
            if [ $GROUPid -le 99 ]; then
               echo "CNL.1.8.12.$X : Permissions on $file allows write access by group and the associated group has GID <= 99:"
            else
               echo "CNL.1.8.12.$X : WARNING - Permissions on $file allows write access by group and the associated group does NOT have GID <= 99:"
            fi
         fi
      else
         echo "CNL.1.8.12.$X : WARNING - Permissions on $file allows write access by group and the associated group has an unknown GID!"
      fi
   else
      echo "CNL.1.8.12.$X : Write access is not allowed for group for file $file"
   fi
   PERM=`ls -ald $file | awk '{print $1}' | cut -c5,7`
   if [ $PERM != "rx" ]; then
      echo "CNL.1.8.12.$X : WARNING - Permissions on $file are not set to r-x or acceptable rwx for group:"
   else
      echo "CNL.1.8.12.$X : Permissions on $file are set to r-x or acceptable rwx for group."
   fi
   PERM=`ls -ald $file | awk '{print $1}' | cut -c8-10`
   if [ $PERM != "r-x" ]; then
      echo "CNL.1.8.12.$X : WARNING - Permissions on $file are not set to r-x for other:"
   else
      echo "CNL.1.8.12.$X : Permissions on $file are set to r-x for other:"
   fi
   ls -ald $file >> $LOGFILE
else
   echo "CNL.1.8.12.$X : WARNING - The file $file does NOT exist!"
fi
((X+=1))
echo ""
done

cat /dev/null > CNL1813_temp
cat /etc/inittab | grep -v "^#" | awk -F':' '{print $4}' | awk '{print $1}' > CNL1813_temp
##Remove any duplicate entries, which are common in inittab
cat CNL1813_temp | awk '! a[$0]++' > CNL1813a_temp
rm -rf CNL1813_temp
cat /dev/null > CNL18132_temp
for entry in `cat CNL1813a_temp`
do
echo $entry | grep "/" > /dev/null 2>&1
if (($?)); then
   echo $entry >> CNL18132_temp
fi
done
if [ -s CNL18132_temp ]; then
   echo "CNL.1.8.13.2 : WARNING - Some entry(ies) exist in /etc/inittab that do not appear to contain the full path:"
   cat CNL18132_temp >> $LOGFILE
else
   echo "CNL.1.8.13.2 : All entry(ies) in /etc/inittab appear to contain the full path of waht is being executed."
fi
rm -rf CNL18132_temp

echo ""
cat /dev/null > CNL18133_temp
for entry in `cat CNL1813a_temp`
do
if [ -e $entry ]; then
   PERM=`ls -ald $entry | awk '{print $1}' | cut -c9`
   if [ $PERM != "-" ]; then
      echo "The file being executed has an incorrect permission setting."  >> CNL18133_temp
      echo "The file being checked was: $entry" >> CNL18133_temp
      ls -ald $entry >> CNL18133_temp
      echo "" >> CNL18133_temp
   fi
fi
entryA=$entry
until [ `basename $entry` = "/" ]
do
entry=`dirname $entry`
if [[ ! -L $entry ]] && [[ -e $entry ]]; then
   PERM=`ls -ald $entry | awk '{print $1}' | cut -c9`
   if [ $PERM != "-" ]; then
      echo "The path for $entryA has an incorrect permission setting." >> CNL18133_temp
      echo "The line being checked was: $entry" >> CNL18133_temp
      ls -ald $entry >> CNL18133_temp
      echo "" >> CNL18133_temp
   fi
fi
done
done
if [ -s CNL18133_temp ]; then
   echo "CNL.1.8.13.3 : WARNING - Entry(ies) exist in /etc/inittab that have incorrect"
   echo "setttings for 'other' and are not set to r-x or more stringent:"
   cat CNL18133_temp >> $LOGFILE
else
   echo "CNL.1.8.13.3 : All active entry(ies) & all existing directories in their path"
   echo "CNL.1.8.13.3 : have settings for 'other' set to r-x or more stringent."
fi
rm -rf CNL18133_temp

echo ""
cat /dev/null > CNL18134_temp
for entry in `cat CNL1813a_temp`
do
if [ -e $entry ]; then
   PERM=`ls -ald $entry | awk '{print $1}' | cut -c9`
   GROUPname=`ls -ald $entry | awk '{print $4}'`
   if [ $PERM != "-" ]; then
      grep -q "^$GROUPname:" /etc/group
      if ((!$?)); then
         GROUPid=`grep "^$GROUPname:" /etc/group | awk -F':' '{print $3}'`
      else
         GROUPid=999
      fi
      if [ $GROUPid -gt 99 ]; then
         echo "The file being executed has an incorrect permission and/or group setting."  >> CNL18134_temp
         echo "The file being checked was: $entry" >> CNL18134_temp
         ls -ald $entry >> CNL18134_temp
         echo "" >> CNL18134_temp
      fi
   fi
fi
entryA=$entry
until [ `basename $entry` = "/" ]
do
entry=`dirname $entry`
if [[ ! -L $entry ]] && [[ -e $entry ]]; then
   PERM=`ls -ald $entry | awk '{print $1}' | cut -c9`
   GROUPname=`ls -ald $entry | awk '{print $4}'`
   if [ $PERM != "-" ]; then
      grep -q "^$GROUPname:" /etc/group
      if ((!$?)); then
         GROUPid=`grep "^$GROUPname:" /etc/group | awk -F':' '{print $3}'`
      else
         GROUPid=999
      fi
      if [ $GROUPid -gt 99 ]; then
         echo "The path for $entryA has an incorrect permission and/or group setting." >> CNL18134_temp
         echo "The line being checked was: $entry" >> CNL18134_temp
         ls -ald $entry >> CNL18134_temp
         echo "" >> CNL18134_temp
      fi
   fi
fi
done
done
if [ -s CNL18134_temp ]; then
   echo "CNL.1.8.13.4 : WARNING - Entry(ies) exist in /etc/inittab that have incorrect setttings for 'group'"
   echo "CNL.1.8.13.4 : and are not set to r-x or more stringent and owned by GID > 99:"
   cat CNL18134_temp >> $LOGFILE
else
   echo "CNL.1.8.13.4 : All active entry(ies) & all existing directories in their path"
   echo "CNL.1.8.13.4 : have settings for 'group' set to r-x or more stringent or owned by GID <= 99."
fi
rm -rf CNL18134_temp CNL1813a_temp

echo ""
#Examining the cron file is very complex given the huge number of ways
#the script/command can be configured in crontab (i.e. nohup, /usr/bin/su <command>, etc, etc).
#I will do my best to take it in steps and parse out what I can. The user may
#have to manually examine some entries, depending on the results, and I 
#will do do my best to aid in the manual checks if they are necessary.
echo ""
CrontabExists=0
CRON=/var/spool/cron/root
if [ -f $CRON ]; then
   cat $CRON | grep -v "^#" > OSRCronClean #gives ACTIVE cron entries
   cat OSRCronClean | awk '{print substr($0, index($0,$6)) }' | cut -d'>' -f1 | awk -F"/" '{print substr($0, index($0,$1)) }' | awk '{print $1}' > OSRCronToCheck #gives the potential scripts/commands to check
   X=1 #First line to start checking
   cat /dev/null > OSRCronResult #clean our results file to start fresh if any problems found
   for line in `cat OSRCronToCheck`
   do
   echo $line | grep "/" > /dev/null 2>&1
   if (($?)); then
      echo "The line being checked was:" >> OSRCronResult
      cat OSRCronClean | awk -v XX=$X 'NR==XX' >> OSRCronResult
      echo "The script attempted to check: $line" >> OSRCronResult
      echo "" >> OSRCronResult
   fi
   ((X+=1))
   done
   if [ -s OSRCronResult ]; then
      echo "CNL.1.8.14.1 : WARNING - At least one active entry was found in root crontab that"
      echo "does not appear to specify the full path!"
      echo "Please review the results below and check for any false positives:"
      cat OSRCronResult >> $LOGFILE
      echo ""
      echo "!!! WARNING - THE ABOVE ENTRIES WILL NOT BE CHECKED IN THE NEXT TWO SECTIONS !!!"
      echo ""
   else
      echo "CNL.1.8.14.1 : All active entry in root crontab specify the full path of the file/command/script to be executed."
   fi
else
   echo "CNL.1.8.14.1 : N/A - There is no root crontab entry on this server."
   CrontabExists=1
fi

echo ""
if ((!$CrontabExists)); then
   cat /dev/null > OSRCronResult #clean our results file to start fresh if any problems found
   X=1 #First line to start checking
   for line in `cat OSRCronToCheck`
   do
   if [ -e $line ]; then
      FILEPerm=`ls -ald $line | awk '{print $1}' | cut -c9`
      if [ $FILEPerm != "-" ]; then
         echo "The line being checked was:" >> OSRCronResult
         cat OSRCronClean | awk -v XX=$X 'NR==XX' >> OSRCronResult
         echo "The script attempted to check: $line" >> OSRCronResult
         ls -ald $line >> OSRCronResult
         echo "" >> OSRCronResult
      fi
   fi
   lineA=$line
   echo $line | grep "^/" > /dev/null 2>&1
   if ((!$?)); then
      until [ `basename $line` = "/" ]
      do
      line=`dirname $line`
      if [ ! -L $line ] && [ -e $line ]; then
         FILEPerm=`ls -ald $line | awk '{print $1}' | cut -c9`
         if [ $FILEPerm != "-" ]; then
            echo "The path for $lineA has an incorrect setting" >> OSRCronResult
            echo "The line being checked was:" >> OSRCronResult
            cat OSRCronClean | awk -v XX=$X 'NR==XX' >> OSRCronResult
            echo "The script attempted to check: $line" >> OSRCronResult
            ls -ald $line >> OSRCronResult
            echo "" >> OSRCronResult
         fi
      fi
      done
   fi
   ((X+=1))
   done
   if [ -s OSRCronResult ]; then
      echo "CNL.1.8.14.2 : WARNING - An entry in root crontab has an incorrect setting for other:"
      cat OSRCronResult >> $LOGFILE
   else
      echo "CNL.1.8.14.2 : All active & valid entries in root crontab have correct settings for other."
   fi
else
   echo "CNL.1.8.14.2 : N/A - There is no crontab file for root."
fi

echo ""
if ((!$CrontabExists)); then
   cat /dev/null > OSRCronResult #clean our results file to start fresh if any problems found
   X=1 #First line to start checking
   for line in `cat OSRCronToCheck`
   do
   if [ -e $line ]; then
      FILEPerm=`ls -ald $line | awk '{print $1}' | cut -c6`
      GROUPname=`ls -ald $line | awk '{print $4}'`
      if [ $FILEPerm != "-" ]; then
         grep -q "^$GROUPname:" /etc/group
         if ((!$?)); then
            GROUPid=`grep "^$GROUPname:" /etc/group | awk -F':' '{print $3}'`
         else
            GROUPid=999
         fi
         if [ $GROUPid -gt 99 ]; then
            echo "The line being checked was:" >> OSRCronResult
            cat OSRCronClean | awk -v XX=$X 'NR==XX' >> OSRCronResult
            echo "The script attempted to check: $line" >> OSRCronResult
            ls -ald $line >> OSRCronResult
            echo "" >> OSRCronResult
         fi
      fi
   fi
   lineA=$line
   echo $line | grep "^/" > /dev/null 2>&1
   if ((!$?)); then
      until [ `basename $line` = "/" ]
      do
      line=`dirname $line`
      if [ ! -L $line ] && [ -e $line ]; then
         FILEPerm=`ls -ald $line | awk '{print $1}' | cut -c6`
         GROUPname=`ls -ald $line | awk '{print $4}'`
         if [ $FILEPerm != "-" ]; then
            grep -q "^$GROUPname:" /etc/group
            if ((!$?)); then
               GROUPid=`grep "^$GROUPname:" /etc/group | awk -F':' '{print $3}'`
            else
               GROUPid=999
            fi
            if [ $GROUPid -gt 99 ]; then
               echo "The path for $lineA has an incorrect setting" >> OSRCronResult
               echo "The line being checked was:" >> OSRCronResult
               cat OSRCronClean | awk -v XX=$X 'NR==XX' >> OSRCronResult
               echo "The script attempted to check: $line" >> OSRCronResult
               ls -ald $line >> OSRCronResult
               echo "" >> OSRCronResult
            fi
         fi
      fi
      done
   fi
   ((X+=1))
   done
   if [ -s OSRCronResult ]; then
      echo "CNL.1.8.14.3 : WARNING - An entry in root crontab has an incorrect setting and/or owner for group:"
      cat OSRCronResult >> $LOGFILE
   else
      echo "CNL.1.8.14.3 : All active entries in root crontab have correct settings and/or owner for group."
   fi
else
   echo "CNL.1.8.14.3 : N/A - There is no crontab for root."
fi

#Clean up our mess:
rm -rf OSRCronClean OSRCronResult OSRCronToCheck $LOGFILE

