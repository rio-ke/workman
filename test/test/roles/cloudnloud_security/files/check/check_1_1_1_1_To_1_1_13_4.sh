#echo "1.1.x Password Requirements"
#echo "==========================="

LOGFILE=/tmp/file12.txt
#FTPEnabled=1

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






PMD=`cat /etc/login.defs |grep "^PASS_MAX_DAYS" | awk '{print $2}'`
if [ $PMD -le 90 ] ; then
   echo "CNL.1.1.1.1 : The default PASS_MAX_DAYS is OK"
else
   echo "CNL.1.1.1.1 : WARNING - The default PASS_MAX_DAYS is set incorrrectly to: $PMD"
fi
cat /etc/login.defs |grep "^PASS_MAX_DAYS" >> $LOGFILE

echo ""
cat /dev/null > PMDTestOut
for TestUser in `cat /etc/shadow | grep -v "^#" | awk -F':' '{print $1}'`
do
TestUserPasswd=`grep "^$TestUser:" /etc/shadow | awk -F':' '{print $2}'`
echo $TestUserPasswd | grep -q "^!"
TestUserPasswdLocked=$?
TestUserGID=`grep "^$TestUser:" /etc/passwd | awk -F':' '{print $4}'`
TestUserPMD=`grep "^$TestUser:" /etc/shadow | awk -F':' '{print $5}'`
if [[ $OSFlavor = "RedHat" && $RHVER -le 5 ]] || [[ $OSFlavor = "SuSE" && $SVER -le 9 ]] || [[ $SVER = "X" && $RHVER = "X" ]]; then
   if [[ $TestUserPasswd != "*" && $TestUserPasswdLocked -eq 1 && $TestUserPasswd != "LK" ]] && [[ $TestUserGID -gt 99 ]]; then
      if [[ $TestUserPMD -gt 90 ]] || [[ -z $TestUserPMD ]] ; then
         echo "ID=$TestUser : PASS_MAX_DAYS=$TestUserPMD" >> PMDTestOut
      fi
   fi
else
   if [[ $TestUserPasswd != "*" && $TestUserPasswdLocked -eq 1 && $TestUserPasswd != "LK" ]] && [[ $TestUserGID -gt 199 ]]; then
      if [[ $TestUserPMD -gt 90 ]] || [[ -z $TestUserPMD ]] ; then
         echo "ID=$TestUser : PASS_MAX_DAYS=$TestUserPMD" >> PMDTestOut
      fi
   fi
fi
done
if [ -s PMDTestOut ]; then
   echo "CNL.1.1.1.2 : WARNING - User(s) exist with PASS_MAX_DAYS field not set or greater than 90:"
   cat PMDTestOut >> $LOGFILE
else
   echo "CNL.1.1.1.2 : All users have PASS_MAX_DAYS field set to 90 or less, or are locked."
   rm PMDTestOut
fi


echo ""
##Updated iSeC 3.0B REMOVES the option to use /etc/login.defs and can now only use
##files in the /etc/pam.d directory!
#Base tech spec says only 1 of 3 options needs to be satisfied (for RH only)iSeC v2.x:
#PML=`grep "^PASS_MIN_LEN" /etc/login.defs | awk '{print $2}'`
#if [[ -z $PML ]]; then
#   echo "CNL.1.1.2 : The PASS_MIN_LEN is not configured in /etc/login.defs"
#   OPTION=1
#elif [[ $PML -lt 8 ]]; then
#   echo "CNL.1.1.2 : The PASS_MIN_LEN in /etc/login.defs is: $PML"
#   OPTION=1
#else
#   echo "CNL.1.1.2 : The PASS_MIN_LEN in /etc/login.defs is: $PML"
#   OPTION=0
#fi
#grep "^PASS_MIN_LEN" /etc/login.defs >> $LOGFILE
##Force it to do a pam.d check now:
OPTION=1
if (($OPTION)); then
   if [ -f /etc/pam.d/system-auth ]; then
      cat /etc/pam.d/system-auth | grep -v "^#" | grep "^password" | grep "required" | grep "pam_cracklib.so" | grep "retry=3" | grep "minlen=8" | grep "dcredit=-1" | grep "ucredit=0" | grep "lcredit=-1" | grep "ocredit=0" | grep "type=reject_username" > /dev/null 2>&1
      if (($?)); then
         echo "CNL.1.1.2 : The retry/minlen/dcredit/ucredit/lcredit/ocredit/type settings are NOT all configured in /etc/pam.d/system-auth"
         OPTION=1
         OPTION1=1
      else
         echo "CNL.1.1.2 : The retry/minlen/dcredit/ucredit/lcredit/ocredit/type settings are all configured in /etc/pam.d/system-auth :"
         cat /etc/pam.d/system-auth | grep -v "^#" | grep "^password" | grep "required" | grep "pam_cracklib.so" | grep "retry=3" | grep "minlen=8" | grep "dcredit=-1" | grep "ucredit=0" | grep "lcredit=-1" | grep "ocredit=0" | grep "type=reject_username" >> $LOGFILE
         OPTION=0
         OPTION1=0
      fi
      if (($OPTION)); then
         cat /etc/pam.d/system-auth | grep -v "^#" | grep "^password" | grep "required" | grep "pam_passwdqc.so" | grep "min=disabled,8,8,8,8" | grep "passphrase=0" | grep "random=0" | grep "enforce=everyone" > /dev/null 2>&1
         if (($?)); then
            echo "CNL.1.1.2 : The min/passphrase/random/enforce settings are NOT all configured in /etc/pam.d/system-auth"
            OPTION=1
            OPTION2=1
         else
            echo "CNL.1.1.2 : The min/passphrase/random/enforce settings are all configured in /etc/pam.d/system-auth :"
            cat /etc/pam.d/system-auth | grep -v "^#" | grep "^password" | grep "required" | grep "pam_passwdqc.so" | grep "min=disabled,8,8,8,8" | grep "passphrase=0" | grep "random=0" | grep "enforce=everyone" >> $LOGFILE
            OPTION=0
            OPTION2=0
         fi
      fi
      if [ $OSFlavor = "RedHat" ] && [ $RHVER -ge 6 ]; then
         if ((!$OPTION)); then
            if [ -f /etc/pam.d/password-auth ]; then
               if ((!$OPTION1)); then
                  cat /etc/pam.d/password-auth | grep -v "^#" | grep "^password" | grep "required" | grep "pam_cracklib.so" | grep "retry=3" | grep "minlen=8" | grep "dcredit=-1" | grep "ucredit=0" | grep "lcredit=-1" | grep "ocredit=0" | grep "type=reject_username" > /dev/null 2>&1
                  if (($?)); then
                     echo "CNL.1.1.2 : The retry/minlen/dcredit/ucredit/lcredit/ocredit/type settings are NOT also configured in /etc/pam.d/password-auth"
                     OPTION=1
                  else
                     echo "CNL.1.1.2 : The retry/minlen/dcredit/ucredit/lcredit/ocredit/type settings are all also configured in /etc/pam.d/password-auth :"
                     cat /etc/pam.d/password-auth | grep -v "^#" | grep "^password" | grep "required" | grep "pam_cracklib.so" | grep "retry=3" | grep "minlen=8" | grep "dcredit=-1" | grep "ucredit=0" | grep "lcredit=-1" | grep "ocredit=0" | grep "type=reject_username" >> $LOGFILE
                     OPTION=0
                  fi
               else
                  cat /etc/pam.d/password-auth | grep -v "^#" | grep "^password" | grep "required" | grep "pam_passwdqc.so" | grep "min=disabled,8,8,8,8" | grep "passphrase=0" | grep "random=0" | grep "enforce=everyone" > /dev/null 2>&1
                  if (($?)); then
                     echo "CNL.1.1.2 : The min/passphrase/random/enforce settings are NOT also configured in /etc/pam.d/password-auth"
                     OPTION=1
                  else
                     echo "CNL.1.1.2 : The min/passphrase/random/enforce settings are also configured in /etc/pam.d/password-auth :"
                     cat /etc/pam.d/password-auth | grep -v "^#" | grep "^password" | grep "required" | grep "pam_passwdqc.so" | grep "min=disabled,8,8,8,8" | grep "passphrase=0" | grep "random=0" | grep "enforce=everyone" >> $LOGFILE
                     OPTION=0
                  fi
               fi
            else
               echo "CNL1.1.2 : The /etc/pam.d/system-auth file does not exist!"
               OPTION=1
            fi
         fi
      else
         echo "CNL.1.1.2 : Note that this is not a RHEL V6 or later OS."
      fi
   else
      echo "CNL.1.1.2 : The /etc/pam.d/system-auth file does not exist."
   fi
   if (($OPTION)); then
      if [ $OSFlavor = "SuSE" ] && [ $SVER -ge 9 ]; then
         if [ -f /etc/security/pam_pwcheck.conf ]; then
            cat /etc/security/pam_pwcheck.conf | grep -v "^#" | grep "minlen" > /dev/null 2>&1
            if ((!$?)); then
               echo "CNL.1.1.2 : The minlen setting was found in /etc/security/pam_pwcheck.conf:"
               cat /etc/security/pam_pwcheck.conf | grep -v "^#" | grep "minlen" >> $LOGFILE
               echo "PLEASE VERIFY IF THE SETTING IS CORRECT!"
            else
               echo "CNL.1.1.2 : The minlen setting was NOT found in /etc/security/pam_pwcheck.conf!"
            fi
         fi
      fi
   fi
fi
if ((!$OPTION)); then
   echo "CNL.1.1.2 : The PASS_MIN_LEN parameter is set correctly."
else
   echo "CNL.1.1.2 : WARNING - The PASS_MIN_LEN parameter is not set correctly!"
fi

echo ""
MPA=`grep "^PASS_MIN_DAYS" /etc/login.defs | awk '{print $2}'`
if [[ -z $MPA ]]; then
   echo "CNL.1.1.3.1 : WARNING - The PASS_MIN_DAYS parameter does not exist in /etc/login.defs"
elif [ $MPA -ne 1 ]; then
   echo "CNL.1.1.3.1 : WARNING - The PASS_MIN_DAYS parameter is NOT set incorrectly!"
   grep "^PASS_MIN_DAYS" /etc/login.defs >> $LOGFILE
else
   echo "CNL.1.1.3.1 : The PASS_MIN_DAYS parameter is set correctly."
   grep "^PASS_MIN_DAYS" /etc/login.defs >> $LOGFILE
fi

echo ""
cat /dev/null > MPATestOut
for TestUser in `cat /etc/shadow | grep -v "^#" | awk -F':' '{print $1}'`
do
TestUserPasswd=`grep "^$TestUser:" /etc/shadow | awk -F':' '{print $2}'`
echo $TestUserPasswd | grep -q "^!"
TestUserPasswdLocked=$?
TestUserMPA=`grep "^$TestUser:" /etc/shadow | awk -F':' '{print $4}'`
if [[ $TestUserPasswd != "*" ]] && [[ $TestUserPasswdLocked -eq 1 ]] && [[ $TestUserPasswd != "LK" ]]; then
   if [[ -z $TestUserMPA ]] || [[ $TestUserMPA -ne 1 ]]; then
      echo "$TestUser : $TestUserMPA" >> MPATestOut
   fi
fi
done
if [ -s MPATestOut ]; then
   echo "CNL.1.1.3.2 : WARNING - User(s) exist with PASS_MIN_DAYS field not set to 1:"
   cat MPATestOut >> $LOGFILE
else
   echo "CNL.1.1.3.2 : All users with a password assigned have PASS_MIN_DAYS field set to 1."
fi
rm MPATestOut

if [ $OSFlavor = "RedHat" ]; then
   echo ""
   if [ -f /etc/pam.d/system-auth ]; then
      grep "^password" /etc/pam.d/system-auth | egrep 'sufficient|required' | grep "pam_unix.so" | grep "remember=7" | grep "use_authtok" | egrep 'md5|sha512' | grep "shadow" > /dev/null 2>&1
      if (($?)); then
         echo "CNL.1.1.4.1 : WARNING - The password history settings are not configured in /etc/pam.d/system-auth"
         OPTION=1
      else
         echo "CNL.1.1.4.1 : The password history settings are configured in /etc/pam.d/system-auth"
         grep "^password" /etc/pam.d/system-auth | egrep 'sufficient|required' | grep "pam_unix.so" | grep "remember=7" | grep "use_authtok" | egrep 'md5|sha512' | grep "shadow" >> $LOGFILE
         OPTION=0
      fi
      if [ $OSFlavor = "RedHat" ] && [ $RHVER -ge 6 ]; then
         if ((!$OPTION)); then
            if [ -f /etc/pam.d/password-auth ]; then
               grep "^password" /etc/pam.d/password-auth | egrep 'sufficient|required' | grep "pam_unix.so" | grep "remember=7" | grep "use_authtok" | egrep 'md5|sha512' | grep "shadow" > /dev/null 2>&1
               if (($?)); then
                  echo "CNL.1.1.4.1 : WARNING - The password history settings are not configured in /etc/pam.d/password-auth"
               else
                  echo "CNL.1.1.4.1 : The password history settings are configured in /etc/pam.d/password-auth"
                  grep "^password" /etc/pam.d/password-auth | egrep 'sufficient|required' | grep "pam_unix.so" | grep "remember=7" | grep "use_authtok" | egrep 'md5|sha512' | grep "shadow" >> $LOGFILE
               fi
            else
               echo "CNL.1.1.4.1 : WARNING - The /etc/pam.d/password-auth file does NOT exist!"
            fi
         fi
      else
         echo "CNL.1.1.4.1 : Note that this is not a RHEL V6 or later OS."
      fi
   else
      echo "CNL.1.1.4.1 : The /etc/pam.d/system-auth file does not exist. Checking other control files...."
      if [ -f /etc/pam.d/login ]; then
         grep "^password" /etc/pam.d/login | egrep 'sufficient|required' | grep "pam_unix.so" | grep "remember=7" | grep "use_authtok" | egrep 'md5|sha512' | grep "shadow" > /dev/null 2>&1
         if (($?)); then
            echo "CNL.1.1.4.1 : WARNING - The password history settings are not configured in /etc/pam.d/login"
         else
            echo "CNL.1.1.4.1 : The password history settings are configured in /etc/pam.d/login"
            grep "^password" /etc/pam.d/login | egrep 'sufficient|required' | grep "pam_unix.so" | grep "remember=7" | grep "use_authtok" | egrep 'md5|sha512' | grep "shadow" >> $LOGFILE
         fi
      else
         echo "CNL.1.1.4.1 : WARNING - The /etc/pam.d/login file does not exist."
      fi
      if [ -f /etc/pam.d/passwd ]; then
         grep "^password" /etc/pam.d/passwd | egrep 'sufficient|required' | grep "pam_unix.so" | grep "remember=7" | grep "use_authtok" | egrep 'md5|sha512' | grep "shadow" > /dev/null 2>&1
         if (($?)); then
            echo "CNL.1.1.4.1 : WARNING - The password history settings are not configured in /etc/pam.d/passwd"
         else
            echo "CNL.1.1.4.1 : The password history settings are configured in /etc/pam.d/passwd"
            grep "^password" /etc/pam.d/passwd | egrep 'sufficient|required' | grep "pam_unix.so" | grep "remember=7" | grep "use_authtok" | egrep 'md5|sha512' | grep "shadow" >> $LOGFILE
         fi
      else
         echo "CNL.1.1.4.1 : WARNING - The /etc/pam.d/passwd file does not exist."
      fi
      if [ -f /etc/pam.d/sshd ]; then
         grep "^password" /etc/pam.d/sshd | egrep 'sufficient|required' | grep "pam_unix.so" | grep "remember=7" | grep "use_authtok" | egrep 'md5|sha512' | grep "shadow" > /dev/null 2>&1
         if (($?)); then
            echo "CNL.1.1.4.1 : WARNING - The password history settings are not configured in /etc/pam.d/sshd"
         else
            echo "CNL.1.1.4.1 : The password history settings are configured in /etc/pam.d/sshd"
            grep "^password" /etc/pam.d/sshd | egrep 'sufficient|required' | grep "pam_unix.so" | grep "remember=7" | grep "use_authtok" | egrep 'md5|sha512' | grep "shadow" >> $LOGFILE
         fi
      else
         echo "CNL.1.1.4.1 : WARNING - The /etc/pam.d/sshd file does not exist."
      fi
      if [ -f /etc/pam.d/su ]; then
         grep "^password" /etc/pam.d/su | egrep 'sufficient|required' | grep "pam_unix.so" | grep "remember=7" | grep "use_authtok" | egrep 'md5|sha512' | grep "shadow" > /dev/null 2>&1
         if (($?)); then
            echo "CNL.1.1.4.1 : WARNING - The password history settings are not configured in /etc/pam.d/su"
         else
            echo "CNL.1.1.4.1 : The password history settings are configured in /etc/pam.d/su"
            grep "^password" /etc/pam.d/su | egrep 'sufficient|required' | grep "pam_unix.so" | grep "remember=7" | grep "use_authtok" | egrep 'md5|sha512' | grep "shadow" >> $LOGFILE
         fi
      else
         echo "CNL.1.1.4.1 : WARNING - The /etc/pam.d/su file does not exist."
      fi
   fi
else
   echo ""
   echo "CNL.1.1.4.1 : N/A - This is a $OSFlavor server."
fi

if [ $OSFlavor = "SuSE" ]; then
   echo ""
   if [ -f /etc/pam.d/common-password ]; then
      grep "^password" /etc/pam.d/common-password | egrep 'sufficient|required' | grep "pam_unix_passwd.so" | grep "remember=7" | grep "use_authtok" | egrep 'md5|sha512' | grep "shadow" > /dev/null 2>&1
      if (($?)); then
         SUSEOption2=1
      else
         echo "CNL.1.1.4.2 : The password history settings are configured in /etc/pam.d/common-password"
         grep "^password" /etc/pam.d/common-password | egrep 'sufficient|required' | grep "pam_unix_passwd.so" | grep "remember=7" | grep "use_authtok" | egrep 'md5|sha512' | grep "shadow" >> $LOGFILE
         SUSEOption2=0
      fi
      if (($SUSEOption2)); then
         grep "^password" /etc/pam.d/common-password | egrep 'sufficient|required' | grep "pam_unix2.so" | egrep 'md5|sha512' > /dev/null 2>&1
         if ((!$?)); then
            grep "^password" /etc/pam.d/common-password | egrep 'sufficient|required' | grep "pam_pwcheck.so" | grep "remember=8" > /dev/null 2>&1
            if ((!$?)); then
               echo "CNL.1.1.4.2 : The password history settings are configured in /etc/pam.d/common-password"
               grep "^password" /etc/pam.d/common-password | egrep 'sufficient|required' | grep "pam_unix2.so" | egrep 'md5|sha512' >> $LOGFILE
            else
               echo "CNL.1.1.4.2 : WARNING - The password history settings are not configured in /etc/pam.d/common-password"
            fi
         else
            echo "CNL.1.1.4.2 : WARNING - The password history settings are not configured in /etc/pam.d/common-password"
         fi
      fi
   else
      echo "CNL.1.1.4.2 : The /etc/pam.d/common-password file does not exist. Checking other control files...."
      if [ -f /etc/pam.d/login ]; then
         grep "^password" /etc/pam.d/login | egrep 'sufficient|required' | grep "pam_unix_passwd.so" | grep "remember=7" | grep "use_authtok" | egrep 'md5|sha512' | grep "shadow" > /dev/null 2>&1
         if (($?)); then
            SUSEOption2=1
         else
            echo "CNL.1.1.4.2 : The password history settings are configured in /etc/pam.d/login"
            grep "^password" /etc/pam.d/login | egrep 'sufficient|required' | grep "pam_unix_passwd.so" | grep "remember=7" | grep "use_authtok" | egrep 'md5|sha512' | grep "shadow" >> $LOGFILE
            SUSEOption2=0
         fi
         if (($SUSEOption2)); then
            grep "^password" /etc/pam.d/login | egrep 'sufficient|required' | grep "pam_unix2.so" | egrep 'md5|sha512' > /dev/null 2>&1
            if ((!$?)); then
               grep "^password" /etc/pam.d/login | egrep 'sufficient|required' | grep "pam_pwcheck.so" | grep "remember=8" > /dev/null 2>&1
               if ((!$?)); then
                  echo "CNL.1.1.4.2 : The password history settings are configured in /etc/pam.d/login"
                  grep "^password" /etc/pam.d/login | egrep 'sufficient|required' | grep "pam_unix2.so" | egrep 'md5|sha512' >> $LOGFILE
               else
                  echo "CNL.1.1.4.2 : WARNING - The password history settings are not configured in /etc/pam.d/login"
               fi
            else
               echo "CNL.1.1.4.2 : WARNING - The password history settings are not configured in /etc/pam.d/login"
            fi
         fi
      else
         echo "CNL.1.1.4.2 : WARNING - The /etc/pam.d/login file does not exist."
      fi
      if [ -f /etc/pam.d/passwd ]; then
         grep "^password" /etc/pam.d/passwd | egrep 'sufficient|required' | grep "pam_unix_passwd.so" | grep "remember=7" | grep "use_authtok" | egrep 'md5|sha512' | grep "shadow" > /dev/null 2>&1
         if (($?)); then
            SUSEOption2=1
         else
            echo "CNL.1.1.4.2 : The password history settings are configured in /etc/pam.d/passwd"
            grep "^password" /etc/pam.d/passwd | egrep 'sufficient|required' | grep "pam_unix_passwd.so" | grep "remember=7" | grep "use_authtok" | egrep 'md5|sha512' | grep "shadow" >> $LOGFILE
            SUSEOption2=0
         fi
         if (($SUSEOption2)); then
            grep "^password" /etc/pam.d/passwd | egrep 'sufficient|required' | grep "pam_unix2.so" | egrep 'md5|sha512' > /dev/null 2>&1
            if ((!$?)); then
               grep "^password" /etc/pam.d/passwd | egrep 'sufficient|required' | grep "pam_pwcheck.so" | grep "remember=8" > /dev/null 2>&1
               if ((!$?)); then
                  echo "CNL.1.1.4.2 : The password history settings are configured in /etc/pam.d/passwd"
                  grep "^password" /etc/pam.d/passwd | egrep 'sufficient|required' | grep "pam_unix2.so" | egrep 'md5|sha512' >> $LOGFILE
               else
                  echo "CNL.1.1.4.2 : WARNING - The password history settings are not configured in /etc/pam.d/passwd"
               fi
            else
               echo "CNL.1.1.4.2 : WARNING - The password history settings are not configured in /etc/pam.d/passwd"
            fi
         fi
      else
         echo "CNL.1.1.4.2 : WARNING - The /etc/pam.d/passwd file does not exist."
      fi
      if [ -f /etc/pam.d/sshd ]; then
         grep "^password" /etc/pam.d/sshd | egrep 'sufficient|required' | grep "pam_unix_passwd.so" | grep "remember=7" | grep "use_authtok" | egrep 'md5|sha512' | grep "shadow" > /dev/null 2>&1
         if (($?)); then
            SUSEOption2=1
         else
            echo "CNL.1.1.4.2 : The password history settings are configured in /etc/pam.d/sshd"
            grep "^password" /etc/pam.d/sshd | egrep 'sufficient|required' | grep "pam_unix_passwd.so" | grep "remember=7" | grep "use_authtok" | egrep 'md5|sha512' | grep "shadow" >> $LOGFILE
            SUSEOption2=0
         fi
         if (($SUSEOption2)); then
            grep "^password" /etc/pam.d/sshd | egrep 'sufficient|required' | grep "pam_unix2.so" | egrep 'md5|sha512' > /dev/null 2>&1
            if ((!$?)); then
               grep "^password" /etc/pam.d/sshd | egrep 'sufficient|required' | grep "pam_pwcheck.so" | grep "remember=8" > /dev/null 2>&1
               if ((!$?)); then
                  echo "CNL.1.1.4.2 : The password history settings are configured in /etc/pam.d/sshd"
                  grep "^password" /etc/pam.d/sshd | egrep 'sufficient|required' | grep "pam_unix2.so" | egrep 'md5|sha512'  >> $LOGFILE
               else
                  echo "CNL.1.1.4.2 : WARNING - The password history settings are not configured in /etc/pam.d/sshd"
               fi
            else
               echo "CNL.1.1.4.2 : WARNING - The password history settings are not configured in /etc/pam.d/sshd"
            fi
         fi
      else
         echo "CNL.1.1.4.2 : WARNING - The /etc/pam.d/sshd file does not exist."
      fi
      if [ -f /etc/pam.d/su ]; then
         grep "^password" /etc/pam.d/su | egrep 'sufficient|required' | grep "pam_unix_passwd.so" | grep "remember=7" | grep "use_authtok" | egrep 'md5|sha512' | grep "shadow" > /dev/null 2>&1
         if (($?)); then
            SUSEOption2=1
         else
            echo "CNL.1.1.4.2 : The password history settings are configured in /etc/pam.d/su"
            grep "^password" /etc/pam.d/su | egrep 'sufficient|required' | grep "pam_unix_passwd.so" | grep "remember=7" | grep "use_authtok" | egrep 'md5|sha512' | grep "shadow" >> $LOGFILE
            SUSEOption2=0
         fi
         if (($SUSEOption2)); then
            grep "^password" /etc/pam.d/su | egrep 'sufficient|required' | grep "pam_unix2.so" | egrep 'md5|sha512' > /dev/null 2>&1
            if ((!$?)); then
               grep "^password" /etc/pam.d/su | egrep 'sufficient|required' | grep "pam_pwcheck.so" | grep "remember=8" > /dev/null 2>&1
               if ((!$?)); then
                  echo "CNL.1.1.4.2 : The password history settings are configured in /etc/pam.d/su"
                  grep "^password" /etc/pam.d/su | egrep 'sufficient|required' | grep "pam_unix2.so" | egrep 'md5|sha512' >> $LOGFILE
               else
                  echo "CNL.1.1.4.2 : WARNING - The password history settings are not configured in /etc/pam.d/su"
               fi
            else
               echo "CNL.1.1.4.2 : WARNING - The password history settings are not configured in /etc/pam.d/su"
            fi
         fi
      else
         echo "CNL.1.1.4.2 : WARNING - The /etc/pam.d/su file does not exist."
      fi
   fi
   if [ -f /etc/security/pam_pwcheck.conf ]; then
      cat /etc/security/pam_pwcheck.conf | grep -v "^#" |grep "remember=8" | egrep 'md5|sha512' > /dev/null 2>&1
      if (($?)); then
         echo "CNL.1.1.4.2 : WARNING - The md5/sha512 and/or remember=8 setting(s) do not exist in /etc/security/pam_pwcheck.conf file!"
      else
         echo "CNL.1.1.4.2 : The md5/sha512 and remember=8 settings appear in /etc/security/pam_pwcheck.conf:"
         cat /etc/security/pam_pwcheck.conf | grep -v "^#" |grep "remember=8" | egrep 'md5|sha512' >> $LOGFILE
      fi
   else
      echo "CNL.1.1.4.2 : WARNING - The /etc/security/pam_pwcheck.conf file does not exist!"
   fi
   if [ -f /etc/security/pam_unix2.conf ]; then
      cat /etc/security/pam_unix2.conf | grep -v "^#" | grep "shadow" | egrep 'md5|sha512' > /dev/null 2>&1
      if (($?)); then
         echo "CNL.1.1.4.2 : WARNING - The md5/sha512 and/or shadow setting(s) do not exist in /etc/security/pam_unix2.conf file!"
      else
         echo "CNL.1.1.4.2 : THe md5/sha512 and shadow settings appear in /etc/security/pam_unix2.conf:"
         cat /etc/security/pam_unix2.conf | grep -v "^#" | grep "shadow" | egrep 'md5|sha512' >> $LOGFILE
      fi
   else
      echo "CNL.1.1.4.2 : WARNING - The /etc/security/pam_unix2.conf files does not exist!"
   fi
else
   echo ""
   echo "CNL.1.1.4.2 : N/A - This is a $OSFlavor server."
fi


echo ""
if [ $OSFlavor = "RedHat" ] || [ $OSFlavor = "SuSE" ]; then
   echo "CNL.1.1.4.3 : N/A - This is a $OSFlavor server."
else
   echo "CNL.1.1.4.3 : WARNING - THIS SCRIPT IS NOT CONFIGURED TO CHECK DEBIAN!"
fi

echo ""
echo "CNL.1.1.5 : This is a process directive and cannot be health checked."

echo ""
if [ $OSFlavor = "RedHat" ] || [ $OSFlavor = "SuSE" ]; then
   if [ $OSFlavor = "RedHat" ] && [ $RHVER -ge 5 ]; then
      if [ -f /etc/pam.d/system-auth ]; then
         cat /etc/pam.d/system-auth | grep -v "pam_deny.so" | grep "^auth " | grep "required" | egrep 'pam_tally.so|pam_tally2.so' | grep "deny=5" > /dev/null 2>&1
         if ((!$?)); then
            FoundLine=`cat /etc/pam.d/system-auth | grep -v "pam_deny.so" | grep -n "^auth " | grep "required" | egrep 'pam_tally.so|pam_tally2.so' | grep "deny=5" | awk -F':' '{print $1}'`
            cat /etc/pam.d/system-auth | grep -v "pam_deny.so" | grep "^auth " | grep "sufficient" > /dev/null 2>&1
            if ((!$?)); then
               FirstSufficientLine=`cat /etc/pam.d/system-auth | grep -v "pam_deny.so" | grep -n "^auth " | grep "sufficient" | head -1 | awk -F':' '{print $1}'`
               if [ $FoundLine -lt $FirstSufficientLine ]; then
                  echo "CNL.1.1.6 : The 'auth required pam_tally.so/pam_tally2.so deny=5' was found in /etc/pam.d/system-auth file and is in the correct position."
                  cat /etc/pam.d/system-auth | grep -v "pam_deny.so" | grep "^auth " | grep "required" | egrep 'pam_tally.so|pam_tally2.so' | grep "deny=5" >> $LOGFILE
                  echo ""
               else
                  echo "CNL.1.1.6 : WARNING - 'auth required pam_tally.so/pam_tally2.so deny=5' was found in /etc/pam.d/system-auth file BUT is in the wrong position within the file and does not precede any lines of the same module type with a control flag of sufficient with the exception of pam_deny.so"
               fi
            else
               echo "CNL.1.1.6 : The 'auth required pam_tally.so/pam_tally2.so deny=5' was found in /etc/pam.d/system-auth file and is in the correct position."
            fi
         else
            echo "CNL.1.1.6 : WARNING - 'auth required pam_tally.so/pam_tally2.so deny=5' was not found in the /etc/pam.d/system-auth file."
         fi
         cat /etc/pam.d/system-auth | grep -v "pam_deny.so" | grep "^account " | grep "required" | egrep 'pam_tally.so|pam_tally2.so' > /dev/null 2>&1
         if ((!$?)); then
            FoundLine=`cat /etc/pam.d/system-auth | grep -v "pam_deny.so" | grep -n "^account " | grep "required" | egrep 'pam_tally.so|pam_tally2.so' | awk -F':' '{print $1}'`
            cat /etc/pam.d/system-auth | grep -v "pam_deny.so" | grep "^account " | grep "sufficient" > /dev/null 2>&1
            if ((!$?)); then
               FirstSufficientLine=`cat /etc/pam.d/system-auth | grep -v "pam_deny.so" | grep -n "^account " | grep "sufficient" | head -1 | awk -F':' '{print $1}'`
               if [ $FoundLine -lt $FirstSufficientLine ]; then
                  echo "CNL.1.1.6 : The 'account required pam_tally.so/pam_tally2.so' was found in /etc/pam.d/system-auth file and is in the correct position."
                  cat /etc/pam.d/system-auth | grep -v "pam_deny.so" | grep "^account " | grep "required" | egrep 'pam_tally.so|pam_tally2.so' >> $LOGFILE
               else
                  echo "CNL.1.1.6 : WARNING - 'account required pam_tally.so/pam_tally2.so' was found in /etc/pam.d/system-auth file BUT is in the wrong position within the file and does not precede any lines of the same module type with a control flag of sufficient with the exception of pam_deny.so"
               fi
            else
               echo "CNL.1.1.6 : The 'account required pam_tally.so/pam_tally2.so' was found in /etc/pam.d/system-auth file and is in the correct position."
            fi
         else
            echo "CNL.1.1.6 : WARNING - 'account required pam_tally.so/pam_tally2.so' was not found in the /etc/pam.d/system-auth file."
         fi
         if [ $OSFlavor = "RedHat" ] && [ $RHVER -ge 6 ]; then
            if [ -f /etc/pam.d/password-auth ]; then
               cat /etc/pam.d/password-auth | grep -v "pam_deny.so" | grep "^auth " | grep "required" | egrep 'pam_tally.so|pam_tally2.so' | grep "deny=5" > /dev/null 2>&1
               if ((!$?)); then
                  FoundLine=`cat /etc/pam.d/password-auth | grep -v "pam_deny.so" | grep -n "^auth " | grep "required" | egrep 'pam_tally.so|pam_tally2.so' | grep "deny=5" | awk -F':' '{print $1}'`
                  cat /etc/pam.d/password-auth | grep -v "pam_deny.so" | grep "^auth " | grep "sufficient" > /dev/null 2>&1
                  if ((!$?)); then
                     FirstSufficientLine=`cat /etc/pam.d/password-auth | grep -v "pam_deny.so" | grep -n "^auth " | grep "sufficient" | head -1 | awk -F':' '{print $1}'`
                     if [ $FoundLine -lt $FirstSufficientLine ]; then
                        echo "CNL.1.1.6 : The 'auth required pam_tally.so/pam_tally2.so deny=5' was found in /etc/pam.d/password-auth file and is in the correct position."
                        cat /etc/pam.d/password-auth | grep -v "pam_deny.so" | grep "^auth " | grep "required" | egrep 'pam_tally.so|pam_tally2.so' | grep "deny=5" >> $LOGFILE
                        echo ""
                     else
                        echo "CNL.1.1.6 : WARNING - 'auth required pam_tally.so/pam_tally2.so deny=5' was found in /etc/pam.d/password-auth file BUT is in the wrong position within the file and does not precede any lines of the same module type with a control flag of sufficient with the exception of pam_deny.so"
                     fi
                  else
                     echo "CNL.1.1.6 : The 'auth required pam_tally.so/pam_tally2.so deny=5' was found in /etc/pam.d/password-auth file and is in the correct position."
                  fi
               else
                  echo "CNL.1.1.6 : WARNING - 'auth required pam_tally.so/pam_tally2.so deny=5' was not found in the /etc/pam.d/password-auth file."
               fi
               cat /etc/pam.d/password-auth | grep -v "pam_deny.so" | grep "^account " | grep "required" | egrep 'pam_tally.so|pam_tally2.so' > /dev/null 2>&1
               if ((!$?)); then
                  FoundLine=`cat /etc/pam.d/password-auth | grep -v "pam_deny.so" | grep -n "^account " | grep "required" | egrep 'pam_tally.so|pam_tally2.so' | awk -F':' '{print $1}'`
                  cat /etc/pam.d/password-auth | grep -v "pam_deny.so" | grep "^account " | grep "sufficient" > /dev/null 2>&1
                  if ((!$?)); then
                     FirstSufficientLine=`cat /etc/pam.d/password-auth | grep -v "pam_deny.so" | grep -n "^account " | grep "sufficient" | head -1 | awk -F':' '{print $1}'`
                     if [ $FoundLine -lt $FirstSufficientLine ]; then
                        echo "CNL.1.1.6 : The 'account required pam_tally.so/pam_tally2.so' was found in /etc/pam.d/password-auth file and is in the correct position."
                        cat /etc/pam.d/password-auth | grep -v "pam_deny.so" | grep "^account " | grep "required" | egrep 'pam_tally.so|pam_tally2.so' >> $LOGFILE
                     else
                        echo "CNL.1.1.6 : WARNING - 'account required pam_tally.so/pam_tally2.so' was found in /etc/pam.d/password-auth file BUT is in the wrong position within the file and does not precede any lines of the same module type with a control flag of sufficient with the exception of pam_deny.so"
                     fi
                  else
                     echo "CNL.1.1.6 : The 'account required pam_tally.so/pam_tally2.so' was found in /etc/pam.d/password-auth file and is in the correct position."
                  fi
               else
                  echo "CNL.1.1.6 : WARNING - 'account required pam_tally.so/pam_tally2.so' was not found in the /etc/pam.d/password-auth file."
               fi
            else
               echo "CNL.1.1.6 : WARNING - The /etc/pam.d/password-auth file does NOT exist!"
            fi
         else
            echo "CNL.1.1.6 : Note that this is not a RHEL V6 or later OS."
         fi
      else
         echo "CNL.1.1.6 : The /etc/pam.d/system-auth file does not exist. Checking other control files...."
         if [ -f /etc/pam.d/login ]; then
            cat /etc/pam.d/login | grep -v "pam_deny.so" | grep "^auth " | grep "required" | egrep 'pam_tally.so|pam_tally2.so' | grep "deny=5" > /dev/null 2>&1
            if ((!$?)); then
               FoundLine=`cat /etc/pam.d/login | grep -v "pam_deny.so" | grep -n "^auth " | grep "required" | egrep 'pam_tally.so|pam_tally2.so' | grep "deny=5" | awk -F':' '{print $1}'`
               cat /etc/pam.d/login | grep -v "pam_deny.so" | grep "^auth " | grep "sufficient" > /dev/null 2>&1
               if ((!$?)); then
                  FirstSufficientLine=`cat /etc/pam.d/login | grep -v "pam_deny.so" | grep -n "^auth " | grep "sufficient" | head -1 | awk -F':' '{print $1}'`
                  if [ $FoundLine -lt $FirstSufficientLine ]; then
                     echo "CNL.1.1.6 : The 'auth required pam_tally.so deny=5' was found in /etc/pam.d/login file and is in the correct position."
                  else
                     echo "CNL.1.1.6 : WARNING - 'auth required pam_tally.so deny=5' was found in /etc/pam.d/login file BUT is in the wrong position within the file and does not precede any lines of the same module type with a control flag of sufficient with the exception of pam_deny.so"
                  fi
               else
                  echo "CNL.1.1.6 : The 'auth required pam_tally.so deny=5' was found in /etc/pam.d/login file and is in the correct position."
               fi
            else
               echo "CNL.1.1.6 : WARNING - 'auth required pam_tally.so deny=5' was not found in the /etc/pam.d/login file."
            fi
            cat /etc/pam.d/login | grep -v "pam_deny.so" | grep "^account " | grep "required" | egrep 'pam_tally.so|pam_tally2.so' > /dev/null 2>&1
            if ((!$?)); then
               FoundLine=`cat /etc/pam.d/login | grep -v "pam_deny.so" | grep -n "^account " | grep "required" | egrep 'pam_tally.so|pam_tally2.so' | awk -F':' '{print $1}'`
               cat /etc/pam.d/login | grep -v "pam_deny.so" | grep "^account " | grep "sufficient" > /dev/null 2>&1
               if ((!$?)); then
                  FirstSufficientLine=`cat /etc/pam.d/login | grep -v "pam_deny.so" | grep -n "^account " | grep "sufficient" | head -1 | awk -F':' '{print $1}'`
                  if [ $FoundLine -lt $FirstSufficientLine ]; then
                     echo "CNL.1.1.6 : The 'account required pam_tally.so' was found in /etc/pam.d/login file and is in the correct position."
                  else
                     echo "CNL.1.1.6 : WARNING - 'account required pam_tally.so' was found in /etc/pam.d/login file BUT is in the wrong position within the file and does not precede any lines of the same module type with a control flag of sufficient with the exception of pam_deny.so"
                  fi
               else
                  echo "CNL.1.1.6 : The 'account required pam_tally.so' was found in /etc/pam.d/login file and is in the correct position."
               fi
            else
               echo "CNL.1.1.6 : WARNING - 'account required pam_tally.so' was not found in the /etc/pam.d/login file."
            fi
         else
            echo "CNL.1.1.6 : WARNING - The /etc/pam.d/login file does not exist."
         fi
         if [ -f /etc/pam.d/passwd ]; then
            cat /etc/pam.d/passwd | grep -v "pam_deny.so" | grep "^auth " | grep "required" | egrep 'pam_tally.so|pam_tally2.so' | grep "deny=5" > /dev/null 2>&1
            if ((!$?)); then
               FoundLine=`cat /etc/pam.d/passwd | grep -v "pam_deny.so" | grep -n "^auth " | grep "required" | egrep 'pam_tally.so|pam_tally2.so' | grep "deny=5" | awk -F':' '{print $1}'`
               cat /etc/pam.d/passwd | grep -v "pam_deny.so" | grep "^auth " | grep "sufficient" > /dev/null 2>&1
               if ((!$?)); then
                  FirstSufficientLine=`cat /etc/pam.d/passwd | grep -v "pam_deny.so" | grep -n "^auth " | grep "sufficient" | head -1 | awk -F':' '{print $1}'`
                  if [ $FoundLine -lt $FirstSufficientLine ]; then
                     echo "CNL.1.1.6 : The 'auth required pam_tally.so deny=5' was found in /etc/pam.d/passwd file and is in the correct position."
                  else
                     echo "CNL.1.1.6 : WARNING - 'auth required pam_tally.so deny=5' was found in /etc/pam.d/passwd file BUT is in the wrong position within the file and does not precede any lines of the same module type with a control flag of sufficient with the exception of pam_deny.so"
                  fi
               else
                  echo "CNL.1.1.6 : The 'auth required pam_tally.so deny=5' was found in /etc/pam.d/passwd file and is in the correct position."
               fi
            else
               echo "CNL.1.1.6 : WARNING - 'auth required pam_tally.so deny=5' was not found in the /etc/pam.d/passwd file."
            fi
            cat /etc/pam.d/passwd | grep -v "pam_deny.so" | grep "^account " | grep "required" | egrep 'pam_tally.so|pam_tally2.so' > /dev/null 2>&1
            if ((!$?)); then
               FoundLine=`cat /etc/pam.d/passwd | grep -v "pam_deny.so" | grep -n "^account " | grep "required" | egrep 'pam_tally.so|pam_tally2.so' | awk -F':' '{print $1}'`
               cat /etc/pam.d/passwd | grep -v "pam_deny.so" | grep "^account " | grep "sufficient" > /dev/null 2>&1
               if ((!$?)); then
                  FirstSufficientLine=`cat /etc/pam.d/passwd | grep -v "pam_deny.so" | grep -n "^account " | grep "sufficient" | head -1 | awk -F':' '{print $1}'`
                  if [ $FoundLine -lt $FirstSufficientLine ]; then
                     echo "CNL.1.1.6 : The 'account required pam_tally.so' was found in /etc/pam.d/passwd file and is in the correct position."
                  else
                     echo "CNL.1.1.6 : WARNING - 'account required pam_tally.so' was found in /etc/pam.d/passwd file BUT is in the wrong position within the file and does not precede any lines of the same module type with a control flag of sufficient with the exception of pam_deny.so"
                  fi
               else
                  echo "CNL.1.1.6 : The 'account required pam_tally.so' was found in /etc/pam.d/passwd file and is in the correct position."
               fi
            else
               echo "CNL.1.1.6 : WARNING - 'account required pam_tally.so' was not found in the /etc/pam.d/passwd file."
            fi
         else
            echo "CNL.1.1.6 : WARNING - The /etc/pam.d/passwd file does not exist."
         fi
         if [ -f /etc/pam.d/sshd ]; then
            cat /etc/pam.d/sshd | grep -v "pam_deny.so" | grep "^auth " | grep "required" | egrep 'pam_tally.so|pam_tally2.so' | grep "deny=5" > /dev/null 2>&1
            if ((!$?)); then
               FoundLine=`cat /etc/pam.d/sshd | grep -v "pam_deny.so" | grep -n "^auth " | grep "required" | egrep 'pam_tally.so|pam_tally2.so' | grep "deny=5" | awk -F':' '{print $1}'`
               cat /etc/pam.d/sshd | grep -v "pam_deny.so" | grep "^auth " | grep "sufficient" > /dev/null 2>&1
               if ((!$?)); then
                  FirstSufficientLine=`cat /etc/pam.d/sshd | grep -v "pam_deny.so" | grep -n "^auth " | grep "sufficient" | head -1 | awk -F':' '{print $1}'`
                  if [ $FoundLine -lt $FirstSufficientLine ]; then
                     echo "CNL.1.1.6 : The 'auth required pam_tally.so deny=5' was found in /etc/pam.d/sshd file and is in the correct position."
                  else
                     echo "CNL.1.1.6 : WARNING - 'auth required pam_tally.so deny=5' was found in /etc/pam.d/sshd file BUT is in the wrong position within the file and does not precede any lines of the same module type with a control flag of sufficient with the exception of pam_deny.so"
                  fi
               else
                  echo "CNL.1.1.6 : The 'auth required pam_tally.so deny=5' was found in /etc/pam.d/sshd file and is in the correct position."
               fi
            else
               echo "CNL.1.1.6 : WARNING - 'auth required pam_tally.so deny=5' was not found in the /etc/pam.d/sshd file."
            fi
            cat /etc/pam.d/sshd | grep -v "pam_deny.so" | grep "^account " | grep "required" | egrep 'pam_tally.so|pam_tally2.so' > /dev/null 2>&1
            if ((!$?)); then
               FoundLine=`cat /etc/pam.d/sshd | grep -v "pam_deny.so" | grep -n "^account " | grep "required" | egrep 'pam_tally.so|pam_tally2.so' | awk -F':' '{print $1}'`
               cat /etc/pam.d/sshd | grep -v "pam_deny.so" | grep "^account " | grep "sufficient" > /dev/null 2>&1
               if ((!$?)); then
                  FirstSufficientLine=`cat /etc/pam.d/sshd | grep -v "pam_deny.so" | grep -n "^account " | grep "sufficient" | head -1 | awk -F':' '{print $1}'`
                  if [ $FoundLine -lt $FirstSufficientLine ]; then
                     echo "CNL.1.1.6 : The 'account required pam_tally.so' was found in /etc/pam.d/sshd file and is in the correct position."
                  else
                     echo "CNL.1.1.6 : WARNING - 'account required pam_tally.so' was found in /etc/pam.d/sshd file BUT is in the wrong position within the file and does not precede any lines of the same module type with a control flag of sufficient with the exception of pam_deny.so"
                  fi
               else
                  echo "CNL.1.1.6 : The 'account required pam_tally.so' was found in /etc/pam.d/sshd file and is in the correct position."
               fi
            else
               echo "CNL.1.1.6 : WARNING - 'account required pam_tally.so' was not found in the /etc/pam.d/sshd file."
            fi
         else
            echo "CNL.1.1.6 : WARNING - The /etc/pam.d/sshd file does not exist."
         fi
         if [ -f /etc/pam.d/su ]; then
            cat /etc/pam.d/su | grep -v "pam_deny.so" | grep "^auth " | grep "required" | egrep 'pam_tally.so|pam_tally2.so' | grep "deny=5" > /dev/null 2>&1
            if ((!$?)); then
               FoundLine=`cat /etc/pam.d/su | grep -v "pam_deny.so" | grep -n "^auth " | grep "required" | egrep 'pam_tally.so|pam_tally2.so' | grep "deny=5" | awk -F':' '{print $1}'`
               cat /etc/pam.d/su | grep -v "pam_deny.so" | grep "^auth " | grep "sufficient" > /dev/null 2>&1
               if ((!$?)); then
                  FirstSufficientLine=`cat /etc/pam.d/su | grep -v "pam_deny.so" | grep -n "^auth " | grep "sufficient" | head -1 | awk -F':' '{print $1}'`
                  if [ $FoundLine -lt $FirstSufficientLine ]; then
                     echo "CNL.1.1.6 : The 'auth required pam_tally.so deny=5' was found in /etc/pam.d/su file and is in the correct position."
                  else
                     echo "CNL.1.1.6 : WARNING - 'auth required pam_tally.so deny=5' was found in /etc/pam.d/su file BUT is in the wrong position within the file and does not precede any lines of the same module type with a control flag of sufficient with the exception of pam_deny.so"
                  fi
               else
                  echo "CNL.1.1.6 : The 'auth required pam_tally.so deny=5' was found in /etc/pam.d/su file and is in the correct position."
               fi
            else
               echo "CNL.1.1.6 : WARNING - 'auth required pam_tally.so deny=5' was not found in the /etc/pam.d/su file."
            fi
            cat /etc/pam.d/su | grep -v "pam_deny.so" | grep "^account " | grep "required" | egrep 'pam_tally.so|pam_tally2.so' > /dev/null 2>&1
            if ((!$?)); then
               FoundLine=`cat /etc/pam.d/su | grep -v "pam_deny.so" | grep -n "^account " | grep "required" | egrep 'pam_tally.so|pam_tally2.so' | awk -F':' '{print $1}'`
               cat /etc/pam.d/su | grep -v "pam_deny.so" | grep "^account " | grep "sufficient" > /dev/null 2>&1
               if ((!$?)); then
                  FirstSufficientLine=`cat /etc/pam.d/su | grep -v "pam_deny.so" | grep -n "^account " | grep "sufficient" | head -1 | awk -F':' '{print $1}'`
                  if [ $FoundLine -lt $FirstSufficientLine ]; then
                     echo "CNL.1.1.6 : The 'account required pam_tally.so' was found in /etc/pam.d/su file and is in the correct position."
                  else
                     echo "CNL.1.1.6 : WARNING - 'account required pam_tally.so' was found in /etc/pam.d/su file BUT is in the wrong position within the file and does not precede any lines of the same module type with a control flag of sufficient with the exception of pam_deny.so"
                  fi
               else
                  echo "CNL.1.1.6 : The 'account required pam_tally.so' was found in /etc/pam.d/su file and is in the correct position."
               fi
            else
               echo "CNL.1.1.6 : WARNING - 'account required pam_tally.so' was not found in the /etc/pam.d/su file."
            fi
         else
            echo "CNL.1.1.6 : WARNING - The /etc/pam.d/su file does not exist."
         fi
      fi
   #
   ##Do different checks for RH 4 and lower and SLE9:
   elif [[ $OSFlavor = "RedHat" && $RHVER -le 4 ]] || [[ $OSFlavor = "SuSE" && $SVER = "9" ]]; then
      if [ -f /etc/pam.d/system-auth ]; then
         cat /etc/pam.d/system-auth | grep -v "pam_deny.so" | grep "^auth " | grep "required" | egrep 'pam_tally.so|pam_tally2.so' | grep "no_magic_root" > /dev/null 2>&1
         if ((!$?)); then
            FoundLine=`cat /etc/pam.d/system-auth | grep -v "pam_deny.so" | grep -n "^auth " | grep "required" | egrep 'pam_tally.so|pam_tally2.so' | grep "no_magic_root" | awk -F':' '{print $1}'`
            cat /etc/pam.d/system-auth | grep -v "pam_deny.so" | grep "^auth " | grep "sufficient" > /dev/null 2>&1
            if ((!$?)); then
               FirstSufficientLine=`cat /etc/pam.d/system-auth | grep -v "pam_deny.so" | grep -n "^auth " | grep "sufficient" | head -1 | awk -F':' '{print $1}'`
               if [ $FoundLine -lt $FirstSufficientLine ]; then
                  echo "CNL.1.1.6 : The 'auth required pam_tally.so no_magic_root' was found in /etc/pam.d/system-auth file and is in the correct position."
               else
                  echo "CNL.1.1.6 : WARNING - 'auth required pam_tally.so no_magic_root' was found in /etc/pam.d/system-auth file BUT is in the wrong position within the file and does not precede any lines of the same module type with a control flag of sufficient with the exception of pam_deny.so"
               fi
            else
               echo "CNL.1.1.6 : The 'auth required pam_tally.so no_magic_root' was found in /etc/pam.d/system-auth file and is in the correct position."
            fi
         else
            echo "CNL.1.1.6 : WARNING - 'auth required pam_tally.so no_magic_root' was not found in the /etc/pam.d/system-auth file."
         fi
         cat /etc/pam.d/system-auth | grep -v "pam_deny.so" | grep "^account " | grep "required" | egrep 'pam_tally.so|pam_tally2.so' | grep "deny=5" | grep "reset" | grep "no_magic_root" > /dev/null 2>&1
         if ((!$?)); then
            FoundLine=`cat /etc/pam.d/system-auth | grep -v "pam_deny.so" | grep -n "^account " | grep "required" | egrep 'pam_tally.so|pam_tally2.so' | grep "deny=5" | grep "reset" | grep "no_magic_root" | awk -F':' '{print $1}'`
            cat /etc/pam.d/system-auth | grep -v "pam_deny.so" | grep "^account " | grep "sufficient" > /dev/null 2>&1
            if ((!$?)); then
               FirstSufficientLine=`cat /etc/pam.d/system-auth | grep -v "pam_deny.so" | grep -n "^account " | grep "sufficient" | head -1 | awk -F':' '{print $1}'`
               if [ $FoundLine -lt $FirstSufficientLine ]; then
                  echo "CNL.1.1.6 : The 'account required pam_tally.so deny=5 reset no_magic_root' was found in /etc/pam.d/system-auth file and is in the correct position."
               else
                  echo "CNL.1.1.6 : WARNING - 'account required pam_tally.so deny=5 reset no_magic_root' was found in /etc/pam.d/system-auth file BUT is in the wrong position within the file and does not precede any lines of the same module type with a control flag of sufficient with the exception of pam_deny.so"
               fi
            else
               echo "CNL.1.1.6 : The 'account required pam_tally.so deny=5 reset no_magic_root' was found in /etc/pam.d/system-auth file and is in the correct position."
            fi
         else
            echo "CNL.1.1.6 : WARNING - 'account required pam_tally.so deny=5 reset no_magic_root' was not found in the /etc/pam.d/system-auth file."
         fi
      else
         echo "CNL.1.1.6 : The /etc/pam.d/system-auth file does not exist. Checking other control files...."
         if [ -f /etc/pam.d/login ]; then
            cat /etc/pam.d/login | grep -v "pam_deny.so" | grep "^auth " | grep "required" | egrep 'pam_tally.so|pam_tally2.so' | grep "no_magic_root" > /dev/null 2>&1
            if ((!$?)); then
               FoundLine=`cat /etc/pam.d/login | grep -v "pam_deny.so" | grep -n "^auth " | grep "required" | egrep 'pam_tally.so|pam_tally2.so' | grep "no_magic_root" | awk -F':' '{print $1}'`
               cat /etc/pam.d/login | grep -v "pam_deny.so" | grep "^auth " | grep "sufficient" > /dev/null 2>&1
               if ((!$?)); then
                  FirstSufficientLine=`cat /etc/pam.d/login | grep -v "pam_deny.so" | grep -n "^auth " | grep "sufficient" | head -1 | awk -F':' '{print $1}'`
                  if [ $FoundLine -lt $FirstSufficientLine ]; then
                     echo "CNL.1.1.6 : The 'auth required pam_tally.so no_magic_root' was found in /etc/pam.d/login file and is in the correct position."
                  else
                     echo "CNL.1.1.6 : WARNING - 'auth required pam_tally.so no_magic_root' was found in /etc/pam.d/login file BUT is in the wrong position within the file and does not precede any lines of the same module type with a control flag of sufficient with the exception of pam_deny.so"
                  fi
               else
                  echo "CNL.1.1.6 : The 'auth required pam_tally.so no_magic_root' was found in /etc/pam.d/login file and is in the correct position."
               fi
            else
               echo "CNL.1.1.6 : WARNING - 'auth required pam_tally.so no_magic_root' was not found in the /etc/pam.d/login file."
            fi
            cat /etc/pam.d/login | grep -v "pam_deny.so" | grep "^account " | grep "required" | egrep 'pam_tally.so|pam_tally2.so' | grep "deny=5" | grep "reset" | grep "no_magic_root" > /dev/null 2>&1
            if ((!$?)); then
               FoundLine=`cat /etc/pam.d/login | grep -v "pam_deny.so" | grep -n "^account " | grep "required" | egrep 'pam_tally.so|pam_tally2.so' | grep "deny=5" | grep "reset" | grep "no_magic_root" | awk -F':' '{print $1}'`
               cat /etc/pam.d/login | grep -v "pam_deny.so" | grep "^account " | grep "sufficient" > /dev/null 2>&1
               if ((!$?)); then
                  FirstSufficientLine=`cat /etc/pam.d/login | grep -v "pam_deny.so" | grep -n "^account " | grep "sufficient" | head -1 | awk -F':' '{print $1}'`
                  if [ $FoundLine -lt $FirstSufficientLine ]; then
                     echo "CNL.1.1.6 : The 'account required pam_tally.so deny=5 reset no_magic_root' was found in /etc/pam.d/login file and is in the correct position."
                  else
                     echo "CNL.1.1.6 : WARNING - 'account required pam_tally.so deny=5 reset no_magic_root' was found in /etc/pam.d/login file BUT is in the wrong position within the file and does not precede any lines of the same module type with a control flag of sufficient with the exception of pam_deny.so"
                  fi
               else
                  echo "CNL.1.1.6 : The 'account required pam_tally.so deny=5 reset no_magic_root' was found in /etc/pam.d/login file and is in the correct position."
               fi
            else
               echo "CNL.1.1.6 : WARNING - 'account required pam_tally.so deny=5 reset no_magic_root' was not found in the /etc/pam.d/login file."
            fi
         else
            echo "CNL.1.1.6 : WARNING - The /etc/pam.d/login file does not exist."
         fi
         if [ -f /etc/pam.d/passwd ]; then
            cat /etc/pam.d/passwd | grep -v "pam_deny.so" | grep "^auth " | grep "required" | egrep 'pam_tally.so|pam_tally2.so' | grep "no_magic_root" > /dev/null 2>&1
            if ((!$?)); then
               FoundLine=`cat /etc/pam.d/passwd | grep -v "pam_deny.so" | grep -n "^auth " | grep "required" | egrep 'pam_tally.so|pam_tally2.so' | grep "no_magic_root" | awk -F':' '{print $1}'`
               cat /etc/pam.d/passwd | grep -v "pam_deny.so" | grep "^auth " | grep "sufficient" > /dev/null 2>&1
               if ((!$?)); then
                  FirstSufficientLine=`cat /etc/pam.d/passwd | grep -v "pam_deny.so" | grep -n "^auth " | grep "sufficient" | head -1 | awk -F':' '{print $1}'`
                  if [ $FoundLine -lt $FirstSufficientLine ]; then
                     echo "CNL.1.1.6 : The 'auth required pam_tally.so no_magic_root' was found in /etc/pam.d/passwd file and is in the correct position."
                  else
                     echo "CNL.1.1.6 : WARNING - 'auth required pam_tally.so no_magic_root' was found in /etc/pam.d/passwd file BUT is in the wrong position within the file and does not precede any lines of the same module type with a control flag of sufficient with the exception of pam_deny.so"
                  fi
               else
                  echo "CNL.1.1.6 : The 'auth required pam_tally.so no_magic_root' was found in /etc/pam.d/passwd file and is in the correct position."
               fi
            else
               echo "CNL.1.1.6 : WARNING - 'auth required pam_tally.so no_magic_root' was not found in the /etc/pam.d/passwd file."
            fi
            cat /etc/pam.d/passwd | grep -v "pam_deny.so" | grep "^account " | grep "required" | egrep 'pam_tally.so|pam_tally2.so' | grep "deny=5" | grep "reset" | grep "no_magic_root" > /dev/null 2>&1
            if ((!$?)); then
               FoundLine=`cat /etc/pam.d/passwd | grep -v "pam_deny.so" | grep -n "^account " | grep "required" | egrep 'pam_tally.so|pam_tally2.so' | grep "deny=5" | grep "reset" | grep "no_magic_root" | awk -F':' '{print $1}'`
               cat /etc/pam.d/passwd | grep -v "pam_deny.so" | grep "^account " | grep "sufficient" > /dev/null 2>&1
               if ((!$?)); then
                  FirstSufficientLine=`cat /etc/pam.d/passwd | grep -v "pam_deny.so" | grep -n "^account " | grep "sufficient" | head -1 | awk -F':' '{print $1}'`
                  if [ $FoundLine -lt $FirstSufficientLine ]; then
                     echo "CNL.1.1.6 : The 'account required pam_tally.so deny=5 reset no_magic_root' was found in /etc/pam.d/passwd file and is in the correct position."
                  else
                     echo "CNL.1.1.6 : WARNING - 'account required pam_tally.so deny=5 reset no_magic_root' was found in /etc/pam.d/passwd file BUT is in the wrong position within the file and does not precede any lines of the same module type with a control flag of sufficient with the exception of pam_deny.so"
                  fi
               else
                  echo "CNL.1.1.6 : The 'account required pam_tally.so deny=5 reset no_magic_root' was found in /etc/pam.d/passwd file and is in the correct position."
               fi
            else
               echo "CNL.1.1.6 : WARNING - 'account required pam_tally.so deny=5 reset no_magic_root' was not found in the /etc/pam.d/passwd file."
            fi
         else
            echo "CNL.1.1.6 : WARNING - The /etc/pam.d/passwd file does not exist."
         fi
         if [ -f /etc/pam.d/sshd ]; then
            cat /etc/pam.d/sshd | grep -v "pam_deny.so" | grep "^auth " | grep "required" | egrep 'pam_tally.so|pam_tally2.so' | grep "no_magic_root" > /dev/null 2>&1
            if ((!$?)); then
               FoundLine=`cat /etc/pam.d/sshd | grep -v "pam_deny.so" | grep -n "^auth " | grep "required" | egrep 'pam_tally.so|pam_tally2.so' | grep "no_magic_root" | awk -F':' '{print $1}'`
               cat /etc/pam.d/sshd | grep -v "pam_deny.so" | grep "^auth " | grep "sufficient" > /dev/null 2>&1
               if ((!$?)); then
                  FirstSufficientLine=`cat /etc/pam.d/sshd | grep -v "pam_deny.so" | grep -n "^auth " | grep "sufficient" | head -1 | awk -F':' '{print $1}'`
                  if [ $FoundLine -lt $FirstSufficientLine ]; then
                     echo "CNL.1.1.6 : The 'auth required pam_tally.so no_magic_root' was found in /etc/pam.d/sshd file and is in the correct position."
                  else
                     echo "CNL.1.1.6 : WARNING - 'auth required pam_tally.so no_magic_root' was found in /etc/pam.d/sshd file BUT is in the wrong position within the file and does not precede any lines of the same module type with a control flag of sufficient with the exception of pam_deny.so"
                  fi
               else
                  echo "CNL.1.1.6 : The 'auth required pam_tally.so no_magic_root' was found in /etc/pam.d/sshd file and is in the correct position."
               fi
            else
               echo "CNL.1.1.6 : WARNING - 'auth required pam_tally.so no_magic_root' was not found in the /etc/pam.d/sshd file."
            fi
            cat /etc/pam.d/sshd | grep -v "pam_deny.so" | grep "^account " | grep "required" | egrep 'pam_tally.so|pam_tally2.so' | grep "deny=5" | grep "reset" | grep "no_magic_root" > /dev/null 2>&1
            if ((!$?)); then
               FoundLine=`cat /etc/pam.d/sshd | grep -v "pam_deny.so" | grep -n "^account " | grep "required" | egrep 'pam_tally.so|pam_tally2.so' | grep "deny=5" | grep "reset" | grep "no_magic_root" | awk -F':' '{print $1}'`
               cat /etc/pam.d/sshd | grep -v "pam_deny.so" | grep "^account " | grep "sufficient" > /dev/null 2>&1
               if ((!$?)); then
                  FirstSufficientLine=`cat /etc/pam.d/sshd | grep -v "pam_deny.so" | grep -n "^account " | grep "sufficient" | head -1 | awk -F':' '{print $1}'`
                  if [ $FoundLine -lt $FirstSufficientLine ]; then
                     echo "CNL.1.1.6 : The 'account required pam_tally.so deny=5 reset no_magic_root' was found in /etc/pam.d/sshd file and is in the correct position."
                  else
                     echo "CNL.1.1.6 : WARNING - 'account required pam_tally.so deny=5 reset no_magic_root' was found in /etc/pam.d/sshd file BUT is in the wrong position within the file and does not precede any lines of the same module type with a control flag of sufficient with the exception of pam_deny.so"
                  fi
               else
                  echo "CNL.1.1.6 : The 'account required pam_tally.so deny=5 reset no_magic_root' was found in /etc/pam.d/sshd file and is in the correct position."
               fi
            else
               echo "CNL.1.1.6 : WARNING - 'account required pam_tally.so deny=5 reset no_magic_root' was not found in the /etc/pam.d/sshd file."
            fi
         else
            echo "CNL.1.1.6 : WARNING - The /etc/pam.d/sshd file does not exist."
         fi
         if [ -f /etc/pam.d/su ]; then
            cat /etc/pam.d/su | grep -v "pam_deny.so" | grep "^auth " | grep "required" | egrep 'pam_tally.so|pam_tally2.so' | grep "no_magic_root" > /dev/null 2>&1
            if ((!$?)); then
               FoundLine=`cat /etc/pam.d/su | grep -v "pam_deny.so" | grep -n "^auth " | grep "required" | egrep 'pam_tally.so|pam_tally2.so' | grep "no_magic_root" | awk -F':' '{print $1}'`
               cat /etc/pam.d/su | grep -v "pam_deny.so" | grep "^auth " | grep "sufficient" > /dev/null 2>&1
               if ((!$?)); then
                  FirstSufficientLine=`cat /etc/pam.d/su | grep -v "pam_deny.so" | grep -n "^auth " | grep "sufficient" | head -1 | awk -F':' '{print $1}'`
                  if [ $FoundLine -lt $FirstSufficientLine ]; then
                     echo "CNL.1.1.6 : The 'auth required pam_tally.so no_magic_root' was found in /etc/pam.d/su file and is in the correct position."
                  else
                     echo "CNL.1.1.6 : WARNING - 'auth required pam_tally.so no_magic_root' was found in /etc/pam.d/su file BUT is in the wrong position within the file and does not precede any lines of the same module type with a control flag of sufficient with the exception of pam_deny.so"
                  fi
               else
                  echo "CNL.1.1.6 : The 'auth required pam_tally.so no_magic_root' was found in /etc/pam.d/su file and is in the correct position."
               fi
            else
               echo "CNL.1.1.6 : WARNING - 'auth required pam_tally.so no_magic_root' was not found in the /etc/pam.d/su file."
            fi
            cat /etc/pam.d/su | grep -v "pam_deny.so" | grep "^account " | grep "required" | egrep 'pam_tally.so|pam_tally2.so' | grep "deny=5" | grep "reset" | grep "no_magic_root" > /dev/null 2>&1
            if ((!$?)); then
               FoundLine=`cat /etc/pam.d/su | grep -v "pam_deny.so" | grep -n "^account " | grep "required" | egrep 'pam_tally.so|pam_tally2.so' | grep "deny=5" | grep "reset" | grep "no_magic_root" | awk -F':' '{print $1}'`
               cat /etc/pam.d/su | grep -v "pam_deny.so" | grep "^account " | grep "sufficient" > /dev/null 2>&1
               if ((!$?)); then
                  FirstSufficientLine=`cat /etc/pam.d/su | grep -v "pam_deny.so" | grep -n "^account " | grep "sufficient" | head -1 | awk -F':' '{print $1}'`
                  if [ $FoundLine -lt $FirstSufficientLine ]; then
                     echo "CNL.1.1.6 : The 'account required pam_tally.so deny=5 reset no_magic_root' was found in /etc/pam.d/su file and is in the correct position."
                  else
                     echo "CNL.1.1.6 : WARNING - 'account required pam_tally.so deny=5 reset no_magic_root' was found in /etc/pam.d/su file BUT is in the wrong position within the file and does not precede any lines of the same module type with a control flag of sufficient with the exception of pam_deny.so"
                  fi
               else
                  echo "CNL.1.1.6 : The 'account required pam_tally.so deny=5 reset no_magic_root' was found in /etc/pam.d/su file and is in the correct position."
               fi
            else
               echo "CNL.1.1.6 : WARNING - 'account required pam_tally.so deny=5 reset no_magic_root' was not found in the /etc/pam.d/su file."
            fi
         else
            echo "CNL.1.1.6 : WARNING - The /etc/pam.d/su file does not exist."
         fi
      fi
   
   
   
   
   
   #
   ##Do different checks for SLE10:
   elif [[ $OSFlavor = "SuSE" && $SVER = "10" ]]; then
      if [ -f /etc/pam.d/system-auth ]; then
         cat /etc/pam.d/system-auth | grep -v "pam_deny.so" | grep "^auth " | grep "required" | egrep 'pam_tally.so|pam_tally2.so' | grep "deny=5" | grep "onerr=fail" | grep "per_user" | grep "no_lock_time" > /dev/null 2>&1
         if ((!$?)); then
            FoundLine=`cat /etc/pam.d/system-auth | grep -v "pam_deny.so" | grep -n "^auth " | grep "required" | egrep 'pam_tally.so|pam_tally2.so' | grep "deny=5" | grep "onerr=fail" | grep "per_user" | grep "no_lock_time" | awk -F':' '{print $1}'`
            cat /etc/pam.d/system-auth | grep -v "pam_deny.so" | grep "^auth " | grep "sufficient" > /dev/null 2>&1
            if ((!$?)); then
               FirstSufficientLine=`cat /etc/pam.d/system-auth | grep -v "pam_deny.so" | grep -n "^auth " | grep "sufficient" | head -1 | awk -F':' '{print $1}'`
               if [ $FoundLine -lt $FirstSufficientLine ]; then
                  echo "CNL.1.1.6 : The 'auth required pam_tally.so deny=5 onerr=fail per_user no_lock_time' was found in /etc/pam.d/system-auth file and is in the correct position."
               else
                  echo "CNL.1.1.6 : WARNING - 'auth required pam_tally.so deny=5 onerr=fail per_user no_lock_time' was found in /etc/pam.d/system-auth file BUT is in the wrong position within the file and does not precede any lines of the same module type with a control flag of sufficient with the exception of pam_deny.so"
               fi
            else
               echo "CNL.1.1.6 : The 'auth required pam_tally.so deny=5 onerr=fail per_user no_lock_time' was found in /etc/pam.d/system-auth file and is in the correct position."
            fi
         else
            echo "CNL.1.1.6 : WARNING - 'auth required pam_tally.so deny=5 onerr=fail per_user no_lock_time' was not found in the /etc/pam.d/system-auth file."
         fi
         cat /etc/pam.d/system-auth | grep -v "pam_deny.so" | grep "^account " | grep "required" | egrep 'pam_tally.so|pam_tally2.so' > /dev/null 2>&1
         if ((!$?)); then
            FoundLine=`cat /etc/pam.d/system-auth | grep -v "pam_deny.so" | grep -n "^account " | grep "required" | egrep 'pam_tally.so|pam_tally2.so' | awk -F':' '{print $1}'`
            cat /etc/pam.d/system-auth | grep -v "pam_deny.so" | grep "^account " | grep "sufficient" > /dev/null 2>&1
            if ((!$?)); then
               FirstSufficientLine=`cat /etc/pam.d/system-auth | grep -v "pam_deny.so" | grep -n "^account " | grep "sufficient" | head -1 | awk -F':' '{print $1}'`
               if [ $FoundLine -lt $FirstSufficientLine ]; then
                  echo "CNL.1.1.6 : The 'account required pam_tally.so' was found in /etc/pam.d/system-auth file and is in the correct position."
               else
                  echo "CNL.1.1.6 : WARNING - 'account required pam_tally.so' was found in /etc/pam.d/system-auth file BUT is in the wrong position within the file and does not precede any lines of the same module type with a control flag of sufficient with the exception of pam_deny.so"
               fi
            else
               echo "CNL.1.1.6 : The 'account required pam_tally.so' was found in /etc/pam.d/system-auth file and is in the correct position."
            fi
         else
            echo "CNL.1.1.6 : WARNING - 'account required pam_tally.so' was not found in the /etc/pam.d/system-auth file."
         fi
      else
         echo "CNL.1.1.6 : The /etc/pam.d/system-auth file does not exist. Checking other control files...."
         if [ -f /etc/pam.d/login ]; then
            cat /etc/pam.d/login | grep -v "pam_deny.so" | grep "^auth " | grep "required" | egrep 'pam_tally.so|pam_tally2.so' | grep "deny=5" | grep "onerr=fail" | grep "per_user" | grep "no_lock_time" > /dev/null 2>&1
            if ((!$?)); then
               FoundLine=`cat /etc/pam.d/login | grep -v "pam_deny.so" | grep -n "^auth " | grep "required" | egrep 'pam_tally.so|pam_tally2.so' | grep "deny=5" | grep "onerr=fail" | grep "per_user" | grep "no_lock_time" | awk -F':' '{print $1}'`
               cat /etc/pam.d/login | grep -v "pam_deny.so" | grep "^auth " | grep "sufficient" > /dev/null 2>&1
               if ((!$?)); then
                  FirstSufficientLine=`cat /etc/pam.d/login | grep -v "pam_deny.so" | grep -n "^auth " | grep "sufficient" | head -1 | awk -F':' '{print $1}'`
                  if [ $FoundLine -lt $FirstSufficientLine ]; then
                     echo "CNL.1.1.6 : The 'auth required pam_tally.so deny=5 onerr=fail per_user no_lock_time' was found in /etc/pam.d/login file and is in the correct position."
                  else
                     echo "CNL.1.1.6 : WARNING - 'auth required pam_tally.so deny=5 onerr=fail per_user no_lock_time' was found in /etc/pam.d/login file BUT is in the wrong position within the file and does not precede any lines of the same module type with a control flag of sufficient with the exception of pam_deny.so"
                  fi
               else
                  echo "CNL.1.1.6 : The 'auth required pam_tally.so deny=5 onerr=fail per_user no_lock_time' was found in /etc/pam.d/login file and is in the correct position."
               fi
            else
               echo "CNL.1.1.6 : WARNING - 'auth required pam_tally.so deny=5 onerr=fail per_user no_lock_time' was not found in the /etc/pam.d/login file."
            fi
            cat /etc/pam.d/login | grep -v "pam_deny.so" | grep "^account " | grep "required" | egrep 'pam_tally.so|pam_tally2.so' > /dev/null 2>&1
            if ((!$?)); then
               FoundLine=`cat /etc/pam.d/login | grep -v "pam_deny.so" | grep "^account " | grep -n "required" | egrep 'pam_tally.so|pam_tally2.so' | awk -F':' '{print $1}'`
               cat /etc/pam.d/login | grep -v "pam_deny.so" | grep "^account " | grep "sufficient" > /dev/null 2>&1
               if ((!$?)); then
                  FirstSufficientLine=`cat /etc/pam.d/login | grep -v "pam_deny.so" | grep -n "^account " | grep "sufficient" | head -1 | awk -F':' '{print $1}'`
                  if [ $FoundLine -lt $FirstSufficientLine ]; then
                     echo "CNL.1.1.6 : The 'account required pam_tally.so' was found in /etc/pam.d/login file and is in the correct position."
                  else
                     echo "CNL.1.1.6 : WARNING - 'account required pam_tally.so' was found in /etc/pam.d/login file BUT is in the wrong position within the file and does not precede any lines of the same module type with a control flag of sufficient with the exception of pam_deny.so"
                  fi
               else
                  echo "CNL.1.1.6 : The 'account required pam_tally.so' was found in /etc/pam.d/login file and is in the correct position."
               fi
            else
               echo "CNL.1.1.6 : WARNING - 'account required pam_tally.so' was not found in the /etc/pam.d/login file."
            fi
         else
            echo "CNL.1.1.6 : WARNING - The /etc/pam.d/login file does not exist."
         fi
         if [ -f /etc/pam.d/passwd ]; then
            cat /etc/pam.d/passwd | grep -v "pam_deny.so" | grep "^auth " | grep "required" | egrep 'pam_tally.so|pam_tally2.so' | grep "deny=5" | grep "onerr=fail" | grep "per_user" | grep "no_lock_time" > /dev/null 2>&1
            if ((!$?)); then
               FoundLine=`cat /etc/pam.d/passwd | grep -v "pam_deny.so" | grep -n "^auth " | grep "required" | egrep 'pam_tally.so|pam_tally2.so' | grep "deny=5" | grep "onerr=fail" | grep "per_user" | grep "no_lock_time" | awk -F':' '{print $1}'`
               cat /etc/pam.d/passwd | grep -v "pam_deny.so" | grep "^auth " | grep "sufficient" > /dev/null 2>&1
               if ((!$?)); then
                  FirstSufficientLine=`cat /etc/pam.d/passwd | grep -v "pam_deny.so" | grep -n "^auth " | grep "sufficient" | head -1 | awk -F':' '{print $1}'`
                  if [ $FoundLine -lt $FirstSufficientLine ]; then
                     echo "CNL.1.1.6 : The 'auth required pam_tally.so deny=5 onerr=fail per_user no_lock_time' was found in /etc/pam.d/passwd file and is in the correct position."
                  else
                     echo "CNL.1.1.6 : WARNING - 'auth required pam_tally.so deny=5 onerr=fail per_user no_lock_time' was found in /etc/pam.d/passwd file BUT is in the wrong position within the file and does not precede any lines of the same module type with a control flag of sufficient with the exception of pam_deny.so"
                  fi
               else
                  echo "CNL.1.1.6 : The 'auth required pam_tally.so deny=5 onerr=fail per_user no_lock_time' was found in /etc/pam.d/passwd file and is in the correct position."
               fi
            else
               echo "CNL.1.1.6 : WARNING - 'auth required pam_tally.so deny=5 onerr=fail per_user no_lock_time' was not found in the /etc/pam.d/passwd file."
            fi
            cat /etc/pam.d/passwd | grep -v "pam_deny.so" | grep "^account " | grep "required" | egrep 'pam_tally.so|pam_tally2.so' > /dev/null 2>&1
            if ((!$?)); then
               FoundLine=`cat /etc/pam.d/passwd | grep -v "pam_deny.so" | grep -n "^account " | grep "required" | egrep 'pam_tally.so|pam_tally2.so' | awk -F':' '{print $1}'`
               cat /etc/pam.d/passwd | grep -v "pam_deny.so" | grep "^account " | grep "sufficient" > /dev/null 2>&1
               if ((!$?)); then
                  FirstSufficientLine=`cat /etc/pam.d/passwd | grep -v "pam_deny.so" | grep -n "^account " | grep "sufficient" | head -1 | awk -F':' '{print $1}'`
                  if [ $FoundLine -lt $FirstSufficientLine ]; then
                     echo "CNL.1.1.6 : The 'account required pam_tally.so' was found in /etc/pam.d/passwd file and is in the correct position."
                  else
                     echo "CNL.1.1.6 : WARNING - 'account required pam_tally.so' was found in /etc/pam.d/passwd file BUT is in the wrong position within the file and does not precede any lines of the same module type with a control flag of sufficient with the exception of pam_deny.so"
                  fi
               else
                  echo "CNL.1.1.6 : The 'account required pam_tally.so' was found in /etc/pam.d/passwd file and is in the correct position."
               fi
            else
               echo "CNL.1.1.6 : WARNING - 'account required pam_tally.so' was not found in the /etc/pam.d/passwd file."
            fi
         else
            echo "CNL.1.1.6 : WARNING - The /etc/pam.d/passwd file does not exist."
         fi
         if [ -f /etc/pam.d/sshd ]; then
            cat /etc/pam.d/sshd | grep -v "pam_deny.so" | grep "^auth " | grep "required" | egrep 'pam_tally.so|pam_tally2.so' | grep "deny=5" | grep "onerr=fail" | grep "per_user" | grep "no_lock_time" > /dev/null 2>&1
            if ((!$?)); then
               FoundLine=`cat /etc/pam.d/sshd | grep -v "pam_deny.so" | grep -n "^auth " | grep "required" | egrep 'pam_tally.so|pam_tally2.so' | grep "deny=5" | grep "onerr=fail" | grep "per_user" | grep "no_lock_time" | awk -F':' '{print $1}'`
               cat /etc/pam.d/sshd | grep -v "pam_deny.so" | grep "^auth " | grep "sufficient" > /dev/null 2>&1
               if ((!$?)); then
                  FirstSufficientLine=`cat /etc/pam.d/sshd | grep -v "pam_deny.so" | grep -n "^auth " | grep "sufficient" | head -1 | awk -F':' '{print $1}'`
                  if [ $FoundLine -lt $FirstSufficientLine ]; then
                     echo "CNL.1.1.6 : The 'auth required pam_tally.so deny=5 onerr=fail per_user no_lock_time' was found in /etc/pam.d/sshd file and is in the correct position."
                  else
                     echo "CNL.1.1.6 : WARNING - 'auth required pam_tally.so deny=5 onerr=fail per_user no_lock_time' was found in /etc/pam.d/sshd file BUT is in the wrong position within the file and does not precede any lines of the same module type with a control flag of sufficient with the exception of pam_deny.so"
                  fi
               else
                  echo "CNL.1.1.6 : The 'auth required pam_tally.so deny=5 onerr=fail per_user no_lock_time' was found in /etc/pam.d/sshd file and is in the correct position."
               fi
            else
               echo "CNL.1.1.6 : WARNING - 'auth required pam_tally.so deny=5 onerr=fail per_user no_lock_time' was not found in the /etc/pam.d/sshd file."
            fi
            cat /etc/pam.d/sshd | grep -v "pam_deny.so" | grep "^account " | grep "required" | egrep 'pam_tally.so|pam_tally2.so' > /dev/null 2>&1
            if ((!$?)); then
               FoundLine=`cat /etc/pam.d/sshd | grep -v "pam_deny.so" | grep -n "^account " | grep "required" | egrep 'pam_tally.so|pam_tally2.so' | awk -F':' '{print $1}'`
               cat /etc/pam.d/sshd | grep -v "pam_deny.so" | grep "^account " | grep "sufficient" > /dev/null 2>&1
               if ((!$?)); then
                  FirstSufficientLine=`cat /etc/pam.d/sshd | grep -v "pam_deny.so" | grep -n "^account " | grep "sufficient" | head -1 | awk -F':' '{print $1}'`
                  if [ $FoundLine -lt $FirstSufficientLine ]; then
                     echo "CNL.1.1.6 : The 'account required pam_tally.so' was found in /etc/pam.d/sshd file and is in the correct position."
                  else
                     echo "CNL.1.1.6 : WARNING - 'account required pam_tally.so' was found in /etc/pam.d/sshd file BUT is in the wrong position within the file and does not precede any lines of the same module type with a control flag of sufficient with the exception of pam_deny.so"
                  fi
               else
                  echo "CNL.1.1.6 : The 'account required pam_tally.so' was found in /etc/pam.d/sshd file and is in the correct position."
               fi
            else
               echo "CNL.1.1.6 : WARNING - 'account required pam_tally.so' was not found in the /etc/pam.d/sshd file."
            fi
         else
            echo "CNL.1.1.6 : WARNING - The /etc/pam.d/sshd file does not exist."
         fi
         if [ -f /etc/pam.d/su ]; then
            cat /etc/pam.d/su | grep -v "pam_deny.so" | grep "^auth " | grep "required" | egrep 'pam_tally.so|pam_tally2.so' | grep "deny=5" | grep "onerr=fail" | grep "per_user" | grep "no_lock_time" > /dev/null 2>&1
            if ((!$?)); then
               FoundLine=`cat /etc/pam.d/su | grep -v "pam_deny.so" | grep -n "^auth " | grep "required" | egrep 'pam_tally.so|pam_tally2.so' | grep "deny=5" | grep "onerr=fail" | grep "per_user" | grep "no_lock_time" | awk -F':' '{print $1}'`
               cat /etc/pam.d/su | grep -v "pam_deny.so" | grep "^auth " | grep "sufficient" > /dev/null 2>&1
               if ((!$?)); then
                  FirstSufficientLine=`cat /etc/pam.d/su | grep -v "pam_deny.so" | grep -n "^auth " | grep "sufficient" | head -1 | awk -F':' '{print $1}'`
                  if [ $FoundLine -lt $FirstSufficientLine ]; then
                     echo "CNL.1.1.6 : The 'auth required pam_tally.so deny=5 onerr=fail per_user no_lock_time' was found in /etc/pam.d/su file and is in the correct position."
                  else
                     echo "CNL.1.1.6 : WARNING - 'auth required pam_tally.so deny=5 onerr=fail per_user no_lock_time' was found in /etc/pam.d/su file BUT is in the wrong position within the file and does not precede any lines of the same module type with a control flag of sufficient with the exception of pam_deny.so"
                  fi
               else
                  echo "CNL.1.1.6 : The 'auth required pam_tally.so deny=5 onerr=fail per_user no_lock_time' was found in /etc/pam.d/su file and is in the correct position."
               fi
            else
               echo "CNL.1.1.6 : WARNING - 'auth required pam_tally.so deny=5 onerr=fail per_user no_lock_time' was not found in the /etc/pam.d/su file."
            fi
            cat /etc/pam.d/su | grep -v "pam_deny.so" | grep "^account " | grep "required" | egrep 'pam_tally.so|pam_tally2.so' > /dev/null 2>&1
            if ((!$?)); then
               FoundLine=`cat /etc/pam.d/su | grep -v "pam_deny.so" | grep -n "^account " | grep "required" | egrep 'pam_tally.so|pam_tally2.so' | awk -F':' '{print $1}'`
               cat /etc/pam.d/su | grep -v "pam_deny.so" | grep "^account " | grep "sufficient" > /dev/null 2>&1
               if ((!$?)); then
                  FirstSufficientLine=`cat /etc/pam.d/su | grep -v "pam_deny.so" | grep -n "^account " | grep "sufficient" | head -1 | awk -F':' '{print $1}'`
                  if [ $FoundLine -lt $FirstSufficientLine ]; then
                     echo "CNL.1.1.6 : The 'account required pam_tally.so' was found in /etc/pam.d/su file and is in the correct position."
                  else
                     echo "CNL.1.1.6 : WARNING - 'account required pam_tally.so' was found in /etc/pam.d/su file BUT is in the wrong position within the file and does not precede any lines of the same module type with a control flag of sufficient with the exception of pam_deny.so"
                  fi
               else
                  echo "CNL.1.1.6 : The 'account required pam_tally.so' was found in /etc/pam.d/su file and is in the correct position."
               fi
            else
               echo "CNL.1.1.6 : WARNING - 'account required pam_tally.so' was not found in the /etc/pam.d/su file."
            fi
         else
            echo "CNL.1.1.6 : WARNING - The /etc/pam.d/su file does not exist."
         fi
      fi
   fi
else
   echo "CNL.1.1.6 : WARNING - THIS IS NOT A RedHat OR SUSE SERVER. THIS SCRIPT IS NOT CONFIGURED TO CHECK THIS SECTION!!!"
fi

echo ""
RootPass=`grep "^root:" /etc/shadow | awk -F':' '{print $2}'`
RootPassMax=`grep "^root:" /etc/shadow | awk -F':' '{print $5}'`
RootPassMin=`grep "^root:" /etc/shadow | awk -F':' '{print $4}'`
echo $RootPass | grep "^!" > /dev/null 2>&1
RootPassLocked=$?
if [[ ! -z $RootPass ]] && [[ $RootPassLocked -ne 0 && $RootPass != "LK" && $RootPass != "*" ]] && [[ $RootPassMax -le 90 ]] && [[ $RootPassMin -eq 1 ]]; then
   echo "CNL.1.1.7.1 : User root has password assigned with Min/Max Password Age set correctly."
else
   echo "CNL.1.1.7.1 : WARNING - User root does not have password set and/or Min/Max Password Age is incorrect"
fi
echo "CNL.1.1.7.1 : ID=root : Password=$RootPass : Max Age=$RootPassMax : Min Age=$RootPassMin"

echo ""
if [ -f /etc/securetty ]; then
   TTYAccess=`cat /etc/securetty | grep -vc "^#"`
   if [ $TTYAccess -gt 2 ]; then
      echo "CNL.1.1.7.2 : WARNING - Root login access does not appear to be restricted in /etc/securetty"
      echo "CNL.1.1.7.2 : Here is the contents of the /etc/securetty file:"
      cat /etc/securetty >> $LOGFILE
      echo ""
   else
      echo "CNL.1.1.7.2 : Root login access is restricted in the /etc/securetty file."
   fi
else
   echo "CNL.1.1.7.2 : WARNING - The /etc/securetty file does not exist!"
fi
if [ -f /etc/ssh/sshd_config ]; then
   grep "^PermitRootLogin" /etc/ssh/sshd_config | grep -q "no"
   if (($?)); then
      echo "CNL.1.1.7.2 : WARNING - Root logins are not disabled in sshd_config"
      grep "^PermitRootLogin" /etc/ssh/sshd_config >> $LOGFILE
   else
      echo "CNL.1.1.7.2 : Root logins are disabled in sshd_config"
      grep "^PermitRootLogin" /etc/ssh/sshd_config | grep "no" >> $LOGFILE
   fi
else
   echo "CNL.1.1.7.2 : WARNING - The sshd_config file could not be found!"
   echo "CNL.1.1.7.2 : Please review the detailed SSH check portion of the log file below"
   echo "CNL.1.1.7.2 : and check the status of the PermitRootLogin section for status."
fi

echo ""
cat /dev/null > CNL1173_temp
for SysID in bin daemon adm lp sync shutdown halt mail uucp operator games gopher ftp nobody dbus usbmuxd rpc avahi-autoipd vcsa rtkit saslauth postfix avahi ntp apache radvd rpcuser nfsnobody qemu haldaemon nm-openconnect pulse gsanslcd gdm sshd tcpdump
do
grep -q "^$SysID:" /etc/shadow
if ((!$?)); then
   TestPasswd=`grep "^$SysID:" /etc/shadow | awk -F':' '{print $2}'`
   if [ -n $Testpasswd ]; then
      echo $TestPasswd | grep -q "^!"
      TestPasswdLocked=$?
      if [[ $TestPasswd != "*" && $TestPasswdLocked -eq 1 && $Testpasswd != "LK" ]]; then
         echo $SysID >> CNL1173_temp
      fi
   else
      echo "Empty shadow paramter: $SysID" >> CNL1173_temp
   fi
fi
done
if [ -s CNL1173_temp ]; then
   echo "CNL.1.1.7.3 : WARNING - Some system ID(s) exist that appear to have a password assigned to them:"
   cat CNL1173_temp >> $LOGFILE
else
   echo "CNL.1.1.7.3 : All existing system IDs appear to have no password assigned to them or are locked."
fi
rm -rf CNL1173_temp

echo ""
sudo -h > /dev/null 2>&1
if (($?)); then
   if [ ! -x /usr/bin/sudo ]; then
      if [ ! -x /usr/local/bin/sudo ]; then
         SudoFound=1
      else
         SudoFound=0
      fi
   else
      SudoFound=0
   fi
else
   SudoFound=0
fi
if ((!$SudoFound)); then
   echo "CNL.1.1.8.1 : Sudo is installed."
else
   echo "CNL.1.1.8.1 : WARNING - Sudo does not appear to be installed."
fi

echo ""
PID=$$
sort -t : -k 3n /etc/passwd|grep -v \^# > passwd.$PID
if [[ -z `cat passwd.$PID | awk -F: '{print $3}' | uniq -d` ]]; then 
   echo "CNL.1.1.8.2 : No duplicate UID found"
else
   cat passwd.$PID | awk -F: '{print $3}' | uniq -d | while read SAME_IDS >> $LOGFILE
   do
   echo "CNL.1.1.8.2 : WARNING - UID '$SAME_IDS' is associated with multiple user accounts."
   done
fi
if [ -f passwd.$PID ]; then rm passwd.$PID;fi

echo ""
PID=$$
sort -t : -k 3n /etc/group|grep -v \^# > group.$PID
if [[ -z `cat group.$PID | awk -F: '{print $3}' | uniq -d` ]]; then 
   echo "CNL.1.1.8.3 : No duplicate GID found"
else
   cat group.$PID | awk -F: '{print $3}' | uniq -d | while read SAME_GIDS >> $LOGFILE
   do
   echo "CNL.1.1.8.3 : WARNING - GID '$SAME_GIDS' is associated with multiple user accounts."
   done
fi
if [ -f group.$PID ]; then rm group.$PID;fi

echo ""
cat /dev/null > CNL.1.1.9.0_temp
if [[ $OSFlavor = "RedHat" && $RHVER -ge 6 ]] || [[ $OSFlavor = "SuSE" && $SVER -ge 10 ]]; then
   for USER in `cat /etc/passwd | grep -v "/sbin/nologin" | grep -v "/bin/false" | awk -F':' '{print $1}'`
   do
   USERGID=`grep "^$USER:" /etc/passwd | awk -F':' '{print $4}'`
   if [[ -z $USERGID ]] || [[ $USERGID -le 199 ]]; then
      USERPasswd=`grep "^$USER:" /etc/shadow | awk -F':' '{print $2}'`
      echo $USERPasswd | grep "^!" > /dev/null 2>&1
      USERPasswdLocked=$?
      USERPasswdMax=`grep "^$USER:" /etc/shadow | awk -F':' '{print $5}'`
      if [[ ! -z $USERPasswd && $USERPasswdLocked -eq 1 && $USERPasswd != "LK" && $USERPasswd != "*" ]] && [[ -z $USERPasswdMax || $USERPasswdMax -gt 90 ]]; then
         echo "User=$USER : GID=$USERGID : MaxPassword=$USERPasswdMax" >> CNL.1.1.9.0_temp
      fi
   fi
   done
   if [ -s CNL.1.1.9.0_temp ]; then
      echo "CNL.1.1.9.0 : WARNING - Login abled user(s) exist with GID <= 199 that have a non-expiring password set:"
      cat CNL.1.1.9.0_temp >> $LOGFILE
   else
      echo "CNL.1.1.9.0 : All login abled user(s) with GID <= 199 have a password set to expire."
   fi
else
   for USER in `cat /etc/passwd | grep -v "/sbin/nologin" | grep -v "/bin/false" | awk -F':' '{print $1}'`
   do
   USERGID=`grep "^$USER:" /etc/passwd | awk -F':' '{print $4}'`
   if [[ -z $USERGID ]] || [[ $USERGID -le 99 ]]; then
      USERPasswd=`grep "^$USER:" /etc/shadow | awk -F':' '{print $2}'`
      echo $USERPasswd | grep "^!" > /dev/null 2>&1
      USERPasswdLocked=$?
      USERPasswdMax=`grep "^$USER:" /etc/shadow | awk -F':' '{print $5}'`
      if [[ ! -z $USERPasswd && $USERPasswdLocked -eq 1 && $USERPasswd != "LK" && $USERPasswd != "*" ]] && [[ -z $USERPasswdMax || $USERPasswdMax -gt 90 ]]; then
         echo "User=$USER : GID=$USERGID : MaxPassword=$USERPasswdMax" >> CNL.1.1.9.0_temp
      fi
   fi
   done
   if [ -s CNL.1.1.9.0_temp ]; then
      echo "CNL.1.1.9.0 : WARNING - Login abled user(s) exist with GID <= 99 that have a non-expiring password set:"
      cat CNL.1.1.9.0_temp >> $LOGFILE
   else
      echo "CNL.1.1.9.0 : All login abled user(s) with GID <= 99 have a password set to expire."
   fi
fi
rm -rf CNL.1.1.9.0_temp

echo ""
echo "CNL.1.1.9.1 : Please refer to section 1.1.10.1 below as it is the same thing."

#Process the Exemptions to password rules...
echo ""
cat /dev/null > PasswdExemptTemp
if [ -s PMDTestOut ]; then
   for USER in `cat PMDTestOut | awk -F'=' '{print $2}' | awk '{print $1}'`
   do
   grep "^$USER:" /etc/passwd | grep -v "bin/false" | grep -v "/sbin/nologin" > /dev/null 2>&1
   if ((!$?)); then
      echo $USER >> PasswdExemptTemp
   fi
   done
   if [ -s PasswdExemptTemp ]; then
      echo "CNL.1.1.10.1 : WARNING - User(s) exist with non-expiring password that is not set to /bin/false or /sbin/nologin in /etc/passwd:"
      cat PasswdExemptTemp >> $LOGFILE
   else
      echo "CNL.1.1.10.1 : All user(s) with non-expiring passwords are set to /bin/false or /sbin/nologin in /etc/passwd"
   fi
   cat /dev/null > PasswdExemptTemp
   echo ""

   if (($FTPEnabled)); then
   #if ((!$FTPEnabled)); then
      echo "CNL.1.1.10.2 : This server has $FTPType installed and enabled."
      if [ -f $FTPfile ]; then
         for USER in `cat PMDTestOut | awk -F'=' '{print $2}' | awk '{print $1}'`
         do
         grep -q "^$USER" $FTPfile
         if (($?)); then
            echo $USER > PasswdExemptTemp
         fi
         done
         if [ -s PasswdExemptTemp ]; then
            echo "CNL.1.1.10.2 : WARNING - Users with non-expiring passwords exist that are NOT configured in $FTPfile"
            cat PasswdExemptTemp >> $LOGFILE
         else
            echo "CNL.1.1.10.2 : All users with non-expiring passwords are configured in $FTPfile"
         fi
      else
         echo "CNL.1.1.10.2 : WARNING - The $FTPfile does NOT exist!"
      fi
   else
      echo "CNL.1.1.10.2 : N/A - No ftp server is installed and enabled."
   fi
   cat /dev/null > PasswdExemptTemp
   echo ""
   for USER in `cat PMDTestOut | awk -F'=' '{print $2}' | awk '{print $1}'`
   do
   USERpassword=`grep "^$USER:" /etc/shadow | awk -F':' '{print $2}'`
   echo $USERpassword | grep -q "^!"
   if (($?)); then
      echo $USER >> PasswdExemptTemp
   fi
   done
   if [ -s PasswdExemptTemp ]; then
      echo "CNL.1.1.11.1 : WARNING - Users with non-expiring passwords exist without '!!' or '!' in field 2 of the /etc/shadow file:"
      cat PasswdExemptTemp >> $LOGFILE
   else
      echo "CNL.1.1.11.1 : All users with non-expiring passwords are locked and have '!!' or '!' in field 2 of the /etc/shadow file."
   fi
   cat /dev/null > PasswdExemptTemp
   echo ""
   for USER in `cat PMDTestOut | awk -F'=' '{print $2}' | awk '{print $1}'`
   do
   USERpassword=`grep "^$USER:" /etc/shadow | awk -F':' '{print $2}'`
   echo $USERpassword | grep -q "^!"
   USERpasswordLK=$?
   if [[ $USERpassword != "x" ]] && [[ $USERpasswordLK -eq 1 ]] && [[ $USERpassword != "*" ]]; then
      echo $USER >> PasswdExemptTemp
   fi
   done
   if [ -s PasswdExemptTemp ]; then
      echo "CNL.1.1.12.1 : WARNING - Users with non-expiring passwords exist without '!', '!!', 'x', or '*' in field 2 of the /etc/shadow file:"
      cat PasswdExemptTemp >> $LOGFILE
   else
      echo "CNL.1.1.12.1 : All users with non-expiring passwords are locked and/or have no password set."
   fi
   cat /dev/null > PasswdExemptTemp
   echo ""
   if [ -f /etc/pam.d/system-auth ]; then
      grep "^auth" /etc/pam.d/system-auth | grep "required" | grep "pam_listfile.so" | grep "item=user" | grep "sense=deny" | grep "file=/etc/security" | grep "onerr=succeed" > /dev/null 2>&1
      if ((!$?)); then
         FoundLine=`grep -n "^auth" /etc/pam.d/system-auth | grep "required" | grep "pam_listfile.so" | grep "item=user" | grep "sense=deny" | grep "file=/etc/security" | grep "onerr=succeed" | awk -F':' '{print $1}'`
         SecurityFile=`grep "^auth" /etc/pam.d/system-auth | grep "required" | grep "pam_listfile.so" | grep "item=user" | grep "sense=deny" | grep "file=/etc/security" | grep "onerr=succeed" | xargs -n 1 | sort -u|xargs | awk '{print $2}' | awk -F'=' '{print $2}'`
         FirstSufficientLine=`cat /etc/pam.d/system-auth | grep -n "^auth " | grep "sufficient" | head -1 | awk -F':' '{print $1}'`
         if [ $FoundLine -lt $FirstSufficientLine ]; then
            echo "CNL.1.1.13.1 : The necessary auth entry has been found in /etc/pam.d/system-auth and is in the correct position:"
            grep "^auth" /etc/pam.d/system-auth >> $LOGFILE
            echo ""
         else
            echo "CNL.1.1.13.1 : WARNING - The necessary auth entry is in the /etc/pam.d/system-auth file BUT is in the incorrect position!"
            grep "^auth" /etc/pam.d/system-auth >> $LOGFILE
            echo ""
         fi
         if [ -f $SecurityFile ]; then
            FilePerms=`ls -ald $SecurityFile | awk '{print $1}' | cut -c6-10`
            if [ $FilePerms != "-----" ]; then
               echo "CNL.1.1.13.1 : WARNING - The permissions on the \$FILENAME file are not 0640!"
            else
               echo "CNL.1.1.13.1 : The permissions on the \$FILENAME are correct."
            fi
            ls -ald $SecurityFile >> $LOGFILE
            echo ""
            for USER in `cat PMDTestOut | awk -F'=' '{print $2}' | awk '{print $1}'`
            do
            grep -q ^$USER $SecurityFile
            if (($?)); then
               echo $USER >> PasswdExemptTemp
            fi
            done
            if [ -s PasswdExemptTemp ]; then
               echo "CNL.1.1.13.2 : WARNING - User(s) with non-expiring passwords exist that are not in $SecurityFile:"
               cat PasswdExemptTemp >> $LOGFILE
            else
               echo "CNL.1.1.13.2 : All user(s) with non-expiring passwords are listed in the $SecurityFile."
            fi
         else
            echo "CNL.1.1.13.1 : WARNING - The /etc/security/\$FILENAME file does not exist as set in the system-auth file"
            echo ""
            echo "CNL.1.1.13.2 : WARNING - The /etc/security/\$FILENAME file does not exist as set in the system-auth file"
         fi
      else
         echo "CNL.1.1.13.1 : WARNING - The necessary auth entry in /etc/pam.d/system-auth file does NOT exist"
         echo ""
         echo "CNL.1.1.13.2 : WARNING - The necessary auth entry in /etc/pam.d/system-auth file does NOT exist"
      fi
      if [ $OSFlavor = "RedHat" ] && [ $RHVER -ge 6 ]; then
         if [ -f /etc/pam.d/password-auth ]; then
            grep "^auth" /etc/pam.d/password-auth | grep "required" | grep "pam_listfile.so" | grep "item=user" | grep "sense=deny" | grep "file=/etc/security" | grep "onerr=succeed" > /dev/null 2>&1
            if ((!$?)); then
               FoundLine=`grep -n "^auth" /etc/pam.d/password-auth | grep "required" | grep "pam_listfile.so" | grep "item=user" | grep "sense=deny" | grep "file=/etc/security" | grep "onerr=succeed" | awk -F':' '{print $1}'`
               SecurityFile=`grep "^auth" /etc/pam.d/password-auth | grep "required" | grep "pam_listfile.so" | grep "item=user" | grep "sense=deny" | grep "file=/etc/security" | grep "onerr=succeed" | xargs -n 1 | sort -u|xargs | awk '{print $2}' | awk -F'=' '{print $2}'`
               FirstSufficientLine=`cat /etc/pam.d/password-auth | grep -n "^auth " | grep "sufficient" | head -1 | awk -F':' '{print $1}'`
               if [ $FoundLine -lt $FirstSufficientLine ]; then
                  echo "CNL.1.1.13.1 : The necessary auth entry has been found in /etc/pam.d/password-auth and is in the correct position:"
                  grep "^auth" /etc/pam.d/password-auth >> $LOGFILE
                  echo ""
               else
                  echo "CNL.1.1.13.1 : WARNING - The necessary auth entry is in the /etc/pam.d/password-auth file BUT is in the incorrect position!"
                  grep "^auth" /etc/pam.d/password-auth >> $LOGFILE
                  echo ""
               fi
               if [ -f $SecurityFile ]; then
                  FilePerms=`ls -ald $SecurityFile | awk '{print $1}' | cut -c6-10`
                  if [ $FilePerms != "-----" ]; then
                     echo "CNL.1.1.13.1 : WARNING - The permissions on the \$FILENAME file are not 0640!"
                  else
                     echo "CNL.1.1.13.1 : The permissions on the \$FILENAME are correct."
                  fi
                  ls -ald $SecurityFile >> $LOGFILE
                  echo ""
                  for USER in `cat PMDTestOut | awk -F'=' '{print $2}' | awk '{print $1}'`
                  do
                  grep -q ^$USER $SecurityFile
                  if (($?)); then
                     echo $USER >> PasswdExemptTemp
                  fi
                  done
                  if [ -s PasswdExemptTemp ]; then
                     echo "CNL.1.1.13.2 : WARNING - User(s) with non-expiring passwords exist that are not in $SecurityFile:"
                     cat PasswdExemptTemp >> $LOGFILE
                  else
                     echo "CNL.1.1.13.2 : All user(s) with non-expiring passwords are listed in the $SecurityFile."
                  fi
               else
                  echo "CNL.1.1.13.1 : WARNING - The /etc/security/\$FILENAME file does not exist as set in the password-auth file"
                  echo ""
                  echo "CNL.1.1.13.2 : WARNING - The /etc/security/\$FILENAME file does not exist as set in the password-auth file"
               fi
            else
               echo "CNL.1.1.13.1 : WARNING - The necessary auth entry in /etc/pam.d/password-auth file does NOT exist"
               echo ""
               echo "CNL.1.1.13.2 : WARNING - The necessary auth entry in /etc/pam.d/password-auth file does NOT exist"
            fi
         else
            echo "CNL.1.1.13.1 : WARNING - The /etc/pam.d/password-auth file does NOT exist!"
            echo ""
            echo "CNL.1.1.13.2 : WARNING - The /etc/pam.d/password-auth file does NOT exist!"
         fi
      else
         echo "CNL.1.1.13.1 : Note that this is not a RHEL V6 or later OS."
      fi
   else
      echo "CNL.1.1.13.1 : WARNING - The /etc/pam.d/system-auth file does not exist!"
      echo ""
      echo "CNL.1.1.13.2 : WARNING - The /etc/pam.d/system-auth file does not exist!"
   fi
   cat /dev/null > PasswdExemptTemp
   echo ""
   FTPEnabled=1
   if ((!$FTPEnabled)); then
      echo "CNL.1.1.13.3 : This server has $FTPType installed and enabled."
      if [ -f $FTPfile ]; then
         for USER in `cat PMDTestOut | awk -F'=' '{print $2}' | awk '{print $1}'`
         do
         grep -q "^$USER" $FTPfile
         if (($?)); then
            echo $USER >> PasswdExemptTemp
         fi
         done
         if [ -s PasswdExemptTemp ]; then
            echo "CNL.1.1.13.3 : WARNING - Users with non-expiring passwords exist that are NOT configured in $FTPfile"
            cat PasswdExemptTemp >> $LOGFILE
         else
            echo "CNL.1.1.13.3 : All users with non-expiring passwords are configured in $FTPfile"
         fi
      else
         echo "CNL.1.1.13.3 : WARNING - The $FTPfile does NOT exist!"
      fi
   else
      echo "CNL.1.1.13.3 : N/A - No ftp server is installed and enabled."
   fi
   echo ""
   if [ -f /etc/ssh/sshd_config ]; then
      SSHD_FILE=/etc/ssh/sshd_config
   elif [ -f /usr/local/etc/ssh/sshd_config ]; then
      SSHD_FILE=/usr/local/etc/ssh/sshd_config
   else
      SSHD_FILE=NOT_FOUND
   fi
   if [ $SSHD_FILE != "NOT_FOUND" ]; then
      grep "^UsePAM" $SSHD_FILE | grep -q "yes"
      if (($?)); then
         echo "CNL.1.1.13.4 : WARNING - The 'UsePAM yes' parameter does not exist in the $SSHD_FILE file"
      else
         echo "CNL.1.1.13.4 : The 'UsePAM yes' parameter exists in the $SSHD_FILE file."
         grep "^UsePAM" $SSHD_FILE | grep "yes" >> $LOGFILE
      fi
   else
      echo "CNL.1.1.13.4 : WARNING - The sshd_config file could not be found!"
   fi
else
   echo "CNL.1.1.10.1 : N/A - There were no login abled users with non-expiring passwords found."
   echo ""
   echo "CNL.1.1.10.2 : N/A - There were no login abled users with non-expiring passwords found."
   echo ""
   echo "CNL.1.1.11.1 : N/A - There were no login abled users with non-expiring passwords found."
   echo ""
   echo "CNL.1.1.12.1 : N/A - There were no login abled users with non-expiring passwords found."
   echo ""
   echo "CNL.1.1.13.1 : N/A - There were no login abled users with non-expiring passwords found."
   echo ""
   echo "CNL.1.1.13.2 : N/A - There were no login abled users with non-expiring passwords found."
   echo ""
   echo "CNL.1.1.13.3 : N/A - There were no login abled users with non-expiring passwords found."
   echo ""
   echo "CNL.1.1.13.4 : N/A - There were no login abled users with non-expiring passwords found."
fi
#Clean up our temp files:
rm -rf PasswdExemptTemp PMDTestOut $LOGFILE


