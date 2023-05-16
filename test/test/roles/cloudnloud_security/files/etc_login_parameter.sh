LOGFILE=/tmp/umask.txt
if [ -f /etc/login.defs ]; then
   COUNT=`cat /etc/login.defs | grep -v "^#" | grep -ic umask`
   if [ $COUNT -le 1 ]; then
      cat /etc/login.defs | grep -v "^#" | grep -i umask > /dev/null 2>&1
      if (($?)); then
         echo "CNL.1.9.1.2.1 : WARNING - The umask paramter does not appear in the /etc/login.defs file."
      else
         cat /etc/login.defs | grep -v "^#" | grep -i umask | grep 077 > /dev/null 2>&1
         if (($?)); then
            echo "CNL.1.9.1.2.1 : WARNING - The parameter umask 077 appears to be set incorrectly in the /etc/login.defs file:"
         else
            echo "CNL.1.9.1.2.1 : The parameter umask 077 appears to be set correctly in the /etc/login.defs file:"
         fi
        cat /etc/login.defs | grep -v "^#" | grep -i umask >> $LOGFILE
      fi
   else
      echo "CNL.1.9.1.2.1 : WARNING - The umask parameter has more than one entry in the /etc/login.defs file. Verify they are correct manually:"
      cat /etc/login.defs | grep -v "^#" | grep -i umask >> $LOGFILE
   fi
else
   echo "CNL.1.9.1.2.1 : WARNING - The /etc/login.defs file does not exist!"
fi
rm -rf $LOGFILE

