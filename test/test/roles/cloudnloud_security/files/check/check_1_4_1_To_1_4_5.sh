#echo "1.4 System Settings"
#echo "==================="
LOGFILE=/tmp/file.txt
FTPEnabled=1
if [ `id -unr` = "root" ]; then
   echo ""
   if [ -f /etc/redhat-release ]; then 
      OSFlavor=RedHat
   elif [ -f /etc/SuSE-release ]; then
      OSFlavor=SuSE
   else
      exit
   fi
else
   exit 1
   echo ""
fi




if [ -f /etc/redhat-release ]; then 
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
cat /dev/null > CNL.1.4.1_temp
CNL141check=0
cat /etc/pam.d/other | grep "^auth" | grep "required" | grep -q "pam_deny.so"
if (($?)); then
   CNL141check=1
else
   cat /etc/pam.d/other | grep "^auth" | grep "required" | grep "pam_deny.so" >> CNL.1.4.1_temp
fi
cat /etc/pam.d/other | grep "^account" | grep "required" | grep -q "pam_deny.so"
if (($?)); then
   CNL141check=1
else
   cat /etc/pam.d/other | grep "^account" | grep "required" | grep "pam_deny.so" >> CNL.1.4.1_temp
fi
if (($CNL141check)); then
   echo "CNL.1.4.1 : WARNING - One or both required entries in /etc/pam.d/other are missing!"
   if [ -s CNL.1.4.1_temp ]; then
      echo "CNL.1.4.1 : Here is what was found in /etc/pam.d/other:"
   fi
else
   echo "CNL.1.4.1 : Both required entries in /etc/pam.d/other are configured:"
fi
cat CNL.1.4.1_temp >> $LOGFILE
rm -rf CNL.1.4.1_temp
if [ $OSFlavor = "RedHat" ] && [ $RHVER -ge 6 ]; then
   if [ -f /etc/pam.d/system-auth ]; then
      CNL141check=0
      cat /dev/null > CNL.1.4.1_temp
      cat /etc/pam.d/password-auth | grep "^auth" | grep "required" | grep -q "pam_deny.so"
      if (($?)); then
         CNL141check=1
      else
         cat /etc/pam.d/password-auth | grep "^auth" | grep "required" | grep "pam_deny.so" >> CNL.1.4.1_temp
      fi
      cat /etc/pam.d/password-auth | grep "^account" | grep "required" | grep -q "pam_deny.so"
      if (($?)); then
         CNL141check=1
      else
         cat /etc/pam.d/password-auth | grep "^account" | grep "required" | grep "pam_deny.so" >> CNL.1.4.1_temp
      fi
      if (($CNL141check)); then
         echo "CNL.1.4.1 : WARNING - One or both required entries in /etc/pam.d/password-auth are missing!"
         if [ -s CNL.1.4.1_temp ]; then
            echo "CNL.1.4.1 : Here is what was found in /etc/pam.d/password-auth:"
         fi
      else
         echo "CNL.1.4.1 : Both required entries in /etc/pam.d/password-auth are configured:"
      fi
      cat CNL.1.4.1_temp >> $LOGFILE
      rm -rf CNL.1.4.1_temp
   else
      echo "CNL.1.4.1 : The /etc/pam.d/system-auth file is not in use."
   fi
else
   echo "CNL.1.4.1 : Note that this is not a RHEL V6 or later OS."
fi

FTPEnabled=1
if ((!$FTPEnabled)); then
#if (($FTPEnabled)); then
   if [ -f $FTPfile ]; then
      grep -q "^root" $FTPfile
      if (($?)); then
         echo "CNL.1.4.2 : WARNING - User root does NOT exist in $FTPfile"
      else
         echo "CNL.1.4.2 : User root exists in $FTPfile"
      fi
   else
      echo "CNL.1.4.2 : WARNING - This server has $FTPType installed and enabled, but the $FTPfile file does not exist!"
   fi
else
   echo "CNL.1.4.2 : N/A - FTP is not installed and enabled on this server."
fi

echo ""
cat /dev/null > CNL143_temp
for ID in `cat /etc/passwd | awk -F':' '{print $1}'`
do
FIELD2=`grep "^$ID:" /etc/passwd | awk -F':' '{print $2}'`
if [ $FIELD2 != "x" ]; then
   echo "$ID : $FIELD2" >> CNL143_temp
fi
done
if [ -s CNL143_temp ]; then
   echo "CNL.1.4.3 : WARNING - The /etc/passwd file appears to contain entry(ies) in field 2 that are not shadowed passwords:"
   cat CNL143_temp >> $LOGFILE
else
   echo "CNL.1.4.3 : All entries in the /etc/passwd file are shadowed and no password(s) were found."
fi
rm -rf CNL143_temp

echo ""
cat /dev/null > CNL144_temp
for ID in `cat /etc/shadow | awk -F':' '{print $1}'`
do
IDPasswd=`grep "^$ID:" /etc/shadow | awk -F':' '{print $2}'`
if [[ -z $IDPasswd ]]; then
   echo $ID >> CNL144_temp
fi
done
if [ -s CNL144_temp ]; then
   echo "CNL.1.4.4 : WARNING - Some ID(s) exist that appear to have no encrypted password in /etc/shadow:"
   cat CNL144_temp >> $LOGFILE
else
   echo "CNL.1.4.4 : All ID(s) appear to have encrypted password(s) in /etc/shadow."
fi
#rm -rf CNL144_temp

echo "CNL.1.4.5 : Anonymous FTP files stored into a writeable directory...THIS SCRIPT CANNOT CHECK THIS SECTION!"
rm -rf CNL144_temp $LOGFILE
