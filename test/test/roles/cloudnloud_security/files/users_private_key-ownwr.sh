cat /dev/null > AD214_temp
for ID in `cat /etc/passwd | awk -F':' '{print $1}'`
do
IDhome=`grep "^$ID:" /etc/passwd | awk -F':' '{print $6}'`
if [[ -n $IDhome ]] && [[ -d $IDhome ]]; then
   if [ -d $IDhome/.ssh ]; then
      if [ -f $IDhome/.ssh/id_rsa ]; then
         PERM=`ls -al $IDhome/.ssh/id_rsa | awk '{print $1}' | cut -c5-6,8-9`
         if [ $PERM != "----" ]; then
            echo "$ID:" >> AD214_temp
            ls -al $IDhome/.ssh/id_rsa >> AD214_temp
            echo "" >> AD214_temp
         fi
      fi
   fi
fi
done
echo " THIS SCRIPT CAN ONLY CHECK LOCAL USERS!"
if [ -s AD214_temp ]; then
   echo " WARNING - The following users have private keys that are readable and/or writeable by other than the owner:"
   cat AD214_temp >> $LOGFILE
else
   echo " All local users were checked and no private keys were found that were readable and/or writeable by other than the owner."
fi
rm -rf AD214_temp

