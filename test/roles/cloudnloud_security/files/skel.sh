cat /dev/null > AD1917_temp
for file in /etc/skel/.cshrc /etc/skel/.login /etc/skel/.profile /etc/skel/.bashrc /etc/skel/.bash_profile /etc/skel/.bash_login /etc/skel/.tcshrc
do
if [ -f $file ]; then
   grep -i umask $file | grep -v "^#" | grep -v "077" >> /dev/null 2>&1
   if ((!$?)); then
      echo $file >> AD1917_temp
      grep -i umask $file | grep -v "^#" | grep -v "077" >> AD1917_temp
   fi
else
   echo "AD.1.9.1.7 : The file $file does not exist on this server."
fi
done
if [ -s AD1917_temp ]; then
   echo "AD.1.9.1.7 : WARNING - Skeleton files exist that appear to reset or override the umask setting:"
  # cat AD1917_temp >> $LOGFILE
else
   echo "AD.1.9.1.7 : No skeleton files were found on the server that appear to reset or override the umask setting."
fi
rm -rf AD1917_temp

