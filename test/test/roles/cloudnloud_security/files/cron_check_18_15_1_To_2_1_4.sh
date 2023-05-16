#Examining the /etc/crontab file is very complex given the huge number of ways
#the script/command can be configured in crontab (i.e. run-parts, /usr/bin/su <command>, etc, etc).
#I will do my best to take it in steps and parse out what I can. The user may
#have to manually examine some entries, depending on the results, and I 
#will do do my best to aid in the manual checks if they are necessary.
LOGFILE=/tmp/jino.txt
OSFlavor=RedHat
echo ""
CrontabExists=0
CRON=/etc/crontab

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


if [ -f $CRON ]; then
   if [ $OSFlavor = "SuSE" ] && [ $SVER -ge 11 ]; then
      cat $CRON | LANG=en_US.UTF-8 egrep -v '^#|^[a-Z]' | grep -wv "run-parts" > OSRCronPartlyClean #gives ACTIVE cron entries
      grep '.' OSRCronPartlyClean > OSRCronClean #remove any blank lines
      rm -rf OSRCronPartlyClean
      cat $CRON | LANG=en_US.UTF-8 egrep -v '^#|^[a-Z]' | grep "run-parts" > OSRCronPartlyClean.run-parts #gives ACTIVE directories
      grep '.' OSRCronPartlyClean.run-parts > OSRCronClean.run-parts #remove any blank lines
      rm -rf OSRCronPartlyClean.run-parts
   else
      cat $CRON | egrep -v '^#|^[a-Z]' | grep -wv "run-parts" > OSRCronPartlyClean #gives ACTIVE cron entries
      grep '.' OSRCronPartlyClean > OSRCronClean #remove any blank lines
      rm -rf OSRCronPartlyClean
      cat $CRON | egrep -v '^#|^[a-Z]' | grep "run-parts" > OSRCronPartlyClean.run-parts #gives ACTIVE directories
      grep '.' OSRCronPartlyClean.run-parts > OSRCronClean.run-parts #remove any blank lines
      rm -rf OSRCronPartlyClean.run-parts
   fi
   cat OSRCronClean.run-parts | awk '{print substr($0, index($0,$8)) }' | cut -d'>' -f1 | awk -F"/" '{print substr($0, index($0,$1)) }' | awk '{print $1}' > OSRCronToCheck.run-parts #gives the potential directories to check
   cat OSRCronClean | grep -v "run-parts" | awk '{print substr($0, index($0,$6)) }' | cut -d'>' -f1 | awk -F"/" '{print substr($0, index($0,$1)) }' | awk '{print $1}' > OSRCronToCheck #gives the potential scripts/commands to check
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
   X=1 #First line to start checking
   for line in `cat OSRCronToCheck.run-parts`
   do
   echo $line | grep "/" > /dev/null 2>&1
   if (($?)); then
      echo "The line being checked was:" >> OSRCronResult
      cat OSRCronClean.run-parts | awk -v XX=$X 'NR==XX' >> OSRCronResult
      echo "The script attempted to check: $line" >> OSRCronResult
      echo "" >> OSRCronResult
   fi
   ((X+=1))
   done
   if [ -s OSRCronResult ]; then
      echo "CNL.1.8.15.1 : WARNING - At least one active entry was found in /etc/crontab that"
      echo "does not appear to specify the full path!"
      echo "Please review the results below and check for any false positives:"
      cat OSRCronResult >> $LOGFILE
      echo ""
      echo "!!! WARNING - THE ABOVE ENTRIES WILL NOT BE CHECKED IN THE NEXT TWO SECTIONS !!!"
      echo ""
   else
      echo "CNL.1.8.15.1 : All active entry in /etc/crontab specify the full path of the file/command/script to be executed."
   fi
else
   echo "CNL.1.8.15.1 : N/A - There is no /etc/crontab file on this server."
   CrontabExists=1
fi

if ((!$CrontabExists)); then
   echo ""
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
   X=1 #First line to start checking
   for line in `cat OSRCronToCheck.run-parts`
   do
   if [ -d $line ]; then
      for script in `ls -al $line | grep "^-" | awk '{print $9}'`
      do
      FILEPerm=`ls -ald $line/$script | awk '{print $1}' | cut -c9`
      if [ $FILEPerm != "-" ]; then
         echo "The line being checked was:" >> OSRCronResult
         cat OSRCronClean.run-parts | awk -v XX=$X 'NR==XX' >> OSRCronResult
         echo "The script attempted to check: $line/$script" >> OSRCronResult
         ls -ald $line/$script >> OSRCronResult
         echo "" >> OSRCronResult
      fi
      done
   fi
   lineA=$line
   line=$line/place_holder
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
            cat OSRCronClean.run-parts | awk -v XX=$X 'NR==XX' >> OSRCronResult
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
      echo "CNL.1.8.15.2 : WARNING - An entry in /etc/crontab has an incorrect setting for other:"
      cat OSRCronResult >> $LOGFILE
   else
      echo "CNL.1.8.15.2 : All active & valid entries in /etc/crontab have correct settings for other."
   fi
else
   echo "CNL.1.8.15.2 : N/A - There is no /etc/crontab file on this server."
fi

if ((!$CrontabExists)); then
   echo ""
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
   X=1 #First line to start checking
   for line in `cat OSRCronToCheck.run-parts`
   do
   if [ -d $line ]; then
      for script in `ls -al $line | grep "^-" | awk '{print $9}'`
      do
      FILEPerm=`ls -ald $line/$script | awk '{print $1}' | cut -c9`
      GROUPname=`ls -ald $line/$script | awk '{print $4}'`
      if [ $FILEPerm != "-" ]; then
         grep -q "^$GROUPname:" /etc/group
         if ((!$?)); then
            GROUPid=`grep "^$GROUPname:" /etc/group | awk -F':' '{print $3}'`
         else
            GROUPid=999
         fi
         if [ $GROUPid -gt 99 ]; then
            echo "The line being checked was:" >> OSRCronResult
            cat OSRCronClean.run-parts | awk -v XX=$X 'NR==XX' >> OSRCronResult
            echo "The script attempted to check: $line/$script" >> OSRCronResult
            ls -ald $line/$script >> OSRCronResult
            echo "" >> OSRCronResult
         fi
      fi
      done
   fi
   lineA=$line
   line=$line/place_holder
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
               cat OSRCronClean.run-parts | awk -v XX=$X 'NR==XX' >> OSRCronResult
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
      echo "CNL.1.8.15.3 : WARNING - An entry in /etc/crontab has an incorrect setting and/or owner for group:"
      cat OSRCronResult >> $LOGFILE
   else
      echo "CNL.1.8.15.3 : All active entries in /etc/crontab have correct settings and/or owner for group."
   fi
else
   echo "CNL.1.8.15.3 : N/A - There is no /etc/crontab file on this server."
fi

#Clean up our mess:
rm -rf OSRCronClean OSRCronResult OSRCronToCheck OSRCronClean.run-parts OSRCronToCheck.run-parts
#=====================================================================================================================================+#
echo ""
if [ -f /etc/xinetd.conf ]; then
   cat /etc/xinetd.conf | grep -v "^#" | grep -w "server" | grep "=" > CNL18171_temp
   if [ -s CNL18171_temp ]; then
      X=1
      cat /dev/null > CNL18171a_temp
      for entry in `cat CNL18171_temp | awk -F'=' '{print $2}'`
      do
      echo $entry | grep -q "/"
      if (($?)); then
         echo "The line being checked was:" >> CNL18171a_temp
         cat CNL18171_temp | awk -v XX=$X 'NR==XX' >> CNL18171a_temp
         echo "The script attempted to check: $entry" >> CNL18171a_temp
         echo "" >> CNL18171a_temp
      fi
      ((X+=1))
      done
      if [ -s CNL18171a_temp ]; then
         echo "CNL.1.8.17.1 : WARNING - Some active entry(ies) exist in /etc/xinetd.conf that"
         echo "do not appear to contain the full path of what is being executed:"
         cat CNL18171a_temp >> $LOGFILE
      else
         echo "CNL.1.8.17.1 : All active entries in /etc/xinetd.conf contain the full path of what is being executed."
      fi
      X=1
      cat /dev/null > CNL18171a_temp
      for entry in `cat CNL18171_temp | awk -F'=' '{print $2}'`
      do
      if [ -e $entry ]; then
         FILEPerm=`ls -ald $entry | awk '{print $1}' | cut -c9`
         if [ $FILEPerm != "-" ]; then
            echo "The line being checked was:" >> CNL18171a_temp
            cat CNL18171_temp | awk -v XX=$X 'NR==XX' >> CNL18171a_temp
            echo "The script attempted to check: $entry" >> CNL18171a_temp
            ls -ald $entry >> CNL18171a_temp
            echo "" >> CNL18171a_temp
         fi
      fi
      entryA=$entry
      echo $line | grep "^/" > /dev/null 2>&1
      if ((!$?)); then
         until [ `basename $line` = "/" ]
         do
         entry=`dirname $entry`
         if [ ! -L $entry ] && [ -e $entry ]; then
            FILEPerm=`ls -ald $entry | awk '{print $1}' | cut -c9`
            if [ $FILEPerm != "-" ]; then
               echo "The path for $entryA has an incorrect setting" >> CNL18171a_temp
               echo "The line being checked was:" >> CNL18171a_temp
               cat CNL18171_temp | awk -v XX=$X 'NR==XX' >> CNL18171a_temp
               echo "The script attempted to check: $entry" >> CNL18171a_temp
               ls -ald $entry >> CNL18171a_temp
               echo "" >> CNL18171a_temp
            fi
         fi
         done
      fi
      ((X+=1))
      done
      if [ -s CNL18171a_temp ]; then
         echo "CNL.1.8.17.2 : WARNING - Some active entry(ies) exist in /etc/xinetd.conf that"
         echo "do not have settings for 'other' of r-x or more stringent:"
         cat CNL18171a_temp >> $LOGFILE
      else
         echo "CNL.1.8.17.2 : All active entries in /etc/xinetd.conf and all dirs in their path of settings for 'other' set to r-x or more stringent."
      fi
      echo ""
      X=1
      cat /dev/null > CNL18171a_temp
      for entry in `cat CNL18171_temp | awk -F'=' '{print $2}'`
      do
      if [ -e $entry ]; then
         FILEPerm=`ls -ald $entry | awk '{print $1}' | cut -c9`
         GROUPname=`ls -ald $entry | awk '{print $4}'`
         if [ $FILEPerm != "-" ]; then
            grep -q "^$GROUPname:" /etc/group
            if ((!$?)); then
               GROUPid=`grep "^$GROUPname:" /etc/group | awk -F':' '{print $3}'`
            else
               GROUPid=999
            fi
            if [ $GROUPid -gt 99 ]; then
               echo "The line being checked was:" >> CNL18171a_temp
               cat CNL18171_temp | awk -v XX=$X 'NR==XX' >> CNL18171a_temp
               echo "The script attempted to check: $entry" >> CNL18171a_temp
               ls -ald $entry >> CNL18171a_temp
               echo "" >> CNL18171a_temp
            fi
         fi
      fi
      entryA=$entry
      echo $entry | grep "^/" > /dev/null 2>&1
      if ((!$?)); then
         until [ `basename $entry` = "/" ]
         do
         entry=`dirname $entry`
         if [ ! -L $entry ] && [ -e $entry ]; then
            FILEPerm=`ls -ald $entry | awk '{print $1}' | cut -c6`
            GROUPname=`ls -ald $entry | awk '{print $4}'`
            if [ $FILEPerm != "-" ]; then
               grep -q "^$GROUPname:" /etc/group
               if ((!$?)); then
                  GROUPid=`grep "^$GROUPname:" /etc/group | awk -F':' '{print $3}'`
               else
                  GROUPid=999
               fi
               if [ $GROUPid -gt 99 ]; then
                  echo "The path for $entryA has an incorrect setting" >> CNL18171a_temp
                  echo "The line being checked was:" >> CNL18171a_temp
                  cat CNL18171_temp | awk -v XX=$X 'NR==XX' >> CNL18171a_temp
                  echo "The script attempted to check: $entry" >> CNL18171a_temp
                  ls -ald $entry >> CNL18171a_temp
                  echo "" >> CNL18171a_temp
               fi
            fi
         fi
         done
      fi
      ((X+=1))
      done
      if [ -s CNL18171a_temp ]; then
         echo "CNL.1.8.17.3 : WARNING - Some active entry(ies) exist in /etc/xinetd.conf that"
         echo "do not have settings for 'group' of r-x or more stringent and not owned by GID <= 99:"
         cat CNL18171a_temp >> $LOGFILE
      else
         echo "CNL.1.8.17.3 : All active entries in /etc/xinetd.conf and all dirs in their path of settings for 'group' set to r-x or more stringent or are owned by GID <= 99"
      fi
   else
      echo "CNL.1.8.17.1 : N/A - There are no active entries in /etc/xinetd.conf to be executed."
      echo ""
      echo "CNL.1.8.17.2 : N/A - There are no active entries in /etc/xinetd.conf to be executed."
      echo ""
      echo "CNL.1.8.17.3 : N/A - There are no active entries in /etc/xinetd.conf to be executed."
   fi
   rm -rf CNL18171a_temp CNL18171_temp
else
   echo "CNL.1.8.17.1 : N/A - The /etc/xinetd.conf file does not exist."
   echo ""
   echo "CNL.1.8.17.2 : N/A - The /etc/xinetd.conf file does not exist."
   echo ""
   echo "CNL.1.8.17.3 : N/A - The /etc/xinetd.conf file does not exist."
fi

echo ""
cat /dev/null > CNL18182_temp
for dir in rc0.d rc1.d rc2.d rc3.d rc4.d rc5.d rc6.d rcS.d
do
if [ -L /etc/$dir ]; then
   BASEDIR=/etc/`ls -al /etc/$dir | awk '{print $11}'`
elif [ -d /etc/$dir ]; then
   BASEDIR=/etc/$dir
elif [ -d /etc/init.d/$dir ]; then
   BASEDIR=/etc/init.d/$dir
elif [ -d /etc/rc.d/$dir ]; then
   BASEDIR=/etc/rc.d/$dir
else
   BASEDIR=X
fi
if [ $BASEDIR != "X" ]; then
   for file in `ls -al $BASEDIR | grep -v "^d" | awk '{print $9}'`
   do
   if [ -L $BASEDIR/$file ]; then
      if [ -e $BASEDIR/$file ]; then
         FileLink=`ls -al $BASEDIR/$file | grep -v "^d" | awk '{print $11}'`
         FILEPERM=`ls -alL $BASEDIR/$file | awk '{print $1}' | cut -c9`
      else
         echo "A broken link exists in $BASEDIR: " >> CNL18182_temp
         ls -ald $BASEDIR/$file >> CNL18182_temp
         FILEPERM="-"
      fi
   else
      FileLink="X"
      FILEPERM=`ls -al $BASEDIR/$file | awk '{print $1}' | cut -c9`
   fi
   if [ $FILEPERM != "-" ]; then
      if [ $FileLink = "X" ]; then
         echo "Directory=$BASEDIR : File=$file" >> CNL18182_temp
         ls -al $BASEDIR/$file >> CNL18182_temp
      else
         echo "Directory=$BASEDIR : File=$file : File linked to=$FileLink" >> CNL18182_temp
         ls -alL $BASEDIR/$file >> CNL18182_temp
      fi
      echo "" >> CNL18182_temp
   fi
   done
fi
done
if [ -s CNL18182_temp ]; then
   echo "CNL.1.8.18.2 : WARNING - Some file(s) exist which have incorrect permissions set for 'other':"
   cat CNL18182_temp >> $LOGFILE
else
   echo "CNL.1.8.18.2 : All files linked to and actual files have permissions set for 'other' to r-x or more stringent."
fi
rm -rf CNL18182_temp

echo ""
cat /dev/null > CNL18183_temp
for dir in rc0.d rc1.d rc2.d rc3.d rc4.d rc5.d rc6.d rcS.d
do
if [ -L /etc/$dir ]; then
   BASEDIR=/etc/`ls -al /etc/$dir | awk '{print $11}'`
elif [ -d /etc/$dir ]; then
   BASEDIR=/etc/$dir
elif [ -d /etc/init.d/$dir ]; then
   BASEDIR=/etc/init.d/$dir
elif [ -d /etc/rc.d/$dir ]; then
   BASEDIR=/etc/rc.d/$dir
else
   BASEDIR=X
fi
if [ $BASEDIR != "X" ]; then
   for file in `ls -al $BASEDIR | grep -v "^d" | awk '{print $9}'`
   do
   if [ -L $BASEDIR/$file ]; then
      if [ -e $BASEDIR/$file ]; then
         FileLink=`ls -al $BASEDIR/$file | grep -v "^d" | awk '{print $11}'`
         FILEPERM=`ls -alL $BASEDIR/$file | awk '{print $1}' | cut -c9`
         GROUPname=`ls -alL $BASEDIR/$file | awk '{print $4}'`
      else
         echo "A broken link exists in $BASEDIR: " >> CNL18183_temp
         ls -ald $BASEDIR/$file >> CNL18183_temp
         FILEPERM="-"
      fi
   else
      FileLink="X"
      FILEPERM=`ls -al $BASEDIR/$file | awk '{print $1}' | cut -c9`
      GROUPname=`ls -al $BASEDIR/$file | awk '{print $4}'`
   fi
   if [ $FILEPERM != "-" ]; then
      grep -q "^$GROUPname:" /etc/group
      if ((!$?)); then
         GROUPid=`grep "^$GROUPname:" /etc/group | awk -F':' '{print $3}'`
      else
         GROUPid=999
      fi
      if [ $GROUPid -gt 99 ]; then
         if [ $FileLink = "X" ]; then
            echo "Directory=$BASEDIR : File=$file" >> CNL18183_temp
            ls -al $BASEDIR/$file >> CNL18183_temp
         else
            echo "Directory=$BASEDIR : File=$file : File linked to=$FileLink" >> CNL18183_temp
            ls -alL $BASEDIR/$file >> CNL18183_temp
         fi
         echo "" >> CNL18183_temp
      fi
   fi
   done
fi
done
if [ -s CNL18183_temp ]; then
   echo "CNL.1.8.18.3 : WARNING - Some file(s) exist which have incorrect permissions set for 'group' and GID < 99:"
   cat CNL18183_temp >> $LOGFILE
else
   echo "CNL.1.8.18.3 : All files linked to and actual files have permissions set for 'group' to r-x or more stringent."
fi
rm -rf CNL18183_temp

echo ""
if [ -L /etc/init.d ]; then
   BASEDIR=/etc/`ls -al /etc/init.d | awk '{print $11}'`
elif [ -d /etc/init.d ]; then
   BASEDIR=/etc/init.d
else
   BASEDIR=X
fi
cat /dev/null > CNL18192_temp
if [ $BASEDIR != "X" ]; then
   for file in `ls -al $BASEDIR | grep -v "^d" | awk '{print $9}'`
   do
   if [ -L $BASEDIR/$file ]; then
      if [ -e $BASEDIR/$file ]; then
         FileLink=`ls -al $BASEDIR/$file | grep -v "^d" | awk '{print $11}'`
         FILEPERM=`ls -alL $BASEDIR/$file | awk '{print $1}' | cut -c9`
      else
         echo "A broken link exists in $BASEDIR: " >> CNL18192_temp
         ls -ald $BASEDIR/$file >> CNL18192_temp
         FILEPERM="-"
      fi
   else
      FileLink="X"
      FILEPERM=`ls -al $BASEDIR/$file | awk '{print $1}' | cut -c9`
   fi
   if [ $FILEPERM != "-" ]; then
      if [ $FileLink = "X" ]; then
         echo "Directory=$BASEDIR : File=$file" >> CNL18192_temp
         ls -al $BASEDIR/$file >> CNL18192_temp
      else
         echo "Directory=$BASEDIR : File=$file : File linked to=$FileLink" >> CNL18192_temp
         ls -alL $BASEDIR/$file >> CNL18192_temp
      fi
      echo "" >> CNL18192_temp
   fi
   done
fi
if [ -s CNL18192_temp ]; then
   echo "CNL.1.8.19.2 : WARNING - Some file(s) exist which have incorrect permissions set for 'other':"
   cat CNL18192_temp >> $LOGFILE
elif [ $BASEDIR = "X" ]; then
   echo "CNL.1.8.19.2 : N/A - Neither the /etc/init.d nor the /etc/rc.d/init.d directories exist."
else
   echo "CNL.1.8.19.2 : All files linked to and actual files have permissions set for 'other' to r-x or more stringent."
fi
rm -rf CNL18192_temp

echo ""
if [ -L /etc/init.d ]; then
   BASEDIR=/etc/`ls -al /etc/init.d | awk '{print $11}'`
elif [ -d /etc/init.d ]; then
   BASEDIR=/etc/init.d
else
   BASEDIR=X
fi
cat /dev/null > CNL18193_temp
if [ $BASEDIR != "X" ]; then
   for file in `ls -al $BASEDIR | grep -v "^d" | awk '{print $9}'`
   do
   if [ -L $BASEDIR/$file ]; then
      if [ -e $BASEDIR/$file ]; then
         FileLink=`ls -al $BASEDIR/$file | grep -v "^d" | awk '{print $11}'`
         FILEPERM=`ls -alL $BASEDIR/$file | awk '{print $1}' | cut -c9`
         GROUPname=`ls -alL $BASEDIR/$file | awk '{print $4}'`
      else
         echo "A broken link exists in $BASEDIR: " >> CNL18193_temp
         ls -ald $BASEDIR/$file >> CNL18193_temp
         FILEPERM="-"
      fi
   else
      FileLink="X"
      FILEPERM=`ls -al $BASEDIR/$file | awk '{print $1}' | cut -c9`
      GROUPname=`ls -al $BASEDIR/$file | awk '{print $4}'`
   fi
   if [ $FILEPERM != "-" ]; then
      grep -q "^$GROUPname:" /etc/group
      if ((!$?)); then
         GROUPid=`grep "^$GROUPname:" /etc/group | awk -F':' '{print $3}'`
      else
         GROUPid=999
      fi
      if [ $GROUPid -gt 99 ]; then
         if [ $FileLink = "X" ]; then
            echo "Directory=$BASEDIR : File=$file" >> CNL18193_temp
            ls -al $BASEDIR/$file >> CNL18193_temp
         else
            echo "Directory=$BASEDIR : File=$file : File linked to=$FileLink" >> CNL18193_temp
            ls -alL $BASEDIR/$file >> CNL18193_temp
         fi
         echo "" >> CNL18193_temp
      fi
   fi
   done
fi
if [ -s CNL18193_temp ]; then
   echo "CNL.1.8.19.3 : WARNING - Some file(s) exist which have incorrect permissions set for 'group' and GID < 99:"
   cat CNL18193_temp >> $LOGFILE
elif [ $BASEDIR = "X" ]; then
   echo "CNL.1.8.19.2 : N/A - Neither the /etc/init.d nor the /etc/rc.d/init.d directories exist."
else
   echo "CNL.1.8.19.3 : All files linked to and actual files have permissions set for 'group' to r-x or more stringent."
fi
rm -rf CNL18193_temp

echo ""
if [ -d /etc/cron.d ]; then
   if [ `ls /etc/cron.d | wc -l` -gt 0 ]; then
      cat /dev/null > OSRCronResult #clean our results file to start fresh if any problems found
      for file in `ls /etc/cron.d`
      do
      cat /etc/cron.d/$file | grep -v "^#" > OSRCronClean #gives ACTIVE cron entries
      cat OSRCronClean | awk '{print substr($0, index($0,$6)) }' | cut -d'>' -f1 | awk -F"/" '{print substr($0, index($0,$1)) }' | awk '{print $1}' > OSRCronToCheck #gives the potential scripts/commands to check
      X=1 #First line to start checking
         for line in `cat OSRCronToCheck`
         do
         echo $line | grep "/" > /dev/null 2>&1
         if (($?)); then
            echo "The file being checked was: /etc/cron.d/$file" >> OSRCronResult
            echo "The line being checked was:" >> OSRCronResult
            cat OSRCronClean | awk -v XX=$X 'NR==XX' >> OSRCronResult
            echo "The script attempted to check: $line" >> OSRCronResult
            echo "" >> OSRCronResult
         fi
         ((X+=1))
         done
      done
      if [ -s OSRCronResult ]; then
         echo "CNL.1.8.20.1 : WARNING - At least one active entry was found in /etc/cron.d that"
         echo "does not appear to specify the full path!"
         echo "Please review the results below and check for any false positives:"
         cat OSRCronResult >> $LOGFILE
         echo ""
         echo "!!! WARNING - THE ABOVE ENTRIES WILL NOT BE CHECKED IN THE NEXT TWO SECTIONS !!!"
         echo ""
      else
         echo "CNL.1.8.20.1 : All active entry in /etc/cron.d specify the full path of the file/command/script to be executed."
      fi
   
   
      echo ""
      cat /dev/null > OSRCronResult #clean our results file to start fresh if any problems found
      for file in `ls /etc/cron.d`
      do
      cat /etc/cron.d/$file | grep -v "^#" > OSRCronClean #gives ACTIVE cron entries
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
                  echo "The file being checked was: /etc/cron.d/$file" >> OSRCronResult
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
         echo "CNL.1.8.20.2 : WARNING - An entry in /etc/cron.d has an incorrect setting for other:"
         cat OSRCronResult >> $LOGFILE
      else
         echo "CNL.1.8.20.2 : All active & valid entries in /etc/cron.d have correct settings for other."
      fi
   
   
      echo ""
      cat /dev/null > OSRCronResult #clean our results file to start fresh if any problems found
      for file in `ls /etc/cron.d`
      do
      cat /etc/cron.d/$file | grep -v "^#" > OSRCronClean #gives ACTIVE cron entries
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
                  echo "The file being checked was: /etc/cron.d/$file" >> OSRCronResult
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
                     echo "The file being checked was: /etc/cron.d/$file" >> OSRCronResult
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
         echo "CNL.1.8.20.3 : WARNING - An entry in /etc/cron.d has an incorrect setting and/or owner for group:"
         cat OSRCronResult >> $LOGFILE
      else
         echo "CNL.1.8.20.3 : All active entries in /etc/cron.d have correct settings and/or owner for group."
      fi
   else
      echo "CNL.1.8.20.1 : N/A - No active entries exist in /etc/cron.d"
      echo ""
      echo "CNL.1.8.20.2 : N/A - No active entries exist in /etc/cron.d"
      echo ""
      echo "CNL.1.8.20.3 : N/A - No active entries exist in /etc/cron.d"
   fi
else
   echo "CNL.1.8.20.1 : N/A - The /etc/cron.d directory does not exist."
   echo ""
   echo "CNL.1.8.20.2 : N/A - The /etc/cron.d directory does not exist."
   echo ""
   echo "CNL.1.8.20.3 : N/A - The /etc/cron.d directory does not exist."
fi

#Clean up our mess:
rm -rf OSRCronClean OSRCronResult OSRCronToCheck

#The /var/spool/cron/tabs is only used by SuSe.
echo ""
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
rm -rf OSRCronClean OSRCronResult OSRCronToCheck


X=1
for dir in /opt /var /tmp
do
cat /dev/null > CNL1822_temp
find $dir -type f -perm -a=w -perm -a=x >> CNL1822_temp
sleep 2
echo ""
if [ -s CNL1822_temp ]; then
   echo "CNL.1.8.22.$X : WARNING - File(s) exist in $dir that have both other-write and any-execute permissions set!"
   for file in `cat CNL1822_temp`
   do
   ls -al $file | awk '{print $1,$9}' >> $LOGFILE
   done
#   cat CNL1822_temp >> $LOGFILE
else
   echo "CNL.1.8.22.$X : No files exist in $dir that have both other-write and any-execute permissions set."
fi
((X+=1))
done

#Clean up our mess:
rm -rf CNL1822_temp

echo ""
echo "CNL.1.9.1.1 : The default setting in RedHat Linux is to create new user home directories with permissions 0700 and cannot be modified."

echo ""
if [ $OSFlavor = "RedHat" ]; then
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
elif [ $OSFlavor = "SuSE" ]; then
   if [ -f /etc/profile.local ]; then
      if [[ -z `grep -i umask /etc/profile.local` ]]; then
         echo "CNL.1.9.1.2 : WARNING - System Default UMASK not defined in /etc/profile.local!"
      else
         grep -i "umask" /etc/profile.local | grep -q [0-9]77
         if (($?)); then
            echo "CNL.1.9.1.2 : WARNING - System Default UMASK is set incorrectly in /etc/profile.local:"
            grep -i "umask" /etc/profile.local >> $LOGFILE
         else
            echo "CNL.1.9.1.2 : System Default UMASK is set in /etc/profile.local:"
            grep -i "umask" /etc/profile.local | grep [0-9]77 >> $LOGFILE
         fi
      fi
   else
      echo "CNL.1.9.1.2 : WARNING - The /etc/profile.local file does not exist!"
   fi
##Removed as this now appear in new section CNL.1.9.1.2.1 below
#   if [ -f /etc/login.defs ]; then
#      if [[ -z `grep ^UMASK /etc/login.defs` ]]; then
#         echo "CNL.1.9.1.2 : WARNING - System Default UMASK not defined in #/etc/login.defs!"
#      else
#         grep "^UMASK" /etc/login.defs | grep -q [0-9]77
#         if (($?)); then
#            echo "CNL.1.9.1.2 : WARNING - System Default UMASK is set #incorrectly in /etc/login.defs:"
#            grep "^UMASK" /etc/login.defs >> $LOGFILE
#         else
#            echo "CNL.1.9.1.2 : System Default UMASK is set in #/etc/login.defs:"
#           grep "^UMASK" /etc/login.defs | grep [0-9]77 >> $LOGFILE
#        fi
#      fi
#   fi
else
   echo ""
   echo "CNL.1.9.1.2 : N/A - This is a $OSFLavor server."
fi

echo ""
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

echo ""
cat /dev/null > CNL1913_temp
if [ -f /etc/profile.d/IBMsinit.sh ]; then
   grep "\$UID \-gt 199" /etc/profile.d/IBMsinit.sh | grep "if" | grep -v "^#" > /dev/null 2>&1
   if (($?)); then
      echo "CNL.1.9.1.3 : WARNING - The required if statement does not exist in the /etc/profile.d/IBMsinit.sh file."
   else
      grep -A 2 "\$UID \-gt 199" /etc/profile.d/IBMsinit.sh | grep -A 2 "if" | grep -vA 2 "^#" >> CNL1913_temp
      COUNT=`egrep -c "\$UID \-gt 199|umask 077|fi" CNL1913_temp`
      if [ $COUNT -eq 3 ]; then
         echo "CNL.1.9.1.3 : The /etc/profile.d/IBMsinit.sh file appears to contain the required if statement:"
      else
         echo "CNL.1.9.1.3 : WARNING - The /etc/profile.d/IBMsinit.sh file does not appear to contain the required if statement:"
      fi
      cat CNL1913_temp >> $LOGFILE
   fi
else
   echo "CNL.1.9.1.3 : WARNING - The /etc/profile.d/IBMsinit.sh file does NOT exist!"
fi
rm -rf CNL1913_temp

echo ""
cat /dev/null > CNL1914_temp
if [ -f /etc/profile.d/IBMsinit.csh ]; then
   grep "\$uid > 199" /etc/profile.d/IBMsinit.csh | grep "if" | grep -v "^#" > /dev/null 2>&1
   if (($?)); then
      echo "CNL.1.9.1.4 : WARNING - The required if statement does not exist in the /etc/profile.d/IBMsinit.csh file."
   else
      grep -A 2 "\$uid > 199" /etc/profile.d/IBMsinit.csh | grep -A 2 "if" | grep -vA 2 "^#" >> CNL1914_temp
      COUNT=`egrep -c "\$uid > 199|umask 077|endif" CNL1914_temp`
      if [ $COUNT -eq 3 ]; then
         echo "CNL.1.9.1.4 : The /etc/profile.d/IBMsinit.csh file appears to contain the required if statement:"
      else
         echo "CNL.1.9.1.4 : WARNING - The /etc/profile.d/IBMsinit.csh file does not appear to contain the required if statement:"
      fi
      cat CNL1914_temp >> $LOGFILE
   fi
else
   echo "CNL.1.9.1.4 : WARNING - The /etc/profile.d/IBMsinit.csh file does NOT exist!"
fi
rm -rf CNL1914_temp

echo ""
cat /dev/null > CNL1915_temp
cat /dev/null > CNL1915_tempA
if [ -f /etc/profile ]; then
   grep "/etc/profile.d/IBMsinit.sh" /etc/profile | grep -v "^#" > /dev/null 2>&1
   if (($?)); then
      echo "CNL.1.9.1.5 : WARNING - The required entry for the IBMsinit.sh script does not exist in /etc/profile."
      CNL1915Check=1
   else
      echo "CNL.1.9.1.5 : The required entry for the IBMsinit.sh script appears to exist in /etc/profile:"
      grep "/etc/profile.d/IBMsinit.sh" /etc/profile | grep -v "^#" >> $LOGFILE
      CNL1915Check=0
      FoundLine=`grep -n "/etc/profile.d/IBMsinit.sh" /etc/profile | grep -v "^#" | tail -1 | awk -F':' '{print $1}'`
      cat /etc/profile | grep -v "^#" | grep -in umask | awk -F':' '{print $1}' >> CNL1915_temp
      if [ -s CNL1915_temp ]; then
         for x in `cat CNL1915_temp`
         do
         if [ $x -gt $FoundLine ]; then
            echo "CNL.1.9.1.5 : WARNING - The umask parameter exists after the invocation of the IBMsinit.sh script in /etc/profile!"
            echo $x >> CNL1915_tempA
         fi
         done
         if [ -s CNL1915_tempA ]; then
            echo "CNL.1.9.1.5 : The following line numbers in /etc/profile contain the umask paramter, which come after the invocation of IBMsinit.sh:"
            cat CNL1915_tempA >> $LOGFILE
         fi
      else
         echo "CNL.1.9.1.5 : No entries containing umask appear after the invocation of IBMsinit.sh in /etc/profile."
      fi
   fi
   if [ -f /etc/profile.local ]; then
      grep "/etc/profile.d/IBMsinit.sh" /etc/profile.local > /dev/null 2>&1
      if (($?)); then
         if (($CNL1915Check)); then
            echo "CNL.1.9.1.5 : WARNING - The required entry for the IBMsinit.sh script does not exist in /etc/profile.local!"
         fi
      else
         echo "CNL.1.9.1.5 : The required entry for the IBMsinit.sh script appears to exist in the /etc/profile.local file:"
         grep "/etc/profile.d/IBMsinit.sh" /etc/profile.local >> $LOGFILE
         cat /dev/null > CNL1915_temp
         cat /dev/null > CNL1915_tempA
         FoundLine=`grep -n "/etc/profile.d/IBMsinit.sh" /etc/profile.local | grep -v "^#" | tail -1 | awk -F':' '{print $1}'`
         cat /etc/profile.local | grep -v "^#" | grep -in umask | awk -F':' '{print $1}' >> CNL1915_temp
         if [ -s CNL1915_temp ]; then
            for x in `cat CNL1915_temp`
            do
            if [ $x -gt $FoundLine ]; then
               echo "CNL.1.9.1.5 : WARNING - The umask parameter exists after the invocation of the IBMsinit.sh script in /etc/profile.local!"
               echo $x >> CNL1915_tempA
            fi
            done
            if [ -s CNL1915_tempA ]; then
               echo "CNL.1.9.1.5 : The following line numbers in /etc/profile.local contain the umask paramter, which come after the invocation of IBMsinit.sh:"
               cat CNL1915_tempA >> $LOGFILE
            fi
         else
            echo "CNL.1.9.1.5 : No entries containing umask appear after the invocation of IBMsinit.sh in /etc/profilelocal."
         fi
      fi
   elif (($CNL1915Check)); then
      echo "CNL.1.9.1.5 : WARNING - The /etc/profile.local file does not exist for a secondary check!"
   fi
         
else
   echo "CNL.1.9.1.5 : WARNING - The /etc/profile does NOT exist!"
fi
rm -rf CNL1915_temp CNL1915_tempA

echo ""
cat /dev/null > CNL1916_temp
cat /dev/null > CNL1916_tempA
if [ -f /etc/csh.login ]; then
   grep "/etc/profile.d/IBMsinit.csh" /etc/csh.login | grep -v "^#" > /dev/null 2>&1
   if (($?)); then
      echo "CNL.1.9.1.6 : WARNING - The required entry for the IBMsinit.csh script does not exist in /etc/csh.login."
      CNL1915Check=1
   else
      echo "CNL.1.9.1.6 : The required entry for the IBMsinit.csh script appears to exist in /etc/csh.login:"
      grep "/etc/profile.d/IBMsinit.csh" /etc/csh.login | grep -v "^#" >> $LOGFILE
      CNL1915Check=0
      FoundLine=`grep -n "/etc/profile.d/IBMsinit.csh" /etc/csh.login | grep -v "^#" | tail -1 | awk -F':' '{print $1}'`
      cat /etc/csh.login | grep -v "^#" | grep -in umask | awk -F':' '{print $1}' >> CNL1916_temp
      if [ -s CNL1916_temp ]; then
         for x in `cat CNL1916_temp`
         do
         if [ $x -gt $FoundLine ]; then
            echo "CNL.1.9.1.6 : WARNING - The umask parameter exists after the invocation of the IBMsinit.csh script in /etc/csh.login!"
            echo $x >> CNL1916_tempA
         fi
         done
         if [ -s CNL1916_tempA ]; then
            echo "CNL.1.9.1.6 : The following line numbers in /etc/csh.login contain the umask paramter, which come after the invocation of IBMsinit.csh:"
            cat CNL1916_tempA >> $LOGFILE
         fi
      else
         echo "CNL.1.9.1.6 : No entries containing umask appear after the invocation of IBMsinit.csh in /etc/csh.login."
      fi
   fi
   if [ -f /etc/csh.login.local ]; then
      grep "/etc/profile.d/IBMsinit.csh" /etc/csh.login.local > /dev/null 2>&1
      if (($?)); then
         if (($CNL1915Check)); then
            echo "CNL.1.9.1.6 : WARNING - The required entry for the IBMsinit.csh script does not exist in /etc/csh.login.local!"
         fi
      else
         echo "CNL.1.9.1.6 : The required entry for the IBMsinit.csh script appears to exist in the /etc/csh.login.local file:"
         grep "/etc/profile.d/IBMsinit.csh" /etc/csh.login.local >> $LOGFILE
         cat /dev/null > CNL1916_temp
         cat /dev/null > CNL1916_tempA
         FoundLine=`grep -n "/etc/profile.d/IBMsinit.csh" /etc/csh.login.local | grep -v "^#" | tail -1 | awk -F':' '{print $1}'`
         cat /etc/csh.login.local | grep -v "^#" | grep -in umask | awk -F':' '{print $1}' >> CNL1916_temp
         if [ -s CNL1916_temp ]; then
            for x in `cat CNL1916_temp`
            do
            if [ $x -gt $FoundLine ]; then
               echo "CNL.1.9.1.6 : WARNING - The umask parameter exists after the invocation of the IBMsinit.csh script in /etc/csh.login.local!"
               echo $x >> CNL1916_tempA
            fi
            done
            if [ -s CNL1916_tempA ]; then
               echo "CNL.1.9.1.6 : The following line numbers in /etc/csh.login.local contain the umask paramter, which come after the invocation of IBMsinit.csh:"
               cat CNL1916_tempA >> $LOGFILE
            fi
         else
            echo "CNL.1.9.1.6 : No entries containing umask appear after the invocation of IBMsinit.csh in /etc/profilelocal."
         fi
      fi
   elif (($CNL1915Check)); then
      echo "CNL.1.9.1.6 : WARNING - The /etc/csh.login.local file does not exist for a secondary check!"
   fi
         
else
   echo "CNL.1.9.1.6 : WARNING - The /etc/csh.login does NOT exist!"
fi
rm -rf CNL1916_temp CNL1916_tempA

echo ""
cat /dev/null > CNL1917_temp
for file in /etc/skel/.cshrc /etc/skel/.login /etc/skel/.profile /etc/skel/.bashrc /etc/skel/.bash_profile /etc/skel/.bash_login /etc/skel/.tcshrc
do
if [ -f $file ]; then
   grep -i umask $file | grep -v "^#" | grep -v "077" >> /dev/null 2>&1
   if ((!$?)); then
      echo $file >> CNL1917_temp
      grep -i umask $file | grep -v "^#" | grep -v "077" >> CNL1917_temp
   fi
else
   echo "CNL.1.9.1.7 : The file $file does not exist on this server."
fi
done
if [ -s CNL1917_temp ]; then
   echo "CNL.1.9.1.7 : WARNING - Skeleton files exist that appear to reset or override the umask setting:"
   cat CNL1917_temp >> $LOGFILE
else
   echo "CNL.1.9.1.7 : No skeleton files were found on the server that appear to reset or override the umask setting."
fi
rm -rf CNL1917_temp

echo ""
GOODBCNL=1
if [[ -s /etc/issue ]] && [[ ! -z `grep -v "^#" /etc/issue` ]]; then
   echo "CNL.2.0.1 : The /etc/issue file exists and contains active entries."
#   echo "Here is the contents:"; echo ""
   cat /etc/issue >> $LOGFILE
   GOODBCNL=0
   echo ""
fi
if [[ -s /etc/motd ]] && [[ ! -z `grep -v "^#" /etc/motd` ]]; then
   echo "CNL.2.0.1 : The /etc/motd file exists and contains active entries."
#   echo "Here is the contents:"; echo ""
   cat /etc/motd >> $LOGFILE
   GOODBCNL=0
   echo ""
fi
if (($GOODBCNL)); then
   echo "CNL.2.0.1 : WARNING - Both the /etc/issue and the /etc/motd files either do not exist or neither contain any active entries!"
fi

echo ""
rpm -qa | grep -q "openssh-server"
if ((!$?)); then
   echo "CNL.2.1.1 : SFTP is installed."
   which sftp > /dev/null 2>&1
   if ((!$?)); then
      which sftp >> $LOGFILE
   fi
else
   echo "CNL.2.1.1 : WARNING - SFTP does not appear to be installed."
   echo "CNL.2.1.1 : THIS SCRIPT CANNOT DO ANY FURTHER CHECKS ON THIS SECTION #!!!"
fi

echo ""
GOODBCNL=1
rpm -qa | grep -q "openssl"
if ((!$?)); then
   echo "CNL.2.1.2 : openssl is installed on this server."
   which openssl > /dev/null 2>&1
   if ((!$?)); then
      which openssl >> $LOGFILE
   fi
   GOODBCNL=0
fi
gpg --version > /dev/null 2>&1
if ((!$?)); then
   echo "CNL.2.1.2 : GPG is installed on this server."
   gpg --version | head -1 >> $LOGFILE
   GOODBCNL=0
fi
if (($GOODBCNL)); then
   echo "CNL.2.1.2 : WARNING - Neither openssl nor GPG appear to be installed on this server!"
fi

echo ""
if [ "$OSFlavor" = "RedHat" ]; then
   cat /dev/null > CNL213_temp
   for file in `ls -al /etc/pam.d | grep -v "^d" | awk '{print $9}'`
   do
   cat /etc/pam.d/$file | grep "^password" | egrep 'required|sufficient' | grep -q "pam_unix.so"
   if ((!$?)); then
      cat /etc/pam.d/$file | grep "^password" | egrep 'required|sufficient' | grep "pam_unix.so" | egrep -q 'md5|sha512'
      if (($?)); then
         echo "/etc/pam.d/$file" >> CNL213_temp
      fi
   fi
   done
   if [ $RHVER -ge 6 ]; then
      if [ -f /etc/pam.d/system-auth ]; then
         cat /etc/pam.d/system-auth | grep "^password" | egrep 'required|sufficient' | grep "pam_unix.so" | egrep -q 'md5|sha512'
         if ((!$?)); then
            echo "CNL.2.1.3 : The /etc/pam.d/system-auth file contains the password required|sufficient pam_unix.so md5 setting:"
            cat /etc/pam.d/system-auth | grep "^password" | egrep 'required|sufficient' | grep "pam_unix.so" | egrep 'md5|sha512' >> $LOGFILE
         fi
         if [ -f /etc/pam.d/password-auth ]; then
            cat /etc/pam.d/password-auth | grep "^password" | egrep 'required|sufficient' | grep "pam_unix.so" | egrep -q 'md5|sha512'
            if ((!$?)); then
               echo "CNL.2.1.3 : The /etc/pam.d/password-auth file contains the password required|sufficient pam_unix.so md5 setting:"
               cat /etc/pam.d/password-auth | grep "^password" | egrep 'required|sufficient' | grep "pam_unix.so" | egrep 'md5|sha512' >> $LOGFILE
            else
               echo "CNL.2.1.3 : WARNING - The /etc/pam.d/password-auth file does not contain the required setting!"
            fi
         else
            echo "CNL.2.1.3 : WARNING - The /etc/pam.d/password-auth file does NOT exist!"
         fi
      fi
   fi
   if [ -f /etc/pam.d/passwd ]; then
      cat /etc/pam.d/passwd | grep "^password" | egrep 'required|sufficient' | grep "pam_unix.so" | egrep -q 'md5|sha512'
      if ((!$?)); then
         echo "CNL.2.1.3 : The /etc/pam.d/passwd file contains the password required|sufficient pam_unix.so md5 setting:"
         cat /etc/pam.d/passwd | grep "^password" | egrep 'required|sufficient' | grep "pam_unix.so" | egrep 'md5|sha512' >> $LOGFILE
      fi
   elif [ -f /etc/pam.d/system-auth ]; then
      cat /etc/pam.d/system-auth | grep "^password" | egrep 'required|sufficient' | grep "pam_unix.so" | egrep -q 'md5|sha512'
      if ((!$?)); then
         echo "CNL.2.1.3 : The /etc/pam.d/system-auth file contains the password required|sufficient pam_unix.so md5 setting:"
         cat /etc/pam.d/system-auth | grep "^password" | egrep 'required|sufficient' | grep "pam_unix.so" | egrep 'md5|sha512' >> $LOGFILE
      fi
   elif [ -s CNL213_temp ]; then
      echo "CNL.2.1.3 : WARNING - File(s) exist in /etc/pam.d that have password required|sufficient pam_unix.so"
      echo "but do not have md5 or sha512 set:"
      cat CNL213_temp >> $LOGFILE
   else
      echo "CNL.2.1.3 : All file(s) in /etc/pam.d that contain password required|sufficient pam_unix.so"
      echo "have md5 or sha512 set."
   fi
   rm -rf CNL213_temp
elif [[ $OSFlavor = "SuSE" && $SVER -ge 10 ]]; then
   cat /dev/null > CNL213_temp
   for file in `ls -al /etc/pam.d | grep -v "^d" | awk '{print $9}'`
   do
   cat /etc/pam.d/$file | grep "^password" | egrep 'required|sufficient' | egrep -q 'pam_unix2.so|pam_unix_passd.so'
   if ((!$?)); then
      cat /etc/pam.d/$file | grep "^password" | egrep 'required|sufficient' | egrep 'pam_unix2.so|pam_unix_passd.so' | egrep -q 'md5|sha512'
      if (($?)); then
         echo "/etc/pam.d/$file" >> CNL213_temp
      fi
   fi
   done
   if [ -f /etc/pam.d/passwd ]; then
      cat /etc/pam.d/passwd | grep "^password" | egrep 'required|sufficient' | egrep 'pam_unix2.so|pam_unix_passd.so' | egrep -q 'md5|sha512'
      if ((!$?)); then
         echo "CNL.2.1.3 : The /etc/pam.d/passwd file contains the password required|sufficient pam_unix.so md5 setting:"
         cat /etc/pam.d/passwd | grep "^password" | egrep 'required|sufficient' | egrep 'pam_unix2.so|pam_unix_passd.so' | egrep 'md5|sha512' >> $LOGFILE
      fi
   elif [ -f /etc/pam.d/system-auth ]; then
      cat /etc/pam.d/system-auth | grep "^password" | egrep 'required|sufficient' | egrep 'pam_unix2.so|pam_unix_passd.so' | egrep -q 'md5|sha512'
      if ((!$?)); then
         echo "CNL.2.1.3 : The /etc/pam.d/system-auth file contains the password required|sufficient pam_unix.so md5 setting:"
         cat /etc/pam.d/system-auth | grep "^password" | egrep 'required|sufficient' | egrep 'pam_unix2.so|pam_unix_passd.so' | egrep 'md5|sha512' >> $LOGFILE
      fi
   elif [ -s CNL213_temp ]; then
      echo "CNL.2.1.3 : WARNING - File(s) exist in /etc/pam.d that have password required|sufficient pam_unix.so"
      echo "but do not have md5 or sha512 set:"
      cat CNL213_temp >> $LOGFILE
   else
      echo "CNL.2.1.3 : All file(s) in /etc/pam.d that contain password required|sufficient pam_unix.so"
      echo "have md5 or sha512 set."
   fi
   rm -rf CNL213_temp
elif [[ $OSFlavor = "SuSE" && $SVER -le 9 ]]; then
   cat /dev/null > CNL213_temp
   for file in `ls -al /etc/pam.d | grep -v "^d" | awk '{print $9}'`
   do
   cat /etc/pam.d/$file | grep "^password" | egrep 'required|sufficient' | grep -q "pam_unix.so"
   if ((!$?)); then
      cat /etc/pam.d/$file | grep "^password" | egrep 'required|sufficient' | grep "pam_unix.so" | egrep -q 'md5|sha512'
      if (($?)); then
         echo "/etc/pam.d/$file" >> CNL213_temp
      fi
   fi
   done
   if [ -f /etc/pam.d/passwd ]; then
      cat /etc/pam.d/passwd | grep "^password" | egrep 'required|sufficient' | grep "pam_unix.so" | egrep -q 'md5|sha512'
      if ((!$?)); then
         echo "CNL.2.1.3 : The /etc/pam.d/passwd file contains the password required|sufficient pam_unix.so md5 setting:"
         cat /etc/pam.d/passwd | grep "^password" | egrep 'required|sufficient' | grep "pam_unix.so" | egrep 'md5|sha512' >> $LOGFILE
      fi
   elif [ -f /etc/pam.d/system-auth ]; then
      cat /etc/pam.d/system-auth | grep "^password" | egrep 'required|sufficient' | grep "pam_unix.so" | egrep -q 'md5|sha512'
      if ((!$?)); then
         echo "CNL.2.1.3 : The /etc/pam.d/system-auth file contains the password required|sufficient pam_unix.so md5 setting:"
         cat /etc/pam.d/system-auth | grep "^password" | egrep 'required|sufficient' | grep "pam_unix.so" | egrep 'md5|sha512' >> $LOGFILE
      fi
   elif [ -s CNL213_temp ]; then
      echo "CNL.2.1.3 : WARNING - File(s) exist in /etc/pam.d that have password required|sufficient pam_unix.so"
      echo "but do not have md5 or sha512 set:"
      cat CNL213_temp >> $LOGFILE
   else
      echo "CNL.2.1.3 : All file(s) in /etc/pam.d that contain password required|sufficient pam_unix.so"
      echo "have md5 or sha512 set."
   fi
   rm -rf CNL213_temp
else
   echo "CNL.2.1.3 : WARNING - THIS IS AN UNSUPPORTED VERSION OF LINUX AND CANNOT BE CHCKED!!!"
fi

echo ""
cat /dev/null > CNL214_temp
for ID in `cat /etc/passwd | awk -F':' '{print $1}'`
do
IDhome=`grep "^$ID:" /etc/passwd | awk -F':' '{print $6}'`
if [[ -n $IDhome ]] && [[ -d $IDhome ]]; then
   if [ -d $IDhome/.ssh ]; then
      if [ -f $IDhome/.ssh/id_rsa ]; then
         PERM=`ls -al $IDhome/.ssh/id_rsa | awk '{print $1}' | cut -c5-6,8-9`
         if [ $PERM != "----" ]; then
            echo "$ID:" >> CNL214_temp
            ls -al $IDhome/.ssh/id_rsa >> CNL214_temp
            echo "" >> CNL214_temp
         fi
      fi
   fi
fi
done
echo "CNL.2.1.4 : THIS SCRIPT CAN ONLY CHECK LOCAL USERS!"
if [ -s CNL214_temp ]; then
   echo "CNL.2.1.4 : WARNING - The following users have private keys that are readable and/or writeable by other than the owner:"
   cat CNL214_temp >> $LOGFILE
else
   echo "CNL.2.1.4 : All local users were checked and no private keys were found that were readable and/or writeable by other than the owner."
fi
rm -rf CNL214_temp $LOGFILE

