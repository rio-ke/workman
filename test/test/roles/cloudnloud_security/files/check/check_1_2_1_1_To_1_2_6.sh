#echo "1.2 Logging"
#echo "==========="

LOGFILE=/tmp/file1.txt
if [ `id -unr` = "root" ]; then
   if [ -f /etc/redhat-release ]; then 
      OSFlavor=RedHat
   elif [ -f /etc/SuSE-release ]; then
      OSFlavor=SuSE
   else
      exit
   fi
else
   exit 1
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
   cat /etc/SuSE-release >> $LOGFILE
   SVER=`cat /etc/SuSE-release | grep "VERSION" | awk '{print $3}'`
else
   RHVER=X
   SVER=X
fi


#echo "1.2 Logging"
#echo "==========="

echo ""
if [ -f /etc/syslog.conf ]; then
   cat /etc/syslog.conf | grep -v "^#" | grep "\*.info" | grep "authpriv.none" | grep "/var/log/messages" > /dev/null 2>&1
   if (($?)); then
      echo "CNL.1.2.1.1 : WARNING - The '*.info' and/or 'authpriv.none' are not configured for /var/log/messages in /etc/syslog.conf!"
      echo ""
   else
      echo "CNL.1.2.1.1 : The '*.info' and/or 'authpriv.none' are configured for /var/log/messages in /etc/syslog.conf:"
      cat /etc/syslog.conf | grep -v "^#" | grep "\*.info" | grep "authpriv.none" | grep "/var/log/messages" >> $LOGFILE
      echo ""
   fi
   cat /etc/syslog.conf | grep -v "^#" | grep "authpriv.\*" | grep "/var/log/secure" > /dev/null 2>&1
   if (($?)); then
      echo "CNL.1.2.1.1 : WARNING - The 'authpriv.*' is not configured for /var/log/secure in /etc/syslog.conf!"
   else
      echo "CNL.1.2.1.1 : The 'authpriv.*' is configured for /var/log/secure in /etc/syslog.conf:"
      cat /etc/syslog.conf | grep -v "^#" | grep "authpriv.\*" | grep "/var/log/secure" >> $LOGFILE
   fi
else
   if [ $OSFlavor = "RedHat" ] && [ $RHVER -ge 6 ]; then
      if ((!$?)); then
         echo "CNL.1.2.1.1 : The /etc/syslog.conf file does not exist."
         echo "CNL.1.2.1.1 : This is a RHEL $SVER server. It should use /etc/rsyslog.conf instead."
      else
         echo "CNL.1.2.1.1 : WARNING - The /etc/syslog.conf file does not exist."
      fi
   fi
fi

echo ""
if [ -f /etc/syslog-ng/syslog-ng.conf ]; then
   cat /etc/syslog-ng/syslog-ng.conf | grep -v "^#" | grep "^filter f_authpriv" | grep "facility" | grep "\(auth,authpriv\)" > /dev/null 2>&1
   if (($?)); then
      echo "CNL.1.2.1.2 : WARNING - The /etc/syslog-ng/syslog-ng.conf file does not contain the 'filter f_authpriv { facility(authpriv); };' paramter!"
   else
      echo "CNL.1.2.1.2 : The /etc/syslog-ng/syslog-ng.conf file does contain the 'filter f_authpriv { facility(authpriv); };' paramter!"
      cat /etc/syslog-ng/syslog-ng.conf | grep -v "^#" | grep "^filter f_authpriv" | grep "facility" | grep "authpriv" >> $LOGFILE
   fi
   cat /etc/syslog-ng/syslog-ng.conf | grep -v "^#" | grep "^destination authpriv" | grep "file" | grep "/var/log/secure" > /dev/null 2>&1
   if (($?)); then
      echo "CNL.1.2.1.2 : WARNING - The /etc/syslog-ng/syslog-ng.conf file does not contain the 'destination authpriv { file(/var/log/secure); };' parameter!"
   else
      echo "CNL.1.2.1.2 : The /etc/syslog-ng/syslog-ng.conf file does not contain the 'destination authpriv { file(/var/log/secure); };' parameter."
      cat /etc/syslog-ng/syslog-ng.conf | grep -v "^#" | grep "^destination authpriv" | grep "file" | grep "/var/log/secure" >> $LOGFILE
   fi
#   cat /etc/syslog-ng/syslog-ng.conf | grep -v "^#" | grep "^source src" | grep "internal" > /dev/null 2>&1
#   if (($?)); then
#      echo "CNL.1.2.1.2 : WARNING - The /etc/syslog-ng/syslog-ng.conf file does not contain the 'source src { internal(); };' parameter!"
#   else
#      echo "CNL.1.2.1.2 : The /etc/syslog-ng/syslog-ng.conf file does contain the 'source src { internal(); };' parameter!"
#      cat /etc/syslog-ng/syslog-ng.conf | grep -v "^#" | grep "^source src" | grep "internal" >> $LOGFILE
#   fi
   cat /etc/syslog-ng/syslog-ng.conf | grep -v "^#" | grep "^log" | grep "source" | grep "src" | grep "filter" | grep "f_authpriv" | grep "destination" | grep "authpriv" > /dev/null 2>&1
   if (($?)); then
      echo "CNL.1.2.1.2 : WARNING - The /etc/syslog-ng/syslog-ng.conf file does not contain the 'log { source(src); filter(f_authpriv); destination(authpriv); };'!"
   else
      echo "CNL.1.2.1.2 : The /etc/syslog-ng/syslog-ng.conf file does contain the 'log { source(src); filter(f_authpriv); destination(authpriv); };'."
      cat /etc/syslog-ng/syslog-ng.conf | grep -v "^#" | grep "^log" | grep "source" | grep "src" | grep "filter" | grep "f_authpriv" | grep "destination" | grep "authpriv" >> $LOGFILE
   fi
else
   echo "CNL.1.2.1.2 : N/A - This system does not use syslog-ng"
fi

echo ""
if [ -f /etc/rsyslog.conf ]; then
   if [[ $OSFlavor = "RedHat" ]] && [[ $RHVER -le 4 ]] || [[ $OSFlavor = "SuSE" ]] && [[ $SVER -le 10 ]]; then
      cat /etc/rsyslog.conf | grep -v "^#" | grep "^filter f_authpriv" | grep "facility" | grep "authpriv" > /dev/null 2>&1
      if (($?)); then
         echo "CNL.1.2.1.3 : WARNING - The /etc/rsyslog.conf file does not contain the 'filter f_authpriv { facility(authpriv); };' paramter!"
      else
         echo "CNL.1.2.1.3 : The /etc/rsyslog.conf file does contain the 'filter f_authpriv { facility(authpriv); };' paramter!"
         cat /etc/rsyslog.conf | grep -v "^#" | grep "^filter f_authpriv" | grep "facility" | grep "authpriv" >> $LOGFILE
      fi
      cat /etc/rsyslog.conf | grep -v "^#" | grep "^destination authpriv" | grep "file" | grep "/var/log/secure" | grep "RSYSLOG_TraditionalFileFormat" > /dev/null 2>&1
      if (($?)); then
         echo "CNL.1.2.1.3 : WARNING - The /etc/rsyslog.conf file does not contain the 'destination authpriv { file(\"/var/log/secure;RSYSLOG_TraditionalFileFormat\"); };' parameter!"
      else
         echo "CNL.1.2.1.3 : The /etc/rsyslog.conf file does not contain the 'destination authpriv { file(\"/var/log/secure;RSYSLOG_TraditionalFileFormat\"); };' parameter."
         cat /etc/rsyslog.conf | grep -v "^#" | grep "^destination authpriv" | grep "file" | grep "/var/log/secure" | grep "RSYSLOG_TraditionalFileFormat" >> $LOGFILE
      fi
      cat /etc/rsyslog.conf | grep -v "^#" | grep "^source src" | grep "internal" > /dev/null 2>&1
      if (($?)); then
         echo "CNL.1.2.1.3 : WARNING - The /etc/rsyslog.conf file does not contain the 'source src { internal(); };' parameter!"
      else
         echo "CNL.1.2.1.3 : The /etc/rsyslog.conf file does contain the 'source src { internal(); };' parameter!"
         cat /etc/rsyslog.conf | grep -v "^#" | grep "^source src" | grep "internal" >> $LOGFILE
      fi
      cat /etc/rsyslog.conf | grep -v "^#" | grep "^log" | grep "source" | grep "src" | grep "filter" | grep "f_authpriv" | grep "destination" | grep "authpriv" > /dev/null 2>&1
      if (($?)); then
         echo "CNL.1.2.1.3 : WARNING - The /etc/rsyslog.conf file does not contain the 'log { source(src); filter(f_authpriv); destination(authpriv); };'!"
      else
         echo "CNL.1.2.1.3 : The /etc/rsyslog.conf file does contain the 'log { source(src); filter(f_authpriv); destination(authpriv); };'."
         cat /etc/rsyslog.conf | grep -v "^#" | grep "^log" | grep "source" | grep "src" | grep "filter" | grep "f_authpriv" | grep "destination" | grep "authpriv" >> $LOGFILE
      fi
   else
      echo "CNL.1.2.1.3 : N/A - This is not a RHEL 4 or lower OR SuSE 10 or lower system"
   fi
else
   echo "CNL.1.2.1.3 : N/A - This system does not use rsyslog"
fi

echo ""
if [ -f /etc/rsyslog.conf ]; then
   if [[ $OSFlavor = "RedHat" ]] && [[ $RHVER -ge 5 ]] || [[ $OSFlavor = "SuSE" ]] && [[ $SVER -eq 11 ]]; then
      cat /etc/rsyslog.conf | grep -v "^#" | grep "ActionFileDefaultTemplate RSYSLOG_TraditionalFileFormat" > /dev/null 2>&1
      if ((!$?)); then
         cat /etc/rsyslog.conf | grep -v "^#" | grep "\*.info" | grep "mail.none" | grep "authpriv.none" | grep "/var/log/messages" > /dev/null 2>&1
         if (($?)); then 
            echo "CNL.1.2.1.4 : WARNING - The /etc/rsyslog.conf file does not contain the '*.info;mail.none;authpriv.none;cron.none /var/log/messages' paramter!"
         else
            echo "CNL.1.2.1.4 : The /etc/rsyslog.conf file does contain the '*.info;mail.none;authpriv.none;cron.none /var/log/messages' parameter."
            cat /etc/rsyslog.conf | grep -v "^#" | grep "ActionFileDefaultTemplate RSYSLOG_TraditionalFileFormat" >> $LOGFILE
            cat /etc/rsyslog.conf | grep -v "^#" | grep "\*.info" | grep "mail.none" | grep "authpriv.none" | grep "cron.none" | grep "/var/log/messages" >> $LOGFILE
         fi
         cat /etc/rsyslog.conf | grep -v "^#" | grep "^authpriv.\*" | grep "/var/log/secure" > /dev/null 2>&1
         if (($?)); then
            echo "CNL.1.2.1.4 : WARNING - The /etc/rsyslog.conf file does not contain the 'authpriv.* /var/log/secure' parameter!"
         else
            echo "CNL.1.2.1.4 : The /etc/rsyslog.conf file does contain the 'authpriv.* /var/log/secure' paramter."
            cat /etc/rsyslog.conf | grep -v "^#" | grep "ActionFileDefaultTemplate RSYSLOG_TraditionalFileFormat" >> $LOGFILE
            cat /etc/rsyslog.conf | grep -v "^#" | grep "^authpriv.\*" | grep "/var/log/secure" >> $LOGFILE
         fi
      else
         cat /etc/rsyslog.conf | grep -v "^#" | grep "\*.info" | grep "mail.none" | grep "authpriv.none" | grep "/var/log/messages" | grep "RSYSLOG_TraditionalFileFormat" > dev/null 2>&1
         if (($?)); then
            echo "CNL.1.2.1.4 : WARNING - The /etc/rsyslog.conf file does not contain the '*.info;mail.none;authpriv.none /var/log/messages;RSYSLOG_TraditionalFileFormat' paramter!"
         else
            echo "CNL.1.2.1.4 : The /etc/rsyslog.conf file does contain the '*.info;mail.none;authpriv.none;cron.none /var/log/messages;RSYSLOG_TraditionalFileFormat' paramter."
            cat /etc/rsyslog.conf | grep -v "^#" | grep "\*.info" | grep "mail.none" | grep "authpriv.none" | grep "/var/log/messages" | grep "RSYSLOG_TraditionalFileFormat" >> $LOGFILE
         fi
         cat /etc/rsyslog.conf | grep -v "^#" | grep "^authpriv.\*" | grep "/var/log/secure" | grep "RSYSLOG_TraditionalFileFormat" > /dev/null 2>&1
         if (($?)); then
            echo "CNL.1.2.1.4 : WARNING - The /etc/rsyslog.conf file does not contain the 'authpriv.* /var/log/secure;RSYSLOG_TraditionalFileFormat' parameter!"
         else
            echo "CNL.1.2.1.4 : The /etc/rsyslog.conf file does contain the 'authpriv.* /var/log/secure;RSYSLOG_TraditionalFileFormat' parameter."
            cat /etc/rsyslog.conf | grep -v "^#" | grep "^authpriv.\*" | grep "/var/log/secure" | grep "RSYSLOG_TraditionalFileFormat" >> $LOGFILE
         fi
      fi 
   else
      echo "CNL.1.2.1.4 : N/A - This is not a RHEL 5 or higher OR SuSE 11 system"
   fi
else
   echo "CNL.1.2.1.4 : N/A - This system does not use rsyslog"
fi

echo ""
if [[ $OSFlavor != "RedHat" ]] && [[ $OSFlavor != "SuSE" ]]; then
   echo "CNL.1.2.1.5 : WARNING - This is not a supported OS. Checking this section is being skipped!!!"
else
   echo "CNL.1.2.1.5 : N/A - This is a $OSFlavor OS"
fi

echo ""
if [ ! -f /var/log/wtmp ]; then
   echo "CNL.1.2.2 : WARNING - The /var/log/wtmp file does NOT exist!"
else
   echo "CNL.1.2.2 : The /var/log/wtmp file exists:"
   ls -al /var/log/wtmp >> $LOGFILE
fi

echo ""
if [ ! -f /var/log/messages ]; then
   echo "CNL.1.2.3.1 : WARNING - The /var/log/messages file does NOT exist!"
else
   echo "CNL.1.2.3.1 : The /var/log/messages file exists:"
   ls -al /var/log/messages >> $LOGFILE
fi

echo ""
if [[ $OSFlavor != "RedHat" ]] && [[ $OSFlavor != "SuSE" ]]; then
   if [ ! -f /var/log/syslog ]; then
      echo "CNL.1.2.3.2 : WARNING - The /var/log/syslog file does NOT exist!"
   else
      echo "CNL.1.2.3.2 : The /var/log/syslog file exists:"
      ls -al /var/log/syslog >> $LOGFILE
   fi
else
   echo "CNL.1.2.3.2 : N/A - This is a $OSFlavor OS"
fi

echo ""
if [ $OSFlavor = "RedHat" ]; then
   cat /etc/pam.d/system-auth-ac | grep -q pam_tally.so
   if ((!$?)); then
      if [ ! -f /var/log/faillog ]; then
         echo "CNL.1.2.4.1 : WARNING - System is using pam_tally.so and the /var/log/faillog file does NOT exist!"
      else
         echo "CNL.1.2.4.1 : The /var/log/faillog file exists:"
         ls -al /var/log/faillog >> $LOGFILE
      fi
   else
      cat /etc/pam.d/system-auth-ac | grep -q pam_tally2.so
      if ((!$?)); then
         echo "CNL.1.2.4.1 : N/A - System is using pam_tally2.so."
      else
         if [ ! -f /var/log/faillog ]; then
            echo "CNL.1.2.4.1 : WARNING - System is not using pam_tally2.so and the /var/log/faillog file does NOT exist!"
         else
            echo "CNL.1.2.4.1 : The /var/log/faillog file exists:"
            ls -al /var/log/faillog >> $LOGFILE
         fi
      fi
   fi
else
   grep -q pam_tally.so /etc/pam.d/*
   if ((!$?)); then
      if [ ! -f /var/log/faillog ]; then
         echo "CNL.1.2.4.1 : WARNING - System is using pam_tally.so and the /var/log/faillog file does NOT exist!"
      else
         echo "CNL.1.2.4.1 : The /var/log/faillog file exists:"
         ls -al /var/log/faillog >> $LOGFILE
      fi
   else
      grep -q pam_tally2.so /etc/pam.d/*
      if ((!$?)); then
         echo "CNL.1.2.4.1 : N/A - System is using pam_tally2.so."
      else
         if [ ! -f /var/log/faillog ]; then
            echo "CNL.1.2.4.1 : WARNING - System is not using pam_tally2.so and the /var/log/faillog file does NOT exist!"
         else
            echo "CNL.1.2.4.1 : The /var/log/faillog file exists:"
            ls -al /var/log/faillog >> $LOGFILE
         fi
      fi
   fi
fi

echo ""
if [ $OSFlavor = "RedHat" ]; then
   cat /etc/pam.d/system-auth-ac | grep -q pam_tally2.so
   if ((!$?)); then
      if [ ! -f /var/log/tallylog ]; then
         echo "CNL.1.2.4.2 : WARNING - System is using pam_tally2.so and the /var/log/tallylog file does NOT exist!"
      else
         echo "CNL.1.2.4.2 : The /var/log/tallylog file exists:"
         ls -al /var/log/tallylog >> $LOGFILE
      fi
   else
      cat /etc/pam.d/system-auth-ac | grep -q pam_tally.so
      if ((!$?)); then
         echo "CNL.1.2.4.2 : N/A - System is using pam_tally.so."
      else
         echo "CNL.1.2.4.2 : WARNING - System does NOT have pam_tally.so NOR pam_tally2.so configured!"
      fi
   fi
else
   grep -q pam_tally2.so /etc/pam.d/*
   if ((!$?)); then
      if [ ! -f /var/log/tallylog ]; then
         echo "CNL.1.2.4.2 : WARNING - System is using pam_tally2.so and the /var/log/tallylog file does NOT exist!"
      else
         echo "CNL.1.2.4.2 : The /var/log/tallylog file exists:"
         ls -al /var/log/tallylog >> $LOGFILE
      fi
   else
      grep -q pam_tally.so /etc/pam.d/*
      if ((!$?)); then
         echo "CNL.1.2.4.2 : N/A - System is using pam_tally.so."
      else
         echo "CNL.1.2.4.2 : WARNING - System does NOT have pam_tally.so NOR pam_tally2.so configured!"
      fi
   fi
fi

echo ""
if [ -f /var/log/secure ]; then
   echo "CNL.1.2.5 : The /var/log/secure file exists:"
   ls -al /var/log/secure >> $LOGFILE
elif [ -f /var/log/auth.log ]; then
   echo "CNL.1.2.5 : The /var/log/auth.log file exists:"
   ls -al /var/log/auth.log >> $LOGFILE
else
   echo "CNL.1.2.5 : WARNING - Neither the /var/log/secure nor the /var/log/auth.log files exist!"
fi

echo ""
ShowLogList=1
NinetyDayLogRotate=1
if [ -f /etc/cron.daily/logrotate ]; then
   if [ -f /etc/logrotate.conf ]; then
      grep "^rotate" /etc/logrotate.conf > /dev/null 2>&1
      if ((!$?)); then
         RotateDays=`grep "^rotate" /etc/logrotate.conf | awk '{print $2}' | head -1`
         if [ $RotateDays -lt 13 ]; then
            echo "CNL.1.2.6 : WARNING - The system is NOT keeping 90 days worth of log files. It is only keeping $RotateDays week(s) of log files."
         else
            NinetyDayLogRotate=0
            if [ -f /etc/logrotate.d/syslog ]; then
               LogsToRotate=`egrep -c '/var/log/cron|/var/log/maillog|/var/log/messages|/var/log/secure' /etc/logrotate.d/syslog`
               if [ $LogsToRotate -lt 4 ]; then
                  echo "CNL.1.2.6 : WARNING - No all system logs appear to be configured for rotation."
                  echo "CNL.1.2.6 : Any logs configured are listed below:"
                  grep '/var/log/cron|/var/log/maillog|/var/log/messages|/var/log/secure' /etc/logrotate.d/syslog >> $LOGFILE
               else
                  echo "CNL.1.2.6 : The system is keeping at least 90 days worth of log files."
                  grep "^rotate" /etc/logrotate.conf | head -1 >> $LOGFILE
               fi
            else
               echo "CNL.1.2.6 : WARNING - No system logs appear to be configured for rotation, although the server is configured for 90 days of retention."
            fi
         fi
      else
         echo "CNL.1.2.6 : WARNING - The rotate paramter is not set in /etc/logrotate.conf!"
         ShowLogList=0
      fi
   else
      echo "CNL.1.2.6 : WARNING - The /etc/logrotate.conf file does not exist!"
      ShowLogList=0
   fi
else
   echo "CNL.1.2.6 : WARNING - The /etc/cron.daily/logrotate file does not exist!"
   ShowLogList=0
fi
if ((!$ShowLogList)); then
   echo "CNL.1.2.6 : Here is a long listing of the system log files. Ensure there are at least 90 days worth:"
   for file in messages secure wtmp faillog
   do
   ls -al /var/log/$file | awk '{print $9,"==== "$6,$7,$8}' >> $LOGFILE
   done
fi

rm -rf $LOGFILE
