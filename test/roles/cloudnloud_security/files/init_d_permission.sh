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

