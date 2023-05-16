if [ -d /var/spool/cron/tabs ]; then
   if [ `ls /var/spool/cron/tabs | wc -l` -gt 0 ]; then
      cat /dev/null > OSRCronResult #clean our results file to start fresh if any problems found
      for file in `ls /var/spool/cron/tabs`
      do
      cat /var/spool/cron/tabs/$file | grep -v "^#" > OSRCronClean #gives ACTIVE cron entries
      cat OSRCronClean | awk '{print substr($0, index($0,$6)) }' | cut -d'>' -f1 | awk -F"/" '{print substr($0, index($0,$1)) }' | awk '{print $1}' > OSRCronToCheck #gives the potential scripts/commands to check
      X=1 #First line to start checking
         for line in `cat OSRCronToCheck`
         do
         echo $line | grep "/" > /dev/null 2>&1
         if (($?)); then
            echo "The file being checked was: /var/spool/cron/tabs/$file" >> OSRCronResult
            echo "The line being checked was:" >> OSRCronResult
            cat OSRCronClean | awk -v XX=$X 'NR==XX' >> OSRCronResult
            echo "The script attempted to check: $line" >> OSRCronResult
            echo "" >> OSRCronResult
         fi
         ((X+=1))
         done
      done
      if [ -s OSRCronResult ]; then
         echo "CNL.1.8.21.1 : WARNING - At least one active entry was found in /var/spool/cron/tabs that"
         echo "does not appear to specify the full path!"
         echo "Please review the results below and check for any false positives:"
         cat OSRCronResult >> $LOGFILE
         echo ""
         echo "!!! WARNING - THE ABOVE ENTRIES WILL NOT BE CHECKED IN THE NEXT TWO SECTIONS !!!"
         echo ""
      else
         echo "CNL.1.8.21.1 : All active entry in /var/spool/cron/tabs specify the full path of the file/command/script to be executed."
      fi
   
   
      echo ""
      cat /dev/null > OSRCronResult #clean our results file to start fresh if any problems found
      for file in `ls /var/spool/cron/tabs`
      do
      cat /var/spool/cron/tabs/$file | grep -v "^#" > OSRCronClean #gives ACTIVE cron entries
      cat OSRCronClean | awk '{print substr($0, index($0,$6)) }' | cut -d'>' -f1 | awk -F"/" '{print substr($0, index($0,$1)) }' | awk '{print $1}' > OSRCronToCheck #gives the potential scripts/commands to check
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
                  echo "The file being checked was: /var/spool/cron/tabs/$file" >> OSRCronResult
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
      done
      if [ -s OSRCronResult ]; then
         echo "CNL.1.8.21.2 : WARNING - An entry in /var/spool/cron/tabs has an incorrect setting for other:"
         cat OSRCronResult >> $LOGFILE
      else
         echo "CNL.1.8.21.2 : All active & valid entries in /var/spool/cron/tabs have correct settings for other."
      fi
   
   
      echo ""
      cat /dev/null > OSRCronResult #clean our results file to start fresh if any problems found
      for file in `ls /var/spool/cron/tabs`
      do
      cat /var/spool/cron/tabs/$file | grep -v "^#" > OSRCronClean #gives ACTIVE cron entries
      cat OSRCronClean | awk '{print substr($0, index($0,$6)) }' | cut -d'>' -f1 | awk -F"/" '{print substr($0, index($0,$1)) }' | awk '{print $1}' > OSRCronToCheck #gives the potential scripts/commands to check
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
                  echo "The file being checked was: /var/spool/cron/tabs/$file" >> OSRCronResult
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
                     echo "The file being checked was: /var/spool/cron/tabs/$file" >> OSRCronResult
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
      done
      if [ -s OSRCronResult ]; then
         echo "CNL.1.8.21.3 : WARNING - An entry in /var/spool/cron/tabs has an incorrect setting and/or owner for group:"
         cat OSRCronResult >> $LOGFILE
      else
         echo "CNL.1.8.21.3 : All active entries in /var/spool/cron/tabs have correct settings and/or owner for group."
      fi
   else
      echo "CNL.1.8.21.1 : N/A - No active entries exist in /var/spool/cron/tabs"
      echo ""
      echo "CNL.1.8.21.2 : N/A - No active entries exist in /var/spool/cron/tabs"
      echo ""
      echo "CNL.1.8.21.3 : N/A - No active entries exist in /var/spool/cron/tabs"
   fi
else
   echo "CNL.1.8.21.1 : N/A - The /var/spool/cron/tabs directory does not exist."
   echo ""
   echo "CNL.1.8.21.2 : N/A - The /var/spool/cron/tabs directory does not exist."
   echo ""
   echo "CNL.1.8.21.3 : N/A - The /var/spool/cron/tabs directory does not exist."
fi

#Clean up our mess:
rm -rf OSRCronClean OSRCronResult OSRCronToCheck $LOGFILE

