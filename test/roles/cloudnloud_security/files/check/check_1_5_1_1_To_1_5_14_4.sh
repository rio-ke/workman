#echo "1.5.x Network Settings"
#echo "======================"

LOGFILE=/tmp/net.txt

if [ -f /etc/redhat-release ]; then 
#   echo  "## You are Running REDHAT ##" 
   cat /etc/redhat-release >> $LOGFILE
       RHVER=`sed -rn 's/.*([0-9])\.[0-9].*/\1/p' /etc/redhat-release`
#   grep -q Enterprise /etc/redhat-release
#   if (($?)); then
#      RHVER=`awk '{print $5}' /etc/redhat-release | cut -c1`
#   else
#      RHVER=`awk '{print $3}' /etc/redhat-release | cut -c1`
#   fi
elif [ -f /etc/SuSE-release ]; then
#   echo "## You are Running SuSE ##"
   cat /etc/SuSE-release >> $LOGFILE
   SVER=`cat /etc/SuSE-release | grep "VERSION" | awk '{print $3}'`
else
#   echo "Looks like you may not be running REDHAT or SuSE!"
#   echo "Script may have false errors or missed checks!"
   RHVER=X
   SVER=X
fi

#Things get complicated here. Too many kinds of FTP to check.
#We will attempt to check VSFTP and wu-ftp
##
rpm -qa | grep -q wu-ftpd
if (($?)); then
   WUFTPD=1
   WUFTPDanon=1
else
   WUFTPD=0
   chkconfig --list | grep -iq wu-ftpd
   if ((!$?)); then
      chkconfig --list | grep -i wu-ftpd | grep -q on
      if ((!$?)); then
         grep "^ftp:" /etc/passwd | grep -vq "/sbin/nologin"
         if ((!$?)); then
            WUFTPDanon=0
         else
            WUFTPDanon=1
         fi
      else
         WUFTPD=1
         WUFTPDanon=1
      fi
   elif [ -f /etc/inetd.conf ]; then
      grep "^ftp" /etc/inetd.conf | grep -vq vsftp
      if ((!$?)); then
         WUFTPD=0
         grep "^ftp:" /etc/passwd | grep -vq "/sbin/nologin"
         if ((!$?)); then
            WUFTPDanon=0
         else
            WUFTPDanon=1
         fi
      else
         WUFTPD=0
         WUFTPDanon=1
      fi
   else
      WUFTPD=0
      WUFTPDanon=1
   fi
fi
rpm -qa | grep -q vsftpd
if (($?)); then
   VSFTPD=1
   VSFTPDanon=1
   chkconfig --list | grep -iq vsftpd >> $LOGFILE
   if ((!$?)); then
      chkconfig --list | grep -i vsftpd | grep -q on
      if ((!$?)); then
         TestFile=`cat /etc/xinetd.d/vsftpd | grep -v "^#" | grep -w server | awk '{print $3}'`
         if [[ -n $TestFile ]] && [[ -x $TestFile ]]; then
            VSFTPD=0
            if [ -f /etc/vsftpd/vsftpd.conf ]; then
               VSFTPDfile=/etc/vsftpd/vsftpd.conf
            elif [ -f /etc/vsftpd.conf ]; then
               VSFTPDfile=/etc/vsftpd.conf
            elif [ -f /usr/local/etc/vsftpd.conf ]; then
               VSFTPDfile=/usr/local/etc/vsftpd.conf
            else
               VSFTPDfile=UNKNOWN
            fi
            if [ $VSFTPDfile != "UNKNOWN" ]; then
               grep -q "^anonymous_enable" $VSFTPDfile
               if ((!$?)); then
                  grep -q "^anonymous_enable" $VSFTPDfile | grep -iq yes
                  if ((!$?)); then
                     grep "^ftp:" /etc/passwd | grep -vq "/sbin/nologin"
                     if ((!$?)); then
                        VSFTPDanon=0
                     else
                        VSFTPDanon=1
                     fi
                  else
                     VSFTPDanon=1
                  fi
               else
                  grep -q "anonymous_enable" $VSFTPDfile
                  if ((!$?)); then
                     grep "^ftp:" /etc/passwd | grep -vq "/sbin/nologin"
                     if ((!$?)); then
                        VSFTPDanon=0
                     else
                        VSFTPDanon=1
                     fi
                  else
                     VSFTPDanon=1
                  fi
               fi
            else
               grep "^ftp:" /etc/passwd | grep -vq "/sbin/nologin"
               if ((!$?)); then
                  VSFTPDanon=0
               else
                  VSFTPDanon=1
               fi
            fi
         fi
      fi
   elif [ -f /etc/inetd.conf ]; then
      grep "^ftp" /etc/inetd.conf | grep -q vsftpd
      if ((!$?)); then
         VSFTPD=0
         if [ -f /etc/vsftpd/vsftpd.conf ]; then
            VSFTPDfile=/etc/vsftpd/vsftpd.conf
         elif [ -f /etc/vsftpd.conf ]; then
            VSFTPDfile=/etc/vsftpd.conf
         elif [ -f /usr/local/etc/vsftpd.conf ]; then
            VSFTPDfile=/usr/local/etc/vsftpd.conf
         else
            VSFTPDfile=UNKNOWN
         fi
         if [ $VSFTPDfile != "UNKNOWN" ]; then
            grep -q "^anonymous_enable" $VSFTPDfile
            if ((!$?)); then
               grep -q "^anonymous_enable" $VSFTPDfile | grep -iq yes
               if ((!$?)); then
                  grep "^ftp:" /etc/passwd | grep -vq "/sbin/nologin"
                  if ((!$?)); then
                     VSFTPDanon=0
                  else
                     VSFTPDanon=1
                  fi
               else
                  VSFTPDanon=1
               fi
            else
               grep -q "anonymous_enable" $VSFTPDfile
               if ((!$?)); then
                  grep "^ftp:" /etc/passwd | grep -vq "/sbin/nologin"
                  if ((!$?)); then
                     VSFTPDanon=0
                  else
                     VSFTPDanon=1
                  fi
               else
                  VSFTPDanon=1
               fi
            fi
         else
            grep "^ftp:" /etc/passwd | grep -vq "/sbin/nologin"
            if ((!$?)); then
               VSFTPDanon=0
            else
               VSFTPDanon=1
            fi
         fi
      else
         VSFTPD=1
         VSFTPDanon=1
      fi
   else
      VSFTPD=1
      VSFTPDanon=1
   fi
else
   chkconfig --list | grep -i vsftpd >> $LOGFILE
   if ((!$?)); then
      chkconfig --list | grep -i vsftpd | grep -q on
      if ((!$?)); then
         VSFTPD=0
         if [ -f /etc/vsftpd/vsftpd.conf ]; then
            VSFTPDfile=/etc/vsftpd/vsftpd.conf
         elif [ -f /etc/vsftpd.conf ]; then
            VSFTPDfile=/etc/vsftpd.conf
         elif [ -f /usr/local/etc/vsftpd.conf ]; then
            VSFTPDfile=/usr/local/etc/vsftpd.conf
         else
            VSFTPDfile=UNKNOWN
         fi
         if [ $VSFTPDfile != "UNKNOWN" ]; then
            grep -q "^anonymous_enable" $VSFTPDfile
            if ((!$?)); then
               grep -q "^anonymous_enable" $VSFTPDfile | grep -iq yes
               if ((!$?)); then
                  grep "^ftp:" /etc/passwd | grep -vq "/sbin/nologin"
                  if ((!$?)); then
                     VSFTPDanon=0
                  else
                     VSFTPDanon=1
                  fi
               else
                  VSFTPDanon=1
               fi
            else
               grep -q "anonymous_enable" $VSFTPDfile
               if ((!$?)); then
                  grep "^ftp:" /etc/passwd | grep -vq "/sbin/nologin"
                  if ((!$?)); then
                     VSFTPDanon=0
                  else
                     VSFTPDanon=1
                  fi
               else
                  VSFTPDanon=1
               fi
            fi
         else
            grep "^ftp:" /etc/passwd | grep -vq "/sbin/nologin"
            if ((!$?)); then
               VSFTPDanon=0
            else
               VSFTPDanon=1
            fi
         fi
      else
         VSFTPD=1
         VSFTPDanon=1
      fi
   elif [ -f /etc/inetd.conf ]; then
      grep "^ftp" /etc/inetd.conf | grep -q vsftpd
      if ((!$?)); then
         VSFTPD=0
         if [ -f /etc/vsftpd/vsftpd.conf ]; then
            VSFTPDfile=/etc/vsftpd/vsftpd.conf
         elif [ -f /etc/vsftpd.conf ]; then
            VSFTPDfile=/etc/vsftpd.conf
         elif [ -f /usr/local/etc/vsftpd.conf ]; then
            VSFTPDfile=/usr/local/etc/vsftpd.conf
         else
            VSFTPDfile=UNKNOWN
         fi
         if [ $VSFTPDfile != "UNKNOWN" ]; then
            grep -q "^anonymous_enable" $VSFTPDfile
            if ((!$?)); then
               grep -q "^anonymous_enable" $VSFTPDfile | grep -iq yes
               if ((!$?)); then
                  grep "^ftp:" /etc/passwd | grep -vq "/sbin/nologin"
                  if ((!$?)); then
                     VSFTPDanon=0
                  else
                     VSFTPDanon=1
                  fi
               else
                  VSFTPDanon=1
               fi
            else
               grep -q "anonymous_enable" $VSFTPDfile
               if ((!$?)); then
                  grep "^ftp:" /etc/passwd | grep -vq "/sbin/nologin"
                  if ((!$?)); then
                     VSFTPDanon=0
                  else
                     VSFTPDanon=1
                  fi
               else
                  VSFTPDanon=1
               fi
            fi
         else
            grep "^ftp:" /etc/passwd | grep -vq "/sbin/nologin"
            if ((!$?)); then
               VSFTPDanon=0
            else
               VSFTPDanon=1
            fi
         fi
      else
         VSFTPD=1
         VSFTPDanon=1
      fi
   else
      VSFTPD=1
      VSFTPDanon=1
   fi
fi

if ((!$WUFTPD)) && ((!$WUFTPDanon)); then
   if [ -f /etc/inetd.conf ]; then
      grep "^ftp" /etc/inetd.conf | grep "-u" | grep -q 027
      if (($?)); then
         echo "CNL.1.5.1.1 : WARNING - wu-ftpd is installed and anonymous FTP is enabled but '-u 027' is not configured in /etc/inetd.conf"
      else
         echo "CNL.1.5.1.1 : The '-u 027' setting is configured in /etc/inetd.conf file."
      fi
   else
      echo "CNL.1.5.1.1 : WARNING - wu-ftpd is installed and anonymous FTP is enabled but '-u 027' is not configured in /etc/inetd.conf"
   fi
else
   echo "CNL.1.5.1.1 : N/A - wu-ftpd is not installed or anonymous FTP is not enabled."
fi

echo ""
#FTP is not installed:
if (($WUFTPD)) && (($VSFTPD)); then
   x=2
   until [ $x -eq 9 ]
   do
   echo "CNL.1.5.1.$x : N/A - FTP is not installed on this server."
   echo ""
   ((x+=1))
   done
#FTP installed but anonymous FTP is not enabled:
elif [[ $WUFTPD -eq 0 && $WUFTPDanon -eq 1 ]] || [[ $VSFTPD -eq 0 && $VSFTPDanon -eq 1 ]]; then
   x=2
   until [ $x -eq 9 ]
   do
   echo "CNL.1.5.1.$x : N/A - FTP is installed on this server, but anonymous ftp is NOT enabled."
   echo ""
   ((x+=1))
   done
#FTP installed and anonymous FTP is enabled so run the full gammit:
else
   AnonFTPHome=`grep "^ftp:" /etc/passwd | awk -F':' '{print $6}'`
   if [[ -n $AnonFTPHome ]] && [[ -d $AnonFTPHome ]]; then
      OWNER=`ls -ald $AnonFTPHome | awk '{print $3}'`
      HOMEPerms=`ls -ald $AnonFTPHome | awk '{print $1}' | cut -c6,9`
      if [[ $OWNER = "root" ]] && [[ $HOMEPerms = "--" ]]; then
         echo "CNL.1.5.1.2 : The ftp home directory exists and is owned by root and writeable only by root:"
      else
         echo "CNL.1.5.1.2 : WARNING - The ftp home directory exists and has incorrect permissions:"
      fi
      ls -ald $AnonFTPHome >> $LOGFILE
      echo ""
      if [ -d $AnonFTPHome/bin ]; then
         OWNER=`ls -ald $AnonFTPHome/bin | awk '{print $3}'`
         HOMEPerms=`ls -ald $AnonFTPHome/bin | awk '{print $1}' | cut -c6,9`
         if [[ $OWNER = "root" ]] && [[ $HOMEPerms = "--" ]]; then
            echo "CNL.1.5.1.3 : The bin subdirectory of the ftp home is owned by root and writeable only by root:"
         else
            echo "CNL.1.5.1.3 : WARNING - The bin subdirectory of the ftp home has incorrect permissions:"
         fi
         ls -ald $AnonFTPHome/bin >> $LOGFILE
         ls -al $AnonFTPHome/bin | egrep -vq '^total|^d' >> $LOGFILE
         if ((!$?)); then
            cat /dev/null > CNL1513_temp
            for file in `ls -al $AnonFTPHome/bin | egrep -v '^total|^d' | awk '{print $9}'`
            do
            OTHER=`stat -L -t --format=%a $AnonFTPHome/bin/$file
            if [ $OTHER == "111" ]; then
               ls -al $AnonFTPHome/bin/$file >> CNL1513_temp
            fi
            done
            if [ -s CNL1513_temp ]; then
               echo "CNL.1.5.1.3 : WARNING - File(s) exist in $AnonFTPHome/bin that are not set to mode 0111:"
               cat CNL1513_temp >> $LOGFILE
            else
               echo "CNL.1.5.1.3 : All file(s) in $AnonFTPHome/bin are set to mode 0111."
            fi
            rm -rf CNL1513_temp
         else
            echo "CNL.1.5.1.3 : No files exist in $AnonFTPHome/bin to check for mode 0111."
         fi
      else
         echo "CNL.1.5.1.3 : N/A - The bin subdirectory of the ftp home does not exist."
      fi
      echo ""
      if [ -d $AnonFTPHome/lib ]; then
         OWNER=`ls -ald $AnonFTPHome/lib | awk '{print $3}'`
         HOMEPerms=`ls -ald $AnonFTPHome/lib | awk '{print $1}' | cut -c6,9`
         if [[ $OWNER = "root" ]] && [[ $HOMEPerms = "--" ]]; then
            echo "CNL.1.5.1.4 : The lib subdirectory of the ftp home is owned by root and writeable only by root:"
         else
            echo "CNL.1.5.1.4 : WARNING - The lib subdirectory of the ftp home has incorrect permissions:"
         fi
         ls -ald $AnonFTPHome/lib >> $LOGFILE
         ls -al $AnonFTPHome/lib | egrep -vq '^total|^d' >> $LOGFILE
         if ((!$?)); then
            cat /dev/null > CNL1514_temp
            for file in `ls -al $AnonFTPHome/lib | egrep -v '^total|^d' | awk '{print $9}'`
            do
            OTHER=`stat -L -t --format=%a $AnonFTPHome/lib/$file
            if [ $OTHER == "555" ]; then
               ls -al $AnonFTPHome/lib/$file >> CNL1514_temp
            fi
            done
            if [ -s CNL1514_temp ]; then
               echo "CNL.1.5.1.4 : WARNING - File(s) exist in $AnonFTPHome/lib that are not set to mode 0555:"
               cat CNL1514_temp >> $LOGFILE
            else
               echo "CNL.1.5.1.4 : All file(s) in $AnonFTPHome/lib are set to mode 0555."
            fi
            rm -rf CNL1514_temp
         else
            echo "CNL.1.5.1.4 : No files exist in $AnonFTPHome/lib to check for mode 0555."
         fi
      else
         echo "CNL.1.5.1.4 : N/A - The lib subdirectory of the ftp home does not exist."
      fi
      echo ""
      if [ -d $AnonFTPHome/etc ]; then
         OWNER=`ls -ald $AnonFTPHome/etc | awk '{print $3}'`
         HOMEPerms=`ls -ald $AnonFTPHome/etc | awk '{print $1}' | cut -c6,9`
         if [[ $OWNER = "root" ]] && [[ $HOMEPerms = "--" ]]; then
            echo "CNL.1.5.1.5 : The etc subdirectory of the ftp home is owned by root and writeable only by root:"
         else
            echo "CNL.1.5.1.5 : WARNING - The etc subdirectory of the ftp home has incorrect permissions:"
         fi
         ls -ald $AnonFTPHome/etc >> $LOGFILE
         if [ -s $AnonFTPHome/etc/passwd ]; then
            cat /dev/null > CNL1515_temp
            for ID in `cat $AnonFTPHome/etc/passwd | grep -v "^#" | awk -F':' '{print $1}'`
            do
            IDfield2=`grep "^$ID:" $AnonFTPHome/etc/passwd | awk -F':' '{print $2}'`
            if [ -n $IDfield2 ]; then
               echo "$ID : $IDfield2" >> CNL1515_temp
            fi
            done
            if [ -s CNL1515_temp ]; then
               echo "CNL.1.5.1.5 : WARNING - The passwd file in $AnonFTPHome/etc contains entries in the password field:"
               cat CNL1515_temp >> $LOGFILE
            else
               echo "CNL.1.5.1.5 : The password fields in the passwd file residing in $AnonFTPHome/etc/passwd are all empty."
            fi
            rm -rf CNL1515_temp
         else
            echo "CNL.1.5.1.5 : There is no passwd file in $AnonFTPHome/etc/passwd."
         fi
      else
         echo "CNL.1.5.1.5 : N/A - The etc subdirectory of the ftp home does not exist."
      fi
      echo ""
      ls $AnonFTPHome | egrep -wvq 'bin|lib|etc'
      if ((!$?)); then
         cat /dev/null > CNL1516_temp
         for file in `ls $AnonFTPHome | egrep -wv 'bin|lib|etc'`
         do
         OWNER=`ls -ald $AnonFTPHome/$file | awk '{print $3}'`
         GROUP=`ls -ald $AnonFTPHome/$file | awk '{print $4}'`
         GRPWRITE=`ls -ald $AnonFTPHome/$file | awk '{print $1}' | cut -c6`
         GROUPID=`grep "^$GROUP:" /etc/group | awk -F':' '{print $3}'`
         OTHER=`ls -ald $AnonFTPHome/$file | awk '{print $1}' | cut -c8-10`
         if [ $OWNER != "root" ]; then
            ls -ald $AnonFTPHome/$file >> CNL1516_temp
         elif [ $GRPWRITE = "w" ]; then
            if [ $GROUPID -gt 99 ]; then
               ls -ald $AnonFTPHome/$file >> CNL1516_temp
            fi
         elif [[ $OTHER != "r-x" && $OTHER != "-wx" && $OTHER != "--x" && $OTHER != "---" ]]; then
            ls -ald $AnonFTPHome/$file >> CNL1516_temp
         fi
         done
         if [ -s CNL1516_temp ]; then
            echo "CNL.1.5.1.6 : WARNING - Some file(s) and/or subdirectory(ies) exist in $AnonFTPHome that do not meet iSeC requirements!"
            cat CNL1516_temp >> $LOGFILE
         else
            echo "CNL.1.5.1.6 : All file(s) and subdirectory(ies) in $AnonFTPHome meet iSeC requirements."
         fi
         rm -rf CNL1516_temp
      else
         echo "CNL.1.5.1.6 : N/A - No other files or subdirectories exist in $AnonFTPHome."
      fi
   else
      x=2
      until [ $x -eq 7 ]
      do
      echo "CNL.1.5.1.$x : N/A - The ftp home directory $AnonFTPHome does not exist."
      ((x+=1))
      done
   fi
   echo ""
   echo "CNL.1.5.1.7 : FTP access to dirs containing classified data...THIS SCRIPT CANNOT CHECK THIS SECTION!"
   echo ""
   echo "CNL.1.5.1.8 : Read or write access but not both via anonymous FTP...THIS SCRIPT CANNOT CHECK THIS SECTION!"
fi

echo ""
TFTPFound=1
if [ -f /etc/inetd.conf ]; then
   grep -wq "^tftp" /etc/inetd.conf
   if ((!$?)); then
      TFTPFound=0
      grep -w "^tftp" /etc/inetd.conf | grep -q "-s"
      if (($?)); then
         echo "CNL.1.5.2.1 : WARNING - TFTP is enabled but the '-s' parameter is not used:"
      else
         echo "CNL.1.5.2.1 : TFTP is enabled and the '-s' parameter is set correctly:"
      fi
      grep -w "^tftp" /etc/inetd.conf >> $LOGFILE
   fi
elif [ -f /etc/xinetd.d/tftp ]; then
   grep -w "disable" /etc/xinetd.d/tftp | grep -qi "no"
   if ((!$?)); then
      TFTPFound=0
      grep -w "server_args" /etc/xinetd.d/tftp | grep -q "-s"
      if ((!$?)); then
         echo "CNL.1.5.2.1 : TFTP is enabled and the '-s' parameter is set correctly:"
      else
         echo "CNL.1.5.2.1 : WARNING - TFTP is enabled but the '-s' parameter is not used:"
      fi
      grep -w "server_args" /etc/xinetd.d/tftp >> $LOGFILE
   fi
elif [ $TFTPFound -eq 1 ]; then
   echo "CNL.1.5.2.1 : N/A - TFTP is not enabled on this server."
fi

echo ""
if [ $TFTPFound -eq 1 ]; then
   echo "CNL.1.5.2.2 : N/A - TFTP is not enabled on this server."
else
   echo "CNL.1.5.2.2 : Access via TFTP and unclassified data...THIS SCRIPT CANNOT CHECK THIS SECTION!"
fi

echo ""
/bin/ps -eo comm | /bin/grep -w nfsd > /dev/null 2>&1
if ((!$?)); then
   if [ -f /etc/exports ]; then
      OWNER=`ls -al /etc/exports | awk '{print $3}'`
      PERMS=`ls -al /etc/exports | awk '{print $1}'`
      if [[ $OWNER = "root" ]] && [[ $PERMS = "-rw-r--r--" ]]; then
         echo "CNL.1.5.3.1 : NFS is running and the /etc/exports file exists with correct ownership and permissions:"
      else
         echo "CNL.1.5.3.1 : WARNING - NFS is running and the /etc/exports file has incorrect ownership and/or permissions:"
      fi
      ls -al /etc/exports >> $LOGFILE
      echo ""
      echo "CNL.1.5.3.2 : Classified data granted through NFS...THIS SCRIPT CANNOT CHECK THIS SECTION!"
      echo "CNL.1.5.3.2 : Here is the contents of the /etc/exports file:"
      cat /etc/exports >> $LOGFILE
   else
      echo "CNL.1.5.3.1 : WARNING - NFS is running and the /etc/exports file does NOT exist!"
      echo ""
      echo "CNL.1.5.3.2 : Classified data granted through NFS...THIS SCRIPT CANNOT CHECK THIS SECTION!"
   fi
else
   echo "CNL.1.5.3.1 : N/A - NFS Server is not active"
   echo ""
   echo "CNL.1.5.3.2 : N/A - NFS Server is not active"
fi

echo ""
if [ -f /etc/hosts.equiv ]; then
   cat /etc/hosts.equiv | grep -v "^#" | grep -vq "^\$"
   if ((!$?)); then
      echo "CNL.1.5.4.1 : WARNING - The /etc/hosts.equiv file exists and contains active entries:"
      cat /etc/hosts.equiv | grep -v "^#" | grep -vq "^\$" >> $LOGFILE
   else
      echo "CNL.1.5.4.1 : The /etc/hosts.equiv file does NOT contain any active entries."
   fi
else
   echo "CNL.1.5.4.1 : The /etc/hosts.equiv file does not exist."
fi

echo ""
if [ -s /etc/pam.d/rlogin ] || [ -s /etc/pam.d/rsh ]; then
   echo "CNL.1.5.4.2 : The /etc/pam.d/rlogin and/or /etc/pam.d/rsh file(s) exist."
   grep "/lib/security/pam_rhosts_auth.so" /etc/pam.d/system-auth | grep -vq "^#"
   if ((!$?)); then
      grep "/lib/security/pam_rhosts_auth.so" /etc/pam.d/system-auth | grep -v "^#" | grep -q "no_hosts_equiv"
      if (($?)); then
         echo "CNL.1.5.4.2 : WARNING - The /etc/pam.d/system-auth file contains the /lib/security/pam_rhosts_auth.so stanza, but does NOT contain the 'no_hosts_equiv' parameter!"
      else
         echo "CNL.1.5.4.2 : The /etc/pam.d/system-auth file contains the /lib/security/pam_rhosts_auth.so stanza, and contains the 'no_hosts_equiv' parameter."
      fi
      grep "/lib/security/pam_rhosts_auth.so" /etc/pam.d/system-auth | grep -v "^#" >> $LOGFILE
   else
      echo "CNL.1.5.4.2 : The /etc/pam.d/system-auth file does not contain the '/lib/security/pam_rhosts_auth.so' stanza."
   fi
else
   echo "CNL.1.5.4.2 : N/A - The /etc/pam.d/rlogin and /etc/pam.d/rsh files do not exist."
fi

echo ""
if [ -f /etc/inetd.conf ]; then
   grep -w rexd /etc/inetd.conf | grep -vq "^#"
   if ((!$?)); then
      echo "CNL.1.5.5 : WARNING - The rexd daemon is enabled in /etc/inetd.conf!"
      grep -w rexd /etc/inetd.conf | grep -v "^#" >> $LOGFILE
   else
      echo "CNL.1.5.5 : The rexd daemon is NOT enabled in /etc/inetd.conf."
   fi
else
   echo "CNL.1.5.5 : The /etc/inetd.conf file does not exist."
fi
if [ -s /etc/xinetd.d/rexd ]; then
   cat /etc/xinetd.d/rexd | grep "disable =" | grep -q "no"
   if (($?)); then
      echo "CNL.1.5.5 : WARNING - The rexd daemon is enabled in /etc/xinetd.d/rexd!"
   else
      echo "CNL.1.5.5 : The rexd daemon is NOT enabled in /etc/xinetd.d"
   fi
else
   echo "CNL.1.5.5 : The rexd daemon is NOT enabled in /etc/xinetd.d"
fi

echo ""
chkconfig --list | grep -wq innd
if (($?)); then
   echo "CNL.1.5.6 : N/A - NNTP is not configured or running on this server."
else
   echo "CNL.1.5.6 : WARNING - NNTP is configured on this server. THIS SCRIPT CANNOT CHECK FOR CLASSIFIED CONFIDENTIAL DATA!"
fi

echo ""
if [ -f /usr/bin/xhost ]; then
   xfile=`stat -t --format=%A /usr/bin/xhost | cut -c10`
   if [ $xfile == x ]; then
      echo "CNL.1.5.7 : WARNING - /usr/bin/xhost is world-executable, Xserver Access control not OK."
   else
      echo "CNL.1.5.7 : X-Window access control is OK and is not disabled."
   fi
else
   echo "CNL.1.5.7 : WARNING - /usr/bin/xhost file does not exist. Unable to check Xserver Access control!"
fi

echo ""
X=1
for setting in chargen daytime discard echo finger systat who netstat
do
CHECK=0
if [ -f /etc/inetd.conf ]; then
   cat /etc/inetd.conf | grep -v "^#" | grep -wq "^$setting"
   if ((!$?)); then
      echo "CNL.1.5.8.$X : WARNING - $setting is enabled in /etc/inetd.conf. Unable to determine if this is an internet server."
      cat /etc/inetd.conf | grep -v "^#" | grep -w "^$setting" >> $LOGFILE
      CHECK=1
   fi
fi
chkconfig --list | grep -w $setting | grep -wq "on"
if ((!$?)); then
   echo "CNL.1.5.8.$X : WARNING - $setting is enabled in xinetd. Unable to determine if this is an internet server."
   chkconfig --list | grep -w $setting | grep -w "on" >> $LOGFILE
   CHECK=1
fi
if ((!$CHECK)); then
   echo "CNL.1.5.8.$X : $setting is disabled on this server."
fi
((X+=1))
echo ""
done

X=1
for setting in echo chargen rstatd tftp rwalld rusersd discard daytime bootps finger sprayd pcnfsd netstat rwho cmsd dtspcd ttdbserver
do
CHECK=0
if [ -f /etc/inetd.conf ]; then
   cat /etc/inetd.conf | grep -v "^#" | grep -wq "^$setting"
   if ((!$?)); then
      echo "CNL.1.5.9.$X : WARNING - $setting is enabled in /etc/inetd.conf."
      cat /etc/inetd.conf | grep -v "^#" | grep -w "^$setting" >> $LOGFILE
      CHECK=1
   fi
fi
chkconfig --list | grep -w $setting | grep -wq "on"
if ((!$?)); then
   echo "CNL.1.5.9.$X : WARNING - $setting is enabled in xinetd."
   chkconfig --list | grep -w $setting | grep -w "on" >> $LOGFILE
   CHECK=1
fi
if ((!$CHECK)); then
   echo "CNL.1.5.9.$X : $setting is disabled on this server."
fi
((X+=1))
echo ""
done

ps -ef | grep snmpd | grep -vq grep
if ((!$?)); then
   if [ -f /etc/snmp/snmpd.conf ]; then
      cat /etc/snmp/snmpd.conf | grep -v "^#" | grep -w "^com2sec" | egrep -w 'publicsec|notConfigUser' | grep -w default | grep -wq public
      if ((!$?)); then
         echo "CNL.1.5.9.18 : WARNING - SNMP is active and community name of 'public' appears in /etc/snmp/snmpd.conf"
         cat /etc/snmp/snmpd.conf | grep -v "^#" | grep -w "^com2sec" | egrep -w 'publicsec|notConfigUser' | grep -w default | grep -w public >> $LOGFILE
      else
         echo "CNL.1.5.9.18 : SNMP is active and community name of 'public' does NOT apppear in /etc/snmp/snmpd.conf."
      fi
   else
      echo "CNL.1.5.9.18 : WARNING - SNMP is active and the /etc/snmp/snmpd.conf file cannot be found. By default community name of 'public' will be allowed!"
   fi
else
   echo "CNL.1.5.9.18 : N/A - SNMP is not active on this server."
fi

echo ""
ps -ef | grep snmpd | grep -vq grep
if ((!$?)); then
   if [ -f /etc/snmp/snmpd.conf ]; then
      cat /etc/snmp/snmpd.conf | grep -v "^#" | grep -w "^com2sec" | egrep -w 'publicsec|notConfigUser' | grep -w default | grep -wq private
      if ((!$?)); then
         echo "CNL.1.5.9.19 : WARNING - SNMP is active and community name of 'private' appears in /etc/snmp/snmpd.conf"
         cat /etc/snmp/snmpd.conf | grep -v "^#" | grep -w "^com2sec" | egrep -w 'publicsec|notConfigUser' | grep -w default | grep -w private >> $LOGFILE
      else
         echo "CNL.1.5.9.19 : SNMP is active and community name of 'private' does NOT apppear in /etc/snmp/snmpd.conf."
      fi
   else
      echo "CNL.1.5.9.19 : WARNING - SNMP is active and the /etc/snmp/snmpd.conf file cannot be found!"
   fi
else
   echo "CNL.1.5.9.19 : N/A - SNMP is not active on this server."
fi

echo ""
if [ -f /etc/sysctl.conf ]; then
   cat /etc/sysctl.conf | grep -v "^#" | grep "net.ipv4.tcp_syncookies" | grep -q 1
   if ((!$?)); then
      echo "CNL.1.5.9.20 : The paramter 'net.ipv4.tcp_syncookies = 1' exists in /etc/sysctl.conf:"
      cat /etc/sysctl.conf | grep -v "^#" | grep "net.ipv4.tcp_syncookies" | grep 1 >> $LOGFILE
   else
      echo "CNL.1.5.9.20 : WARNING - The paramter 'net.ipv4.tcp_syncookies = 1' does NOT exist in /etc/sysctl.conf!"
   fi
   echo ""
   cat /etc/sysctl.conf | grep -v "^#" | grep "net.ipv4.icmp_echo_ignore_broadcasts" | grep -q 1
   if ((!$?)); then
      echo "CNL.1.5.9.21 : The paramter 'net.ipv4.icmp_echo_ignore_broadcasts = 1' exists in /etc/sysctl.conf:"
      cat /etc/sysctl.conf | grep -v "^#" | grep "net.ipv4.icmp_echo_ignore_broadcasts" | grep 1 >> $LOGFILE
   else
      echo "CNL.1.5.9.21 : WARNING - The paramter 'net.ipv4.icmp_echo_ignore_broadcasts = 1' does NOT exist in /etc/sysctl.conf!"
   fi
   echo ""
   cat /etc/sysctl.conf | grep -v "^#" | grep "net.ipv4.conf.all.accept_redirects" | grep -q 0
   if ((!$?)); then
      echo "CNL.1.5.9.22 : The paramter 'net.ipv4.conf.all.accept_redirects = 1' exists in /etc/sysctl.conf:"
      cat /etc/sysctl.conf | grep -v "^#" | grep "net.ipv4.conf.all.accept_redirects" | grep 0 >> $LOGFILE
   else
      echo "CNL.1.5.9.22 : WARNING - The paramter 'net.ipv4.conf.all.accept_redirects = 0' does NOT exist in /etc/sysctl.conf!"
   fi
else
   X=20
   until [ $X -eq 23 ]
   do
   echo "CNL.1.5.9.$X : WARNING - The /etc/sysctl.conf file canNOT be found!"
   ((X+=1))
   done
fi

TELNETFound=1
if [ -f /etc/inetd.conf ]; then
   grep -wq "^telnet" /etc/inetd.conf
   if ((!$?)); then
      TELNETFound=0
      echo "CNL.1.5.9.23 : WARNING - Telnet is enabled in /etc/inetd.conf"
      grep -w "^telnet" /etc/inetd.conf >> $LOGFILE
   fi
elif [ -f /etc/xinetd.d/telnet ]; then
   cat /etc/xinetd.d/telnet | grep -v "^#" | grep -w "disable" /etc/xinetd.d/telnet | grep -qi "no"
   if ((!$?)); then
      TELNETFound=0
      echo "CNL.1.5.9.23 : WARNING - Telnet is enabled in /etc/xinetd.d/telnet"
      egrep -w 'service|disable' /etc/xinetd.d/telnet >> $LOGFILE
   fi
elif (($TELNETFound)); then
   echo "CNL.1.5.9.23 : N/A - Telnet is not installed on this server."
fi

FTPEnabled=1
#if (($FTPEnabled)); then
if ((!$FTPEnabled)); then
   echo "CNL.1.5.9.24 : WARNING - FTP is enabled on this server!"
else
   echo "CNL.1.5.9.24 : FTP is not enabled on this server."
fi

##We need to add a little blurb here since some OS (i.e. SuSE) will
##put out a bogus error I can't get rid of to the screen

if (($TCNLDMSIL)); then
# if ((!$TCNLDMSIL)); then
   echo 1 > /tmp/isec_question_prompt
   sleep 6
   echo -e "\nDoing some service status checks now."
   echo -e "On some Linux OS, this will cause an error to display to the screen"
   echo -e "which will say \"..dead\" or similar. Please IGNORE this error"
   echo -e "as it does not impact this script or its functionality.\n"
   echo 0 > /tmp/isec_question_prompt
   sleep 5
fi



echo ""
service --status-all | grep yppasswd | grep -q "running"
if ((!$?)); then
   echo "CNL.1.5.10.1 : WARNING - The yppasswd daemon is running!"
   service --status-all | grep yppasswd | grep "running" >> $LOGFILE
else
   echo "CNL.1.5.10.1 : The yppasswd daemon is disabled."
fi

echo ""
rpcinfo -u `hostname` ypserv > /dev/null 2>&1
if (($?)); then
   echo "CNL.1.5.10.2 : N/A - NIS is not running on this server."
else
   echo "CNL.1.5.10.2 : WARNING - NIS is running on this server..."
   echo "CNL.1.5.10.2 : NIS maps used to store Confidential data...THIS SCRIPT CANNOT CHECK THIS SECTION!"
fi

echo ""
rpcinfo -u `hostname` ypserv > /dev/null 2>&1
if (($?)); then
   echo "CNL.1.5.11 : N/A - NIS is not running on this server."
else
   echo "CNL.1.5.11 : WARNING - NIS is running on this server."
   echo "CNL.1.5.11 : NIS+ maps storing confidential data...THIS SCRIPT CANNOT CHECK THIS SECTION!"
fi

echo ""
X=2
for proc in rlogin rsh sendmail
do
if [ -x /sbin/service ]; then
   service --status-all | grep $proc | grep -q "running"
   if ((!$?)); then
      echo $proc | grep -q sendmail
      if ((!$?)); then
         ps -ef | grep "sendmail" | grep -q "\-bd"
         if ((!$?)); then
            echo "CNL.1.5.12.$X : The service sendmail -bd is running. Unable to determine if this is a secure internal network!"
            ps -ef | grep "sendmail" | grep "\-bd" >> $LOGFILE
         else
            echo "CNL.1.5.12.$X : The service sendmail is running, but without the '-bd' option."
            ps -ef|grep "sendmail"  >> $LOGFILE
         fi
      else
         echo "CNL.1.5.12.$X : The service $proc is running. Unable to determine if this is a secure internal network!"
         service --status-all | grep $proc | grep "running" >> $LOGFILE
      fi
   elif chkconfig --list | grep $proc | grep -q on; then
      echo $proc | grep -q sendmail
      if ((!$?)); then
         ps -ef | grep "sendmail" | grep -q "\-bd"
         if ((!$?)); then
            echo "CNL.1.5.12.$X : The service sendmail -bd is running. Unable to determine if this is a secure internal network!"
            ps -ef | grep "sendmail" | grep "\-bd" >> $LOGFILE
         else
            echo "CNL.1.5.12.$X : The service sendmail is running, but without the '-bd' option."
            ps -ef|grep "sendmail" >> $LOGFILE
         fi
      else
         echo "CNL.1.5.12.$X : The service $proc is running. Unable to determine if this is a secure internal network!"
         chkconfig --list | grep $proc | grep on >> $LOGFILE
      fi
   else
      echo "CNL.1.5.12.$X : N/A - The service $proc is not running."
   fi
else
   if chkconfig --list | grep $proc | grep -q on; then
      echo $proc | grep -q sendmail
      if ((!$?)); then
         ps -ef | grep "sendmail" | grep -q "\-bd"
         if ((!$?)); then
            echo "CNL.1.5.12.$X : The service sendmail -bd is running. Unable to determine if this is a secure internal network!"
            ps -ef | grep "sendmail" | grep "\-bd" >> $LOGFILE
         else
            echo "CNL.1.5.12.$X : The service sendmail is running, but without the '-bd' option."
            ps -ef|grep "sendmail" >> $LOGFILE
         fi
      else
         echo "CNL.1.5.12.$X : The service $proc is running. Unable to determine if this is a secure internal network!"
         chkconfig --list | grep $proc | grep on >> $LOGFILE
      fi
   else
      echo "CNL.1.5.12.$X : N/A - The service $proc is not running."
   fi
fi
echo ""
((X+=1))
done

echo ""
echo ""


