X=1
LOGFILE=/tmp/permission.txt
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

