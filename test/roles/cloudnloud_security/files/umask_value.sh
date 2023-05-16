OSFlavor=RedHat
LOGFILE=/tmp/umask.txt
if [ "$OSFlavor" = "RedHat" ]; then
   if [[ -z `grep -i umask /etc/bashrc` ]]; then
      echo "CNL.1.9.1.2 : WARNING - System Default UMASK not defined in /etc/bashrc!"
   else
      grep -i "umask" /etc/bashrc | grep -q [0-9]77
      if (($?)); then
         echo "CNL.1.9.1.2 : WARNING - System Default UMASK is set incorrectly in /etc/bashrc:"
         grep -i "umask" /etc/bashrc >> $LOGFILE
      else
         echo "CNL.1.9.1.2 : System Default UMASK is set in /etc/bashrc:"
         grep -i "umask" /etc/bashrc | grep [0-9]77 >> $LOGFILE
      fi
   fi
   else
      echo "CNL.1.9.1.2 : WARNING - The /etc/profile.local file does not exist!"
   fi
rm -rf $LOGFILE

